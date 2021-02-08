---
title: "Introducing Minikube Support Tools"
date: 2021-02-08
author: "[Christian Fritz](https://github.com/chr-fritz)"
type: "post"
image: "minikube-support-run.png"
tags: ["Kubernetes", "Minikube", "Cert-Manager", "Nginx-Ingress", "OSS", "Open Source"]
draft: false
---

In this blog post, we want to introduce the
[minikube-support](https://github.com/qaware/minikube-support) tools, which we recently released in
the first version. The
[minikube-support](https://github.com/qaware/minikube-support) tools are intended to automate and
simplify common tasks which you need to do every time you set up a new minikube cluster. For this,
they combine some cluster internal and external tools to provide a better interaction between
minikube and the developers local os. Basically the minikube-support tools are a collection of
tools and their configuration which are usually required to work or develop with a minikube cluster
but are not pre-installed or properly configured.

## Idea

The idea for the
[minikube-support](https://github.com/qaware/minikube-support) tools was born in 2019 when we
discovered that nearly every time we wanted to use minikube, we needed to do the same steps after
creating a new minikube cluster. The first idea was to use a bunch of shell scripts which install
the tools and try to configure them properly. Even with those scripts there were some steps which
were not automated. One point was to write the hostnames, and the correct minikube ip into the
`/etc/hosts` file. Of course this also was a repeating step for every new hostname which we want to
publish using an ingress.

That was the point where the idea came up to combine all into a single command line tool.
Basically it should meet the following two requirements:

1. Install and configure all the components which were usually required and
2. Simplify the access to services and ingresses within the cluster.

## Features

The main entry point to run everything on the current minikube instance, is the `minikube-support`
command. For this it installs, configures and provides the following tools and features:

- A local
  [CoreDNS](https://coredns.io/) instance to access the services and ingresses using a domain name
  `*.minikube`.
- [mkcert](https://github.com/FiloSottile/mkcert) to set up a locally-trusted CA for generating
  certificates for the domain names served by CoreDNS.
- The
  [Cert-Manager](https://github.com/jetstack/cert-manager) to manage that certificate generation
  within the cluster using the locally-trusted CA created by mkcert.
- A
  [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/) to provide access to the
  ingresses deployed in minikube.
- A dashboard that shows the status of ingresses, `LoadBalancer`-Services, served DNS entries and
  the `minikube tunnel` status.

## Quickstart

1. Install `minikube`:
   - Download the
     [latest release](https://github.com/qaware/minikube-support/releases/latest) and place it
     somewhere into your `$PATH` or use our brew tap:

     ```shell script
     brew install qaware/minikube-support/minikube-support  
     ```
2. Start your cluster `minikube start`
3. Install internal and external components with `minikube-support install -l`
   - If you don't want to install the external components (mkcert, CoreDNS), because you already
     installed it, just run `minikube-support install`.
4. Run the dashboard: `minikube-support run`

{{< figure figcaption="The minikube-support run dashboard" >}}  
{{< img src="/images/minikube-support-run.png" alt="minikube-support run dashboard" >}}  
{{< /figure >}}

5. Deploy our application or use our test deployment:

   ```shell script
   kubectl apply -f https://raw.githubusercontent.com/qaware/minikube-support/master/docs/demo-deployment.yaml
   ```
6. Open your application in your browser when it is visible in the "Status of Coredns-Grpc" box.

## Configuration

The minikube-support tools do not have their own configuration properties, but require to configure the
dns resolver of the local os. For macOS the minikube-support tools will do this automatically. Just
ensure that all your ingresses uses the top level domain `.minikube`.

For Windows and Linux systems there are no known interfaces or configuration properties to configure
conditional forwarding for DNS requests to `.minikube` programmatically. In this case you have to
configure your DNS resolving by your own.

## Acknowledgements

This cli tool was developed by
[Christian Fritz](https://github.com/chr-fritz) and was gratefully supported by
[QAware](https://www.qaware.de/) by allowing me to do that during paid working hours.

## Links

- [minikube-support on GitHub](https://github.com/qaware/minikube-support)
- [nginx-ingress-controller](https://github.com/kubernetes/ingress-nginx)
- [cert-manager](https://github.com/jetstack/cert-manager)
- [mkcert](https://github.com/FiloSottile/mkcert)
- [minikube tunnel](https://minikube.sigs.k8s.io/docs/commands/tunnel/)

----

## Related posts

* [Virtual Kubelet - Run Pods Without Nodes]({{< relref "/posts/virtual-kubelet.md" >}})
* [Generating OpenApi Specification From Spring Boot]({{< relref "/posts/openapi-for-spring-generator.md" >}})
