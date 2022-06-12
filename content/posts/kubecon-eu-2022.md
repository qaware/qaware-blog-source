---
title: "KubeCon 2022" # todo
date: 2021-08-16T16:57:04+02:00 # todo
draft: true
author: "[Alex Krause](https://github.com/alex0ptr)" # add yourself
image: "" # todo
tags: ["Cloud", "Cloud Native", "Kubernetes"]
summary: "" # todo
---

KubeCon Valencia summary blablabla.

Topics (TODO: remove after done with post):
- [ ] Remote Experience
- [ ] Community
- [ ] Women in Tech
- [ ] Products
- [x] New Standards and APIs

Alex:
> My highlights were Crossplane, eBPF pixie and slsa.dev...

Felix: New Standards and APIs!

### CloudEvents: New standard for universal message exchange

Nearly every project in the CNCF landscapes either produces or consumes some kind of event. For example, Prometheus has a PagerDuty integration, KubeEdge has an MQTT integration, and Falco Sidekick can stream data to Slack/Email/S3 and more. A lot of development effort is spent on producing custom integrations (resulting in code duplication and fragility), and many of these protocols are strongly opinionated, resulting in potential isolation.

The new CloudEvents standard (introduced by the CNCF Serverless WG) seeks to define itself as a universal envelope around events, with drop-in support for consumers and producers. Once enough event producers have adopted the lossless, offline-mode-compatible standard, switching out message delivery protocols (for example, Kafka instead of HTTP) should become "trivially possible". Even Microsoft Azure has a beta implementation of the protocol's event registry.


### New Kubernetes Gateway API 

Another novelty in the realm of standardization will be the new Kubernetes-native Gateway API, which supports more use cases than the limited Ingress API and overloaded Service API. These use cases entail load-balancing and routing, with many options for advanced configuration such as head-based matching and traffic weighing. It’s meant to be a standard interface for heterogeneous gateway providers, such as Traefik, Kong, Kuma, Consul, or GKE.

To allow for portability, implementations of the API can choose to fulfill one of several levels of conformity. Major features include the binding of routes to gateways (instead of the opposite), Kubernetes-native typization of routes, the ability to attach RetryPolicies and HealthCheckPolicies to services and gateways, and cross-namespace sharing of resources.
