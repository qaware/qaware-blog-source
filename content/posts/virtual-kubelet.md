---
title: "Virtual Kubelet - Run pods without nodes"
date: 2018-07-12T15:06:32+02:00
draft: false
tags: [Containers, Conference, Kubernetes, Kubelet]
aliases:
    - /posts/2018-07-12-virtual-kubelet/
summary: An introduction to Virtual Kubelet - run pods without nodes
---
During my recent visit of the ContainerDays 2018 in Hamburg (19.-20.06.2018) I attended an interesting talk held by Ria Bhatia from Microsoft about Virtual Kubelet.

Virtual Kubelet is an open source Kubernetes Kubelet implementation that allows you to run Kubernetes pods without having to manage nodes with enough capacity to run the pods.

In classical Kubernetes setups, the Kubelet is an agent running on each node of the Kubernetes cluster. The Kubelet provides an API that allows to manage the pod lifecycle. After a kubelet has launched, it registers itself as a node at the Kubernetes API Server. The node is then known within the cluster and the Kubernetes scheduler can assign pods to the new node, accordingly.

Especially in environments with volatile workloads, managing a Kubernetes cluster means providing the right number of nodes over time. Adding nodes just in time is often not an option, since spinning up a new node just takes too much time. Thus, operators are forced into running and paying for additional nodes to support payload spikes.

The Virtual Kubelet project addresses such operational hardships by introducing an application that masquerades as a kubelet. Just like a normal kubelet, the Virtual Kubelet registers at the Kubernetes API Server as node and provides the Kubelet API to manage pod lifecycles. Instead of interacting with the container runtime on a host, the Virtual Kubelet utilizes serverless container platforms like Azure Container Instances, Fargate or Hyper.sh to run the pods.

![Image Source: https://github.com/virtual-kubelet/virtual-kubelet](/images/Kubelet.png)

Using these services via the Virtual Kubelet allows you to run containers within seconds and paying for them per seconds of use, while still having the Kubernetes capabilities for orchestrating them.

The interaction with external services out of the Virtual Kubelet is abstracted by a provider interface. Implementing it allows to bind other external services for running pods.

The project is still in an early state and currently not ready for use in production. However, it’s a very interesting link between container orchestration platforms and serverless platforms and has numerous use cases.

Further information: [https://github.com/virtual-kubelet/virtual-kubelet#virtual-kubelet](https://github.com/virtual-kubelet/virtual-kubelet#virtual-kubelet)

----

## Related posts

* [Introducing Minikube Support Tools]({{< relref "/posts/introducing-minikube-support-tools.md" >}})
* [Generating OpenApi Specification From Spring Boot]({{< relref "/posts/openapi-for-spring-generator.md" >}})