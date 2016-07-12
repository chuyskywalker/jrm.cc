---
title: "Home Cluster (Part III): Docker Networking"
date: 2016-06-07
series: [ "Home Cluster" ]
---

My primary development and deployment technology these days is Docker. I've probably gone a bit overboard on it (but not yet so much I'm using it to [sandbox my desktop](https://blog.jessfraz.com/post/docker-containers-on-the-desktop/)).

## Basic Networking

When you're working on a single machine, a basic out-of-the-box Docker install works really great. Especially in 1.10+ versions, with various networking and discovery upgrades, it's very easy to connect from container to container. However, I'm building a cluster -- so these containers need to talk across hosts. Additionally, I want everything to be reachable from the rest of my network as well.

Docker's default _modus operandi_ for this is to do "port mapping" -- you tell `docker run` that port N on the host should be mapped to port Y in the container. This works relatively well until things start to collide -- what if you have two web servers that both want a port 80 allocation? Well, only one of them can get it. This isn't a big deal, really, just give the second container port 81 on the host, but how do you tell other systems to go to port 81 instead?

## Routing Between Machines

There are a few routes you can go down when you want traffic to flow sanely between multiple docker hosts:

1. Service Discovery
2. Overlay Networks
3. Routable IPs

### Service Discovery

The first path, Service Discovery, implies that each container registers its location (host ip + mapped port) with a central repository. All other services must look up connection details from the registry. This can work well, and my favorite tool for the job is Consul, but it has the downside that getting all the fiddly bits worked out can be hair-pullingly complicated.

Running a consul agent on the host, it becomes impractical to execute shell checks _inside_ a container very effectively. Consul *does* support `docker exec` style checks, but the performance of doing so every 5 seconds for a lot of containers is quite poor. That leaves you with only http, tcp, or ttl checks negating an entire arena of premade Nagio script checks. Additionally, registering containers (and deregistering) can be problematic

You can, alternatively, put a consul agent inside your container which is ideal from a deployment perspective, but you now have the problem that the IP consul finds is an unroutable (across hosts) `172...` address. So, you have to chicken-peck-hack the host ip _and_ mapped port into the container. And you have to setup port mappings so that other consul agents can correctly gossip to this internal consul agent. Ugh.

There are ways to alleviate this a bit. [Registrator](https://github.com/gliderlabs/registrator), for example, is very useful but the approach has a limited shelf life, in my opinion. The automated tooling is too basic and if you want to really take advantage of the consul's power, you end up with too much manual orchestration.

### Overlay Networks

One of the major recent upgrades to Docker was adding support for "overlay networks". The gist of it is that you can create a `network` than is discoverable and spans across multiple docker hosts. I won't lie, I spent _some_ time experimenting with this, but I didn't find it very palettable. First, you need to have a working k/v store in place (which I do, with consul), but since I run consul _from_ docker, and it wants this service up when the daemon starts, it gets kinda weird.

Ultimately, what really killed it for me was that I had a hard time getting traffic into the cluster from other non-overlay-networked machines in my system. Back to port mapping? Nah, thanks.

I don't know if there are any major/minor performance concerns with the overlay network setup either, but I imagine there's got to be some; not a huge turn-off since I never really explored the path enough to find that out, but I'd be willing to bet...

### Routable IPs

Why not have Docker create containers with real, in-your-network, IP addresses? This is the setup I went for, and it solves a plethora of problems. First, it allows any machine or container, to reach any container. Secondly, you'll never have a port mapping conflict. Third, you can run secondary services in your container, ala consul, without any crazy hacky work arounds.

Getting Docker to do this, however, was a bit of a headache. Here's how I go about this on Ubuntu 16.04 hosts...

## Setting Up Routable IPs in Docker

A lot of research, trial, and error went in to figuring out how to get Docker to work as I wanted -- a big thanks to Stefan who covered a lot of this in "[Poor Men's Routable Container IPs](http://sttts.github.io/docker/network/2015/01/31/poor-mens-cluster-container-ips.html)"

First, I setup my router to claim the ip address `192.168.1.1` and subnet `255.255.0.0` (a `/16`). This gave my LAN 65k viable IP addresses. This is important because for each docker host, you end up carving out as many IPs as you expect to run containers on that host. Since this is my home setup, I opted for 256 per host (`/24`) but in a larger system this could be much larger.

Once the network space was setup, I started in on each of my thre Ubuntu 16.04 servers by adding a new bridged adapter to `/etc/network/interfaces`

```text
auto br0
iface br0 inet static
    address 192.168.1.51
    netmask 255.255.0.0
    bridge_ports enp1s0
    bridge_stp off
    bridge_fd 0
```

_(The IPs i used for the three machines are 51/52/53)_

Now, keep in mind the current primary adapter (enp1s0 in my case) already has that IP/subnet combo. So the next step, in one fell swoop command, will bring up br0 and release the IP on the ethernet interface:

```bash
ifup br0; ifconfig enp1s0 0.0.0.0
```

I also needed to add a default route at this point so containers would be able to hit the internet:

```bash
route add default gw 192.168.1.1 br0
```

With that in place, it was time to tell the docker daemon to start using it and hand out IP addresses.

With Ubuntu on systemd, I needed to override the default startup commands to tell docker a few things:

```bash
# Override docker start command to:
#  - use br0
#  - assign IPs from a fixed pool of 256 possible options which are
#    related to the last digit of my host IP
#  - give containers the correct gateway (not host ip)
#  - not do any kind of network magic
mkdir -p /etc/systemd/system/docker.service.d
cat <<EOF > /etc/systemd/system/docker.service.d/local.conf
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// \
                                 -H unix:///var/run/docker.sock \
                                 --bridge=br0 \
                                 --fixed-cidr=192.168.51.0/24 \
                                 --default-gateway=192.168.1.1 \
                                 --ip-forward=false \
                                 --ip-masq=false \
                                 --iptables=false
EOF
```

Now a quick docker restart...

```bash
systemctl daemon-reload && systemctl restart docker
```

...and from here on out all containers get real, routable ip addresses!

```bash
# docker run --rm -ti centos:7 bash -c 'yum install -q -y net-tools; ifconfig'
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.51.4  netmask 255.255.0.0  broadcast 0.0.0.0
        inet6 fe80::42:c0ff:fea8:3404  prefixlen 64  scopeid 0x20<link>
        ether 02:42:c0:a8:34:04  txqueuelen 0  (Ethernet)
        RX packets 5385  bytes 11641421 (11.1 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 4062  bytes 277323 (270.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

Setup as such I no longer have to contend with weird mapping scenarios, port conflicts, or inside/outside routing layers. Containers, from a network perspective, look and act like any other host on the network. Integrating with almost any application becomes a breeze and simply getting to basic contaienrs is supremely easy now.

Overall, I _*highly*_ recommend this setup; containers with real IP addresses is simple in execution, highly functional, and doesn't add any significant overhead making it a wonderful runstate for containers.
