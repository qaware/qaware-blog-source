---
title: "ContainerDays 2018: Top talks on day 2"
date: 2018-07-11T15:06:32+02:00
draft: false
image: ContainerDays-Logo-2017.png
author: "Moritz Kammerer"
tags: [Conference, Cloud, GitKube, Microservices, Metrics, Istio, OpenCensus, DDD, CQRS, Containers, Vault, Security] 
aliases:
    - /posts/2018-07-11-container-days-2/
summary: I attended the ContainerDays 2018 in Hamburg and want to give you a short summary of the talks I visited.
---
I attended the ContainerDays 2018 in the Hamburg Hafenmuseum. It was a very cool location midst containers (the real ones), cranes and big freight ships. There were three stages, the coolest stage was definitely in the belly of an old ship. I‘ll write about the talks I visited and give a short summary. You find a list of all talks here: [https://containerdays.io/program/conference-day-2.html](https://containerdays.io/program/conference-day-2.html). Videos are coming soon – I’ll edit this post when they are available.

Update: Here they are: [https://www.youtube.com/playlist?list=PLHhKcdBlprMcVSL5OmlzyUrFtc7ib1V4w](https://www.youtube.com/playlist?list=PLHhKcdBlprMcVSL5OmlzyUrFtc7ib1V4w)
 
## One Cluster to Rule Them All - Multi-Tenancy for 1k Users
Lutz Behnke from the HAW Hamburg (Hamburg University of Applied Sciences) talked about running a private cloud in a university. Their requirements on a cloud are somewhat different from what you see in the private sector: Sometimes they just need a small web server to serve a static web page for a student, sometimes they need loads of GPUs for computing a heavy research project. All that should be easily available to more than 1000 students, which are reluctant to read documentation.

They had to build that from the ground up, as universities mostly can’t use AWS, Google Cloud etc. The first version was based on VMware, but that was scrapped quickly: Students overestimated their requirements on resources and requested quad core CPUs with a load of memory to just serve their small web application they needed for their network course. After the course was done, no one released the resources. Of course no student ever applied security patches to these eternally running virtual machines.

The second version of the private cloud is based on Kubernetes (k8s). K8s should in theory support multi-tenancy, but everyone understands that concept a little bit differently. The HAW needed LDAP authentication in k8s, so they built a small tool called kubelogin, which authenticates against a LDAP server. The authorization is managed via GitLab groups, and they built a tool which syncs these GitLab groups back into k8s. Rook.io is used for the distributed storage.

They already solved many problems and the solutions have been communicated back into the Multitenancy Working Group. But some problems are still unsolved: How to handle the logs from 2000+ nodes? How to share GPU nodes? They also ran into problems with etcd – the default of 2 GB storage space is too little when you have high pod churn.

One lesson learned: Even when every of your nodes is cattle, etcd is your pet. They published all the work done on their website [http://hypathia.net/en/](http://hypathia.net/en/).
 
## Lightning Talk: Gitkube: Continuous Deployment to Kubernetes using Git Push
Shahidh K. Muhammed from Hasura talked about GitKube. He isn‘t happy with the current deployment flow when using k8s and wants something similar to Heroku, where you just push code to a git remote and the system does the rest: compiling, packaging, deploying. He showed us GitKube ([https://github.com/hasura/gitkube](https://github.com/hasura/gitkube)), which works by using git hooks. When you push to the git remote, a special worker in the k8s cluster builds, packages and deploys the code. He demonstrated the whole setup in a live demonstration. Very cool!
 
## Distributed Microservices Metrics and Tracing with Istio and OpenCensus
Sandeep Dinesh from Google talked about the microservice hype, metrics, tracing and Istio. Turns out that microservices, for all their glory, have downsides: They increase the complexity in infrastructure, development and introduce more latency. Also tracing the request through multiple services and metrics collection gets a lot harder.

For distributed tracing, you need in essence: a trace id generator, passing of the trace id to downstream services, span (service and method calls) to collector sending and finally some data processing of these traces and spans in the collector. An example of such a processing tool is Zipkin ([https://zipkin.io/](https://zipkin.io/)). As you don‘t want vendor locking to one tracing tool, Google created a new initiative called OpenCensus ([https://opencensus.io/](https://opencensus.io/)). This decouples the implementation (e.g. Zipkin) from the API to which the service is compiled to.

Istio, which uses sidecars to instrument and trace services on k8s, also supports OpenCensus. Istio takes care, for example, of monitoring the incoming and outgoing traffic. It also creates the trace id, if none is available. As Istio can‘t look in the k8s service, you need to call the OpenCensus API to create the spans. Istio then merges the spans from OpenCensus with its own observed behavior and reports it to the collector.

Sandeep showed all of that in a live demonstration and also emphasized that the whole stack is early development and should not be used in production.
 
## Applying (D)DDD and CQ(R)S to Cloud Architectures
Benjamin Nothdurft talked about domain driven design (DDD) and high level architecture. He explained a technique to find the bounded contexts of your domain and gave an introduction into CQRS.

CQRS is essentially splitting your models into two: one for querying, one for updating. In the software Benjamin presented, they used JPA and a relational database for the update model and an ElasticSearch instance for the querying model. They also split the service into two, one for updating, one for querying. When updating the data, the update event is put in a queue. The querying service processes the events from the queue and applies the updates on the querying model.

This, of course, complicates the whole system and makes sense when you have an asymmetric load – in this case the querying side had to be scaled independently from the updating side.
 
## Containers on billions of devices
Alexander Sack from Pantarcor talked about containers on devices. In his talk, a device can be a router, a drone, a tablet etc. He excluded the smaller things, like embedded sensors or actors.

The way these devices are built today is as follows: Design the hardware and the firmware, then develop this software, assemble the hardware in the factory, put the software on it and then never touch it until end of life. One of the things lost this way is security. A better way would be to pick general stock hardware and peripherals, assemble them in a chassis and put some general purpose software on it. The device specific software can then be developed and updated even after the device has been shipped to the customer.

One way to do that is - you guessed it - with containers! There are already some products which do this, for example resin.io using Docker containers. The problem using Docker containers is that they are really heavy on the disk and not that suitable for smaller devices, with, say, 8 MB of flash space.

Pantarcor developed a solution which is completely open source. They are packaging the whole system in containers, with a small hypervisor to orchestrate the containers and to update the base system. They are using LXC containers under the hood, which lowers the space consumption. PantaHub ([https://www.pantahub.com/](https://www.pantahub.com/)) is their UI to manage the devices.
 
## Secret Management with Hashicorp's Vault
Daniel Bornkessel from innoQ talked about Vault ([https://www.vaultproject.io/](https://www.vaultproject.io/). Vault manages application secrets like encryption keys, database credentials and more. It also does credential rolling, revocation of credentials and auditing.

He explained the architecture and concepts of Vault: A client authenticates to the Vault server, Vault uses a connector to read (or generate) the secret (e.g. the database credentials). The authentication is pluggable and supports multiple plugins, like hard-coded secrets, k8s security or AWS credentials.

Vault also supports generating credentials on the fly. It can, for example, log into your PostgreSQL database, create a user name and password on the fly and hand it to the client. When the client authentication expires, it cleans up the user in PostgreSQL. That way there are no hard-coded passwords. This is definitely a big win for security!