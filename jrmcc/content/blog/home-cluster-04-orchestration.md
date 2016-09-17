---
title: "Home Cluster (Part IV): Orchestration"
date: 2016-06-10
series: [ "Home Cluster" ]
---

In this leg of my journey, let's discuss  _why_ a cluster is useful, and how to make the most use of such a setup.

## What's a Cluster Good For Anyway?

With a single server, you run all services in one place. If the server goes down, you turn it back on and all the services start back up. This server, in which a single machine failure causes services to become unavailable, is called a SPOF: a _Single Point Of Failure_.

When running a single server, the question "Where do I run service X?" only has a single answer -- on that one server.

A cluster provides two important benefits; more computing power and the ability to survive a single point of failure. The later is known as _redundancy_.

So far, for redudancy I have put three phsyical machines into place. This ensures that if a ram module goes bad, processor dies, power supply shorts, etc that I've still got available hardware to run my services.

However, I have not yet addressed using all that computing power effectively or what happens when a one of those physical machines does go away.

## Orcheststration

"Orchestration", the management of a cluster, is a big topic. That said, I find it primarily boils down to two topics: _Scheduling_ and _Life Cycle Management_.

### Scheduling

With multiple machines available for running a service, where do you place it in the cluster? You'll need a way to figure out what a service needs (ram, cpu, diskspace, etc) what machines have those resources, and get that deployed.

A scheduler takes care of this problem by providing you a way to declare "I want my service to exist in _this_ state, and it will need _these_ resources (ram, cpu, etc)". You provide this specification to the scheduler and it does the computational work of finding a place to put it, and doing so.

### Life Cycle Management

While the scheduler has done the arduous job of figuring out where everything goes, another vitally important aspect of an orchestrator is defining what happens over the life time of your services and the cluster itself.

The orchestrator must know how to handle individual services failing. Usually it will need rules for restarting services, or to perhaps not. The orchestator must also know how to handle a machine failure -- does it reschedule the services that were lost? What happens when that system comes back up after a restart?

This process is a vital extension of the scheduler, as the cluster evolves over time.

### Orchestrator Contenters

While Orchestration is not a truly new problem, there has been a flurry of activity in this area over the last few years. In part, the rise of microservices has helped to illuminate the need for better service management. But, if you look to places like VMWare this concept has been around for a while. The change, as of late, has really come down to a more opensource and community level with the release of several large projects for orchestration. In no specific order:

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
