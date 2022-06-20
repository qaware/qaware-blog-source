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
