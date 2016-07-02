---
title: "Home Cluster (Part V): Nomad"
date: 2016-06-15
series: [ "Home Cluster" ]
draft: true
---

As covered in my last post about Orchestration, I decided go utilize Nomad for my cluster manager.

I'll _very_ quickly cover why I didn't go with other options -- keep in mind these only apply to my *personal* usage which is a different context than professional applications.

Option | Dilemma
--- | ---
[CoreOS+Fleet](https://coreos.com/) | I simply wasn't comfortable with the baremetal OS being something I was so unfamiliar with (this being my home project, I've only got me to rely on)
[Kubernetes](http://kubernetes.io/) | I didn't try this one, tbh.
[Mesos](http://mesos.apache.org/)/[DC/OS](https://dcos.io/) | I found mesos too...technical. "Raw", perhaps? DC/os is supposed to fix that, but it was all a bit overwhelming.
[Docker&nbsp;Swarm](https://docs.docker.com/swarm/) | Scheduling was fine, but life cycle management was terrible. This is prior to release 1.12 in which swarm was directly integrated to Docker. Even then, though, the lack of _jobspec_ type files really bothers me.
&nbsp;

## Nomad - Basic Install and Cluster Setup

I'll admit it -- I'm a Hashicorp fanboy. I've yet to run into a product of theirs that wasn't just absolutely fantastic in clearly defining the problem its solving and attacking that effectively. Nomad is no exception to this: a single binary installation (thanks `golang`!) makes it very easy to get installed. Running it is super simple as well, the basic install demo couldn't be easier:

```bash
# Download!
wget https://releases.hashicorp.com/nomad/0.4.0/nomad_0.4.0_linux_amd64.zip

# Extract!
unzip nomad_0.4.0_linux_amd64.zip

# Run!
./nomad agent -dev
```

Done! You can now use another terminal and the `nomad run` command to push jobs to your instance.

For a more complete setup, this is how I configure my three nodes to startup:

```bash

MYIP=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')

cat <<EOF > /etc/nomad.hcl

bind_addr = "${MYIP}"
data_dir = "/tmp/nomad"

name = "`hostname`"

leave_on_interrupt = true
leave_on_terminate = true

disable_update_check = true

# In a nomad cluster you have "servers" which coordinate jobs and you have
# "clients" upon which jobs are executed. In a larger installation you'd want
# the servers to be separate so that a bad job doesn't cause the overall
# system to go down. Since I only have three machines, however, they all get
# to operate as servers & clients.
server {
  enabled = true
  bootstrap_expect = 3
  retry_join = [ "192.168.1.51", "192.168.1.52", "192.168.1.53" ]
}
client {
  enabled = true
  servers = [ "192.168.1.51", "192.168.1.52", "192.168.1.53" ]
}
EOF

# I run this container with host networing to make it easier to reach (by ip)
# The docker socket is mounted it so that Nomad can control docker.
# The `/tmp` mount is to work around a bug:
#  - https://github.com/hashicorp/nomad/issues/1080
docker run -d --net=host --name nomad \
 --restart=unless-stopped \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v /tmp:/tmp \
 -v /etc/nomad.hcl:/etc/nomad.hcl \
 chuyskwyalker/nomad:0.3.2 agent -config /etc/nomad.hcl
```

You can find [my Nomad dockerfile here](https://github.com/chuyskywalker/docker-nomad/blob/master/Dockerfile).

It's important to note that I am running Nomad in a docker container and that has certain limitations. Specifically, I am unable to effectively use most `task drivers` since Nomad isn't operating at the host level. However, since I only plan to use Nomad for managing docker containers, this isn't a huge downside for me.

## Nomad - Usage

Now that I have all my machines running Nomad, how do I use it? Well, first off go read up on the documenation about the job file over. Now, if you're curious about how I build this blog for deployment, you're welcome to pop over to [my build script](https://github.com/chuyskywalker/jrm.cc/blob/master/build-static.sh), but we're here to cover the job file itself:

```bash
# The overall "job"
job "jrmcc-nomad" {

    # This job is a "service" -- a single "instance" of it
    # - (https://www.nomadproject.io/docs/jobspec/schedulers.html)
    type = "service"

    # It's annoying that I _have_ to define this since it's the default...
    datacenters = [ "dc1" ]

    # Tasks can be grouped to ensure they run in the same nomad client
    # Useful if you need to ensure "sidecars" are located near one another
    group "jrmcc-web" {

        # I only need one blog up at a time, I could achieve a bit higher
        # resiliency with multiple instances, but since Nomad will restart
        # this one anyway, I'm ok with this setup
        count = 1

        # Getting down to brass-tacks here -- what is actually to be run
        task "jrmcc-web-frontend" {

            # It's a docker container
            driver = "docker"

            # Here's the docker configuration(s)
            config {
                image = "registry.service.consul/jrmcc"
            }

            # For this task, demand XYZ resources
            resources {
                memory = 256
            }
        }
    }
}
```

My simple needs are met with a relatively simple configuration. To execute that, I have a pretty simple set of commands:

```bash
docker cp ~/gits/jrmcc/deploy/nomad.hcl nomad:/tmp/nomad.hcl
docker exec -ti nomad nomad run -address=http://192.168.1.51:4646 /tmp/nomad.hcl
```

Basically, I copy the job file into the running container and then use that same container to push the config to the `run` command of the nomad instance. A few moments later my container with the blog is up and running. Right after that, consul in the container has kicked in, registered the service, and my in-house dns requests now resolve `http://jrmcc.service.consul` and my blog is up. A few moments after that, an nginx load balancer is reconfigured to point where this instance is running and the external traffic to my house see's a new website. Ta da!

# Nomad - Conclusion

I, personally, find Nomad to do everything I need in an orchestrator. More importantly, it does those things well, is super simple to configure, has great integration with other Hashicorp products (like consul), and has been stable. 

Now that I have Nomad in place, I can rely on my mini-cluster to keep all my sites up in the face of catastrophic system failure.