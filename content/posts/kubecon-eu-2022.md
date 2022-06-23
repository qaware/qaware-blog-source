---
title: "The highlights of KubeCon + CloudNativeCon EU 2022" # todo
date: 2021-08-16T16:57:04+02:00 # todo
draft: true
author: "[Alex Krause](https://github.com/alex0ptr), [Felix Kampfer](https://github.com/FelixKampfer), [Sebastian Macke](https://github.com/s-macke), [Markus Zimmermann](https://github.com/markuszm)" # add yourself
image: "KubeConEU2022_GroupPhoto.jpg"
tags: ["Cloud", "Cloud Native", "Kubernetes"]
summary: "Our highlights of the KubeCon + CloudNativeCon EU 2022."
---

The KubeCon + CloudNativeCon Europe is the most important conference for Cloud Native hosted by the Cloud Native Computing Foundation. After 2 years of remote conferences, it was a great opportunity for us to go to this big conference in Valencia to learn everything new about Cloud Native and have interesting conversations with the leaders in the Cloud Native space.

One could feel the enthusiasm around Open Source and the whole community working together to improve the Cloud Native Landscape. There was a lot to do during the conference: from around 8 tracks of talks at the same time, workshops and two big halls of company and project booths to visit. We had the experience that talking directly to the maintainers at the booth of a project was very worthwhile to understand the key features and directly ask some deeper technical questions for the use-cases we could have in our day to day business. Still, there were also some interesting talks that inspired us to evaluate new Cloud Native projects.

Overall, there was a lot of content and we could write a very long post about each trending topic. Instead, we want to keep it short and worthwhile for you with the topics we found as most important to us and which could change the landscape of Cloud Native in the future.

Topics (TODO: remove after done with post):
- [ ] Remote Experience
- [ ] Community
- [ ] Women in Tech
- [ ] CNCF Projects
  - [ ] Cilium
  - [ ] Pixie
  - [ ] slsa.dev
- [ ] Products
- [x] New Standards and APIs

### Crossplane: Compliant Self Service Infrastructure

Crossplane is a framework to extend Kubernetes to define your own custom control plane to manage any API.
Its primary use-case is to provision and manage cloud infrastructure.
It does so by allowing you to build compositions tailored to your needs and make them usable for the users of your Kubernetes cluster as a CRD.
This is similar to how a Postgres Terraform module is an abstraction for creating an RDS instance in AWS with a matching secret in your Kubernetes cluster containing the service password.
However, from a developer perspective Crossplane enables the definition of the application configuration from pure Kubernetes manifests - finally including the required infrastructure in the same GitOps repository.
Otherwise developers would also have to manage additional Terraform/Pulumi/CloudFormation code, ususally in another GitOps repository, and make sure it stays in sync with application promotions.
Additionally, Crossplane allows more fine grained control for platform engineers on which infrastructure or compositions can be used by the developers by defining Kubernetes Admission controller policies using [Gatekeeper](https://github.com/open-policy-agent/gatekeeper) or [Kyverno](https://github.com/kyverno/kyverno).
Crossplane has been a CNCF incubating project for almost a year.
During this years' KubeCon EU there were eight sessions around Crossplane.
The high attendee count at the [Crossplane maintainer session](https://www.youtube.com/watch?v=xECc7XlD5kY) forced the organizers to limit physical participation for security reasons, which is an indicator for the large impact Crossplane could have.

### New Kubernetes Gateway API 

Another novelty in the realm of standardization will be the new Kubernetes-native Gateway API, which supports more use cases than the limited Ingress API and overloaded Service API. These use cases entail load-balancing and routing, with many options for advanced configuration such as head-based matching and traffic weighing. It’s meant to be a standard interface for heterogeneous gateway providers, such as Traefik, Kong, Kuma, Consul, or GKE.

To allow for portability, implementations of the API can choose to fulfill one of several levels of conformity. Major features include the binding of routes to gateways (instead of the opposite), Kubernetes-native typization of routes, the ability to attach RetryPolicies and HealthCheckPolicies to services and gateways, and cross-namespace sharing of resources.

### Cilium: The Future Of Service Meshes?

Service Meshes were a prominent topic at this KubeCon. There were lots of experience reports on [Linkerd](https://linkerd.io). It shows that adoption of service meshes is increasing and many teams have great success in using them either for increased observability or to fulfill the security requirement of mutual TLS authentication between services.

One new solution showed at Kubecon was of particular interest. Most of the current Service Meshes use a sidecar proxy which routes all traffic from the actual application container to any other pod in the cluster. Only a application with sidecar can be part of the mesh and the sidecar proxy configures any special routing like A/B testing, tracks traffic metrics and facilitates mutual TLS. This proxy adds overhead to the network and potentially complicates the network debugging when unexplained errors in the application suddenly happen.

What if we could have a sidecar-less solution. This could be done using a eBPF-based Service Mesh. [eBPF](https://ebpf.io/) in it self is not new, [Cilium](https://cilium.io/) is using it from the beginning for networking. The advantage of eBPF is executing code in the Kernel instead of user-space without needing additional Kernel modules or modifying the Kernel source code. Adding service mesh features to it is the novelty of one of the newer versions to be released of Cilium. All the Layer 3-4 traffic routing can be done on eBPF level, for incoming traffic a envoy proxy is still needed on Layer 7 but only one proxy per node. The advantage is a less complex networking flow as the sidecar proxy is gone and also less latency.
It remains to be seen whether a one proxy per-node solution is more performant and resilient than a per-host proxy solution. But it is still great to see an effort to simplify service meshes.

The Service Mesh feature is currently in Beta since version 1.11. Combined with the observability UI Hubble it can be already used to increase the network observability inside your cluster. For traffic routing features, one needs to wait a bit longer since most of these features are not yet integrated but will come with version 1.12. What's great is that Cilium will be compatible with nearly all Service Mesh control planes to manage the service mesh configuration or traffic routing resources. Cilium has also been a CNCF incubating project since October 2021, so while it will still take some time to be fully used in all production environments, it is very promising as a package for all networking, observability and security needs.

### wasmCloud

There is a famous tweet from Solomon Hykes, the creator of Docker:

"If WASM+WASI existed in 2008, we wouldn't have needed to created Docker. That's how important it is. Webassembly on the server is the future of computing."

While the comparison might be exaggerated, it gives a hint of the innovation power of WebAssembly. 
One of the main benefits is higher security. While the Linux User Space API contains over 300 functions, the WebAssembly interface is limited to the few functions specific for your workload. Also WebAssembly is memory safe by design.

How a WebAssembly powered cloud might look like can now be experienced on wasmcloud.dev.

With wasmCloud you get a modular platform. With WebAssembly, you just write actors, which just contains the business logic. As such it does not contain technical code. This is added by capability providers such as HTTP-Servers, Postgres, AWS S3 or Logging. The modular system runs also locally and you benefit by an increased producity and portability.