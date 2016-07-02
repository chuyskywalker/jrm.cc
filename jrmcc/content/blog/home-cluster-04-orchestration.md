---
title: "Home Cluster (Part IV): Orchestration"
date: 2016-06-10
series: [ "Home Cluster" ]
---

In this leg of my journey, let's discuss  _why_ a cluster is useful, and how to make the most use of such a setup.

## What's a Cluster Good For Anyway?

With a single server, you run all services in one place. If the server goes down, you turn it back on and all the services start back up. This server, in which a single machine failure causes services to become unavailable, is called a SPOF: a _Single Point Of Failure_.

When running a single server, the question "Where do I run service X?" only has a single answer -- on that one server.

A cluster's priamry purpose is to have no single points of failure. This is known as _redundancy_. Secondarily, a cluster gives you more computing power overall as well.

So far, for redudancy I have put three phsyical machines into place. This ensures that if a ram module goes bad, processor dies, power supply shorts, etc that I've still got available hardware to run my services.

However, I have not yet addressed using all that computing power effectively or what happens when a one of those physical machines does go away.

## Orcheststration

"Orchestration", the management of a cluster, is a big topic. That said, I find it primarily boils down to two topics: _Scheduling_ and _Life Cycle Management_.

### Scheduling

With multiple machines available for running a service, where do you place it in the cluster? You'll need a way to figure out what a service needs (ram, cpu, diskspace, etc) what machines have those resources, and get that deployed.

A scheduler takes care of this problem of giving you a framework (job specs) to specify and then using those for all services to figuring out where each  should be run.

By using this system, the process of dynamically adding/removing/updating services across a cluster you let the computers do all the heavy lifting of figuring out how to make it all fit by way of declarative means instead of imperative.

### Life Cycle Management

While the scheduler has done the arduous job of figuring out where everything goes, another vitally important aspect of an orchestrator is defining what happens over the life time of your services and the cluster itself.

The orchestrator must know how to handle individual services failing. Usually it will need rules for restarting services, or to perhaps not. The orchestator must also know how to handle a machine failure -- does it reschedule the services that were lost? What happens when that system comes back up after a restart?

This process is a vital extension of the scheduler, as the cluster evolves over time.

### Orchestrator Contenters

While Orchestration is not a truly new problem, there has been a flurry of activity in this area over the last few years. I think the issue has simply become digestable for companies that aren't on that super-scale. The rise of microservices has also helped to illuminate the need for better system management. If you look to places like VMWare it's been around for a while, but it's really come down to a more opensource and community level in the last few years with the release of several large projects out there. In no specific order:

- [CoreOS / Fleet](https://coreos.com/)
- [Kubernetes](http://kubernetes.io/)
- [Mesos](http://mesos.apache.org/)
  - [Marathon](https://mesosphere.github.io/marathon/)
  - [Aurora](http://aurora.apache.org/)
- [DC/OS](https://dcos.io/)
- [Docker Swarm](https://docs.docker.com/swarm/)
- [Nomad](https://www.nomadproject.io/)

There is TONS of information and comparisions out there about each of these, but for my personal pusposes, I have chosen to go with Nomad. It's not quite as powerful as some of the other services, but it easily does everything I need in an orchestrator and is phenominally easy to deploy and get working on pretty much any system in existence.

I'll get into Nomad more in my next blog post.
