---
title: "Cloud Native Dev Tooling With Go"
date: 2021-08-16T16:57:04+02:00
draft: true
author: "[Markus Zimmermann](https://github.com/markuszm/)"
image: "cloud-native-dev-tools-with-go/tools-hero-image.jpg"
tags: ["Cloud", "Cloud Native", "Containers", "DevOps", "Kubernetes", "Tools"]
summary: "Faster DevOps flow and higher productivity with Cloud Native Dev Tools using Go"
---

In the new Cloud Native world, operation tooling must enable DevOps teams for high productivity and fast flow to production. Architectures often contain dozens of microservices which need to be quickly deployed and operated in the cloud. This is a lot of extra management effort for developers and separate operations team do not scale to support all services of a project. Without good tooling that automates most of the day-to-day operation work away from developers, no large platform can be maintained for long. Automation is key!

# What are Cloud Native Dev Tools? 

The Cloud Native Computing Foundation (CNCF) officially defines Cloud native as:

```Cloud native technologies empower organizations to build and run scalable applications in modern, dynamic environments such as public, private, and hybrid clouds. Containers, service meshes, microservices, immutable infrastructure, and declarative APIs exemplify this approach.``` [(Source)](https://github.com/cncf/toc/blob/main/DEFINITION.md). 

Cloud native technologies require Cloud Native Dev Tools to provide solutions for enabling Cloud Native applications to run on container platforms and make operations as automated as possible. Tools are needed for the full development flow of a Cloud native application from development of containers to deployment of the container to the observability and security of the application itself.

{{< figure figcaption="DevOps Development Flow" >}}
  {{< img src="/images/cloud-native-dev-tools-with-go/development-flow.png" alt="DevOps Development Flow" >}}
{{< /figure >}}

Let's look at some examples in how tools can support the different steps in the development flow:

**Build**: 
* [Docker](https://www.docker.com/why-docker) is the best example here, which helps developers build containers of their application locally, test the containers and then push them to any container registry in the cloud
* Vulnerability scanning tools like [Trivy](https://github.com/aquasecurity/trivy) scan containers or application artifacts for vulnerabilities to prevent security incidents before the application is deployed in production

**Deploy**: 
* Kubernetes deployments are difficult with all resources needed so blueprint templates for microservices are important and tools such as [Helm](https://helm.sh/) help generalize Kubernetes deployments  
* GitOps tooling such as [ArgoCD](https://argoproj.github.io/argo-cd/), help developers deploy faster to Kubernetes without needing to write deployment scripts or integrating authentication to the cluster inside application deployment pipelines

**Operate**: 
* The CLI every DevOps engineers needs in their toolkit is *kubectl*. It manages everything with your Kubernetes cluster. Its extendable through plugins which lets us integrate any customization into kubectl.
* Kubernetes operators help with all regular operations tasks around a Kubernetes deployment. They enable auto-updating, self-monitoring and self-healing infrastructure. There are operators for databases, cloud infrastructure provisioning or security needs. Check the [OperatorHub](https://operatorhub.io/) for a curated list of operators. 


# Why use Go for Cloud Native Dev Tools?

What is the right tool to develop Cloud Native Dev Tools? Over the years, Go managed to position itself as the major language behind the Cloud Native stack. Docker, Kubernetes, Kubectl and many other known tools and infrastructure components are all implemented in Go.

{{< figure figcaption="Cloud Native Tool examples written in go" >}}
  {{< img src="/images/cloud-native-dev-tools-with-go/cloud-native-tools-in-go.png" alt="Cloud Native Tools written in go" >}}
{{< /figure >}}

Go is an open source language maintained by Google.
The language has the following key advantages:

* efficient garbage-collected systems programming language
* easy to learn due to fewer language features 
* single, self contained binaries which can be built for nearly any platform and OS
* out-of-the-box development tooling such as testing, code formatting, dependency management etc.

Choosing Go lets us participate in the vivid Cloud native community and use the SDKs that power the Cloud Native stack to write our own Dev Tools. 

# Doing a Workshop for the community

For the *betterCode* in 2021, we ([M.-Leander Reimer](https://github.com/lreimer/) and [Markus Zimmermann](https://github.com/markuszm/)) created a workshop titled ["Go for Operations"](https://www.bettercode.eu/lecture_compact1.php?id=12938&source=0) which introduced fellow software engineers to Cloud Native Dev Tooling in Go. 

The workshop showed that everyone had different DevOps experiences at their jobs, from strong compliance requirements to quick prototyping. The Go knowledge-level was also mixed between beginners and advanced users. Through hands-on exercises, we showcased different operational automation concepts and how to implement them using Go. At the end, everyone took something home which they wanted to apply in their day-to-day operational work. 

The content of the workshop is open-source and the exercise descriptions are written as step-by-step guides, so anyone can try the exercises themselves. Just visit our GitHub to go through [the workshop](https://github.com/qaware/go-for-operations/tree/master/workshop)!

# Automation Concepts and their drivers

Let's quickly go through some of the automation concepts that were part of the workshop to learn what libraries/frameworks are the drivers to built such concepts in Go.

## Building CLI applications with Cobra

Command-line interfaces (CLIs) are the the type of tools every developer is used to work with. They are faster to use than graphical interfaces and can be easily automated by calling them in Continuous Integration pipelines. *kubectl* is one example for a good CLI and used for managing Kubernetes clusters. It is written in Go and its implementation can be used as a blueprint for CLI applications. It uses the popular CLI libraries [Cobra](https://github.com/spf13/cobra) and [Viper](https://github.com/spf13/viper) which are the main drivers of Go CLI applications. With these libraries, one can quickly write a CLI and has features like auto-completion, help generation and config management.

You can do [Challenge 1](https://github.com/qaware/go-for-operations/blob/master/workshop/challenge-1/challenge-1.md) of our workshop to learn how to use Cobra/Viper to write CLIs.

The result in the challenge is a working Kubectl plugin that creates chaos in our cluster to test the resilience of our deployed services. Kubectl plugins are easy to integrate as the installed binary simply needs to have the `kubectl-` prefix. The only limitation is that plugins cannot overwrite an already existing kubectl command, for example, you cannot create a plugin with the name kubectl-create as it collides with the kubectl command create.

## Building a Sidecar container

Sidecars are a easy way to extend a deployed service in Kubernetes. It is a container that runs along-side your application inside the same pod. The sidecar shares storage volumes, networking and other things with the application container, thus it can be used for intercepting traffic, sharing files with the application or adding monitoring.

Such an sidecar container can be implemented easily with plain Go and due to a self-contained binary the container will be rather small.

{{< figure figcaption="Log shipping sidecar example" >}}
  {{< img src="/images/cloud-native-dev-tools-with-go/log-shipping-sidecar.png" alt="Log shipping sidecar example" >}}
{{< /figure >}}

Check out [Challenge 2](https://github.com/qaware/go-for-operations/blob/master/workshop/challenge-2/challenge-2.md) of the workshop where we build a log shipping container which extends any application that only writes logs to disk to ship logs to any logging provider via standard Kubernetes log handling.

## Building a Kubernetes Operator in Go

As mentioned earlier, Kubernetes operators help us with maintenance tasks that need to be automated in running Kubernetes deployments. Operators can define Custom Resources and manage their state with them. This is facilitated using the [Custom Resource Definition extension of Kubernetes](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/). One advantage of using Kubernetes custom resources is that they can be managed in the same way as your other Kubernetes resources.
Operators have a working loop that watches for changes in their custom resources and act upon changes by doing actions inside Kubernetes or outside. 

One popular framework for writing operators is [Operator SDK](https://sdk.operatorframework.io/). It features scaffolding which generates all needed code for quickly writing your operator and deploying it directly to a cluster.

{{< figure figcaption="Kubernetes operators explained" >}}
  {{< img src="/images/cloud-native-dev-tools-with-go/kubernetes-operator-explained.png" alt="Kubernetes operators explained" >}}
{{< /figure >}}

Take a look at our [Challenge 3](https://github.com/qaware/go-for-operations/blob/master/workshop/challenge-3/challenge-3.md) of the workshop where we built a microservice operator using Operator SDK that abstracts the Kubernetes resources that are needed to deploy a microservice to Kubernetes. With this operator, we only need to define one resource to deploy a microservice instead of defining all needed Kubernetes resources like the Deployment and the Service.  

# Where to go from here?

This post should give you an introduction to Cloud Native Dev Tools and how to implement your own tools in the main language of the Cloud native stack, Go. 
With the workshop exercises, you can get hands-on experience and implement Dev tools yourself. Maybe, they can help you at your work to automate some tedious job you need to do everyday and gives you room for more important tasks. We will try to continue doing such a workshop at other conferences, to give more engineers experience in Go to write such tools and have an exchange on our experiences with the Cloud Native stack.
