---
title: "The highlights of KubeCon + CloudNativeCon EU 2022" # todo
date: 2022-06-22T16:57:04+02:00 # todo
draft: true
author: "[Alex Krause](https://github.com/alex0ptr), [Felix Kampfer](https://github.com/FelixKampfer), [Sebastian Macke](https://github.com/s-macke), [Markus Zimmermann](https://github.com/markuszm), [Dirk Kröhan](https://github.com/dkroehan)" # add yourself
image: "KubeConEU2022_GroupPhoto.jpg"
tags: ["Cloud", "Cloud Native", "Kubernetes"]
summary: "Our highlights of the KubeCon + CloudNativeCon EU 2022."
---

The KubeCon + CloudNativeCon Europe is the most important conference for Cloud Native hosted by the Cloud Native Computing Foundation. After 2 years of remote conferences, we felt it was the right time for us to pack our bags and be there on site in Valencia. It was a great opportunity to learn everything new about Cloud Native and have interesting conversations with the leaders in the Cloud Native space.

The conference was taking place in Fira València, a fairground in the northwest of Valencia that was easily reachable by public transportation from the city center. Registration and badge pick up went really smooth as we managed to be there on the day before the big opening to attend some inspiring lightning talk. The first exciting moment was when we entered the keynote area, and we knew, this is going to be a big event!

During the next three days there was a lot to do: around 8 tracks of talks at the same time, many hands-on workshops and two big halls of company and project booths to visit. One could feel the enthusiasm around Open Source and the whole community working together to improve the Cloud Native Landscape.  We had the experience that talking directly to the maintainers at the booth of a project was very helpful to understand the key features of a new project and directly ask some deeper technical questions. Additionally, some talks inspired us to immediately evaluate new Cloud Native projects.

While we could write a blog post for each new interesting topic we saw, you most likely don't have the time to read all of them. Instead, we want to keep it short and worthwhile for you with only the most interesting and impactful topics we saw and a short description why they were so interesting for us.

### Crossplane: Compliant Self Service Infrastructure

{{< img src="/images/kubecon-eu-2022/crossplane-horizontal-color.svg" alt="Crossplane" >}}

Crossplane is a framework that allows you to build your own custom control plane to manage any API. It calls itself "The cloud native control plane framework".

Its primary use-case is to provision and manage cloud infrastructure.
It does so by allowing you to build compositions tailored to your needs and make them usable for the users of your Kubernetes cluster as a CRD.
This is similar to how a Postgres Terraform module is an abstraction for creating an RDS instance in AWS with a matching secret in your Kubernetes cluster containing the service password.
However, from a developer perspective Crossplane enables the definition of the application configuration from pure Kubernetes manifests - finally including the required infrastructure in the same GitOps repository.
Without crossplane developers have to manage additional Terraform/Pulumi/CloudFormation code, usually in another GitOps repository, and make sure it stays in sync with application promotions.
Additionally, Crossplane allows more fine-grained control for platform engineers on which infrastructure or compositions can be used by the developers.
This is achieved by the native Kubernetes RBAC integration and defining Kubernetes Admission controller policies using [Gatekeeper](https://github.com/open-policy-agent/gatekeeper) or [Kyverno](https://github.com/kyverno/kyverno).

Crossplane has been a CNCF incubating project for almost a year.
During this year's KubeCon EU there were eight sessions around Crossplane.
The high attendee count at the [Crossplane maintainer session](https://www.youtube.com/watch?v=xECc7XlD5kY) forced the organizers to limit physical participation for security reasons, which foreshadows the high impact Crossplane will likely have.

### New Kubernetes Gateway API 

{{< img src="/images/kubecon-eu-2022/kubernetes-horizontal-color.svg" alt="Kubernetes" >}}

Another novelty in the realm of standardization will be the new Kubernetes-native Gateway API. It supports more use cases than the limited Ingress API and overloaded Service API. These use cases entail load-balancing and routing, with many options for advanced configuration such as header-based matching and traffic weighing. It’s meant to be a standard interface for heterogeneous gateway providers, such as Traefik, Kong, Kuma, Consul, or GKE.

To allow for portability, implementations of the API can choose to fulfill one of several levels of conformity. Major features include the binding of routes to gateways, Kubernetes-native typization of routes, the ability to attach RetryPolicies and HealthCheckPolicies to services and gateways, and cross-namespace sharing of resources.

### wasmCloud

{{< img src="/images/kubecon-eu-2022/wasmcloud-horizontal-color.png" alt="wasmcloud" >}}

There is a famous tweet from Solomon Hykes, the creator of Docker:

> "If WASM+WASI existed in 2008, we wouldn't have needed to created Docker. That's how important it is. Webassembly on the server is the future of computing."

While the comparison might be exaggerated, it gives a hint of the innovation power of WebAssembly.
One of the main benefits is higher security. While the Linux User Space API contains over 300 functions, the WebAssembly interface is limited to the few functions specific for your workload. Furthermore, WebAssembly is memory safe by design.

On wasmcloud.dev you can experience how a WebAssembly powered cloud might look like.

With wasmCloud you get a modular platform. With WebAssembly, you write actors, which just contains the business logic. As such it does not contain technical code. This is added by capability providers such as HTTP-Servers, Postgres, AWS S3 or Logging. The modular system runs also locally, and you benefit by an increased productivity and portability.

### eBPF - the base for the cool stuff


{{< img src="/images/kubecon-eu-2022/ebpf-horizontal-color.png" alt="eBPF" >}}

While [eBPF](https://ebpf.io/) itself is not brand new, most of us didn't hear about it before KubeCon. If you wonder, like us, what the name eBPF might stand for, the answer is: it is no longer an acronym for anything. 

The project website states that it is a revolutionary technology with origins in the Linux kernel that can run sandboxed programs in a privileged context such as the operating system kernel. It is used to safely and efficiently extend the capabilities of the kernel without requiring to change kernel source code or load kernel modules.

From our point of view it seems to be a perfect fit for topics like observability, security and network functionality. So it's no big surprise that two topics that are powered by eBPF made it onto our list for the most interesting and impactful topics from this year's KubeCon: Cilium and Pixie.

### Cilium: The Future Of Service Meshes?

{{< img src="/images/kubecon-eu-2022/cilium-horizontal-color.svg" alt="Cilium" >}}

Service Meshes were a prominent topic at this KubeCon. There were lots of experience reports on [Linkerd](https://linkerd.io). It shows that adoption of service meshes is increasing and many teams have great success in using them either for increased observability or to fulfill the security requirement of mutual TLS authentication between services.

Most of the current Service Meshes use a sidecar proxy which routes all traffic from the actual application container to any other pod in the cluster. Only an application with sidecar can be part of the mesh and the sidecar proxy configures any special routing like A/B testing, tracks traffic metrics and facilitates mutual TLS. This proxy adds overhead to the network and potentially complicates the network debugging when unexplained errors in the application suddenly happen.

What if we could have a sidecar-less solution? The project [Cilium](https://cilium.io/) achieves this using an eBPF-based Service Mesh. Cilium was using it from the beginning for networking and network policies. Adding service mesh features to it is the novelty of one of the newer versions of Cilium. All the Layer 3-4 traffic routing can be done on eBPF level. For incoming traffic an envoy proxy is still needed on Layer 7 but only one proxy per node. By removing the sidecar proxy latencies are reduced and the networking flow becomes less complex.
It remains to be seen whether a one proxy per-node solution is more performant and resilient than a per-host proxy solution. But it is still great to see an effort to simplify service meshes.

The Service Mesh feature is currently in Beta since version 1.11. Combined with the Hubble UI it can be already used to increase the network observability inside your cluster. For traffic routing features, one needs to wait a bit longer since most of these features are not yet integrated but will come with version 1.12. What's great is that Cilium will be compatible with nearly all Service Mesh control planes to manage the service mesh configuration or traffic routing resources. Cilium has also been a CNCF incubating project since October 2021, so while it will still take some time to be fully usable in all production environments, it is very promising as a package for all networking, observability and security needs.

### Pixie: All-in-one observability for developers

{{< img src="/images/kubecon-eu-2022/pixie-horizontal-color.svg" alt="Pixie" >}}

One of the most spectacular demos we saw at KubeCon was Pixie. An eBPF-based observability tool which collects metrics, events, traces and logs without needing to instrument any code. The automatically generated service map shows which services talk to each other. Traffic is captured using a deployed module on each node and can be queried using a Web UI. The Web UI, which is the control plane of Pixie, is available as managed Cloud offering by Pixie or can be self-hosted. Pixie promises that no customer data is shared into the Cloud offering. This is facilitated by services which are deployed into the customer cluster and the Web UI querying these services for all data. The impressive new thing here is that developers can debug issues much easier and through the traffic capturing, production issues could be replicated to find out the root cause.   
The talk [Reproducing Production Issues in your CI Pipeline Using eBPF - Matthew LeRay & Omid Azizi
](https://www.youtube.com/watch?v=_RQLY4KXXG8) showed this live in action, so check it out! 

### Conclusion

So let's put up the most important question for the end: "Would you recommend this event to your friends and colleagues?" And our answer is: Definitely, YES! The density of Cloud Native topics is unique. There is so much going on in the Cloud Native ecosystem and KubeCon is a great opportunity to suck up all the knowledge and brand-new topics from the Cloud Native space. 

See you at the next KubeCon + CloudNativeCon Europe 2023 in Amsterdam!
