---
title: "The status quo of Chaos Engineering"
date: 2021-03-03T18:00:00+02:00
draft: false
author: "[Josef Fuchshuber](https://www.linkedin.com/in/fuchshuber)"
type: "post"
image: chaos-engineering/81773288.jpg
tags: ["Diagnosibility", "DevOps", "Observability", "Chaos Engineering", "Testing", "Quality"]
summary: This article shows you the current status of Chaos Engineering rituals, procedures and tooling in the Cloud Native ecosystem.
---

This article shows you the current status of Chaos Engineering rituals, procedures and tooling for the Cloud Native ecosystem. The most important thing up front. Chaos Engineering does not mean creating chaos, it means preventing chaos in IT operations.

> Chaos Engineering is the discipline of experimenting on a system in order to build confidence in the system’s capability to withstand turbulent conditions in production. [^1]

## Where can Chaos Engineering help us?

Cloud native software solutions have many advantages. However, there is always one negative point: the execution complexity of the platforms and our micro service components increases. Our architectures are made up of many building blocks in the runtime view. With Chaos Engineering (mindset & process) and Chaos Testing (tooling) we can get a grip on this challenge and build more resilient applications and achieve trust in our complex applications.

The human factor is almost more central in Chaos Engineering than our applications. As described above, it is very important that we know the behavior of our cloud native architectures and thus build trust. The second aspect are our ops processes. Is our monitoring and alerting working? Do all on-call colleagues have the knowledge to analyze and fix problems quickly?

{{< figure figcaption="Chaos Engineering Levels" >}}
  {{< img src="/images/chaos-engineering/chaos-engineering-levels.png" alt="Chaos Engineering Levels" >}}
{{< /figure >}}

The "what will be tested" with Chaos Engineering can be divided into four categories (from bottom to top):

* **Infrastructure:** This is about our virtual infrastructure at our cloud providers. We can test to see if our infrastructure-as-code tooling has created everything correctly and whether, for example, the high-availability VPN connection to our own data center is really highly available and fail-safe.
* **Platform:** In the next level, our platform components are involved - Kubernetes, DevOps Deployment Tooling, Observability Tooling. Examples of questions that test can answer at this level are: Does the self-healing of a node pool work if a node fails? What happens if the central container registry fails and new pods have to be started in the cluster?
* **Application:** At this level, we test the behavior of our applications in the interaction of the microservices with each other and with the platform components: Is the exception handling correct? Are all circuit breakers and connection pools correctly configured with their timeouts and retries? Is a (partial) failure of a service detected correctly and quickly enough by the health checks?
* **People, Practices & Process:** This level is less about tooling and more about the people in the team.In an emergency, are the communication channels correct and are the right people informed at the right time? Do colleagues have all the relevant permissions to perform analyses and troubleshooting? Do they have the know-how not to threaten the MTTR[^2]?

If you summarize the levels and their questions, you can start as a team with Chaos Engineering for these tasks:

* Battle Test for new infrastructure and services.
* Quality Review: Continuously improve the resilience of applications.
* Post Mortem: Reproduction of failures
* On-Call Training

The most lightweight start of Chaos Engineering is Game Days. On Game Day, the complete team (Devs, Ops, QA, Product Owner, ...) runs experiments. Tooling is placed in the background first. The primary goal is for the entire team to internalize the Chaos Engineering mindset and to discover and fix anomalies in the process.

## How to start?

> Chaos Engineering without observability … is just chaos [^3]

{{< figure figcaption="With open eyes into the disaster." >}}
  {{< img src="/images/chaos-engineering/this-is-fine.jpg" alt="With open eyes into the disaster." >}}
{{< /figure >}}

Everyone knows this meme and no one should be as ignorant as our little friend from the comic. You can ignore things deliberately or you can't ignore them in the beginning because you don't see them. This is exactly what happens when we don't have proper monitoring for our application, platform and infrastructure components. For example, from an end-to-end perspective, the RED method [^4] provides a good view of the state of a microservice architecture. So take care of your monitoring first.

The most common question at the beginning is: In which environment do I run my first experiments? In the beginning, you should always work in the environment closest to production (no mocks, preferably identical cloud infrastructure), but not production. But: choas engineering experiments in production are the goal to be, because only there you will find the reality. If you start in a test environment, you must be aware that you have no real customer load during your experiments. You need load generators or acceptance tests to check that the system responds as we assume it will. If these do not yet exist, you will need to build them before your first experiment. Don't worry, sometimes a small shell script is enough or even our Chaos Testing tooling supports validation.

Now that we have an environment and monitoring, we can start with the first experiments. This image will help us to do so:

{{< figure figcaption="The Phases of Chaos Engineering" >}}
  {{< img src="/images/chaos-engineering/chaos-experiment-phases.png" alt="The Phases of Chaos Engineering" >}}
{{< /figure >}}

The phases of chaos engineering can be represented as a cyclic process. A cycle starts and ends in the _steady state_.

* **Steady State:** The most important chaos engineering state. Because this describes the behavior of the system under normal conditions. 
* **Hypothesis:** In this phase we make a hypothesis. We design our experiment by executing an action (e.g. database failure) and describing the expected result (e.g. error page in web UI is shown, with HTTP status 200 and not 500).
* **Run Experiment:** We execute the defined action. In a game day, this can be done manually (e.g. CLI tooling of cloud providers or `kubectl`) or automated via a suitable chaos test tooling.
* **Verify:** In this phase we validate whether the expected result has occurred. This includes the behavior of the application, but also the measured behavior in our monitoring and alerting tools.
* **Analyze and Improve:** If the expected result did not occur, we analyze the cause and fix it.

After a successful test, the system must be back in *steady state*. This is the case either if the executed action does not change the steady state (e.g. the cluster detects an anomaly automatically and can heal itself) or a rollback is performed (e.g. database is started up again).

When designing and running the experiment, one of the most important things is always to keep the potential blast radius, i.e., the impact of the error, as minimal as possible and to continuously monitor it. It is helpful to consider in advance how the experiment can be terminated in an emergency and how the *steady state* can be restored as quickly as possible. Applications that support canary deployment have a clear advantage here. Because here we can control our work load to the experiment or the normal version of the application.

Any Chaos Engineering experiment requires detailed planning and must be documented in in some form. Example:

|                       |                             |
|-----------------------|-----------------------------|
| Target                | Billing Service             |
| Experiment            | Paypal API is not available |
| Hypothesis            | The application automatically detects the outage and no longer offers the payment method to our customers. Customers can still pay by credit card or prepayment. Monitoring detects the failure and automatically creates a Prio-1 Incident. |
| Steady State          | All types of payment are available for customers |
| Blast Radius          | During the experiment, customers will not be able to pay with Paypal. The alternative payment methods are not affected. |
| Technical information | We simulate the outage of the Paypal API by extremely slowing down the outgoing network traffic of the billing service. We can implement this via the service mesh (sidecar proxies). |

Tip for the design of experiments and hypotheses: Don't make a hypothesis that you know in advance will break your application and thus is not sustainable! These problems, if they are important, you can address and fix immediately. Only hypothesize about your applications that you believe in. Because that is the point of an experiment.

## Chaos Engineering Tooling

There is a lot of activity in chaos testing tooling at the moment. New open source and commercial products are constantly being launched. A current overview of the market is provided by the Cloud Native Landscape of the CNCF. There is now a separate Chaos Engineering category [^5].

{{< figure figcaption="Chaos Engineering Tools @ CNCF Landscape" >}}
  {{< img src="/images/chaos-engineering/chaos-engineering-cncf-landscape.png" alt="Chaos Engineering Tools @ CNCF Landscape" >}}
{{< /figure >}}

The features of chaos engineering tools are manifold:

* **API or operator based:** Uses the tool only the public APIs of cloud providers and Kubernetes or installs invasive agents / operators in the cluster (e.g. as sidecars).
* **Support of Chaos Engineering Level:** Not all tools support all levels. AWS and Kubernetes are supported by many tools. Cloud providers or platforms with less market adoption are often second-class citizens.
* **Random or experiment-based:** For randomly acting tools (e.g. terminate any pod of a namespace), the blast radius estimation is much harder and comparative result repetition in CI/CD pipelines is also difficult. On the other hand, these tools may identify unknown sources of errors.

Unfortunately, there is currently no "one-stop-shop" that will make all teams happy. So each team has to think about their own requirements and pick one or more tools.

## Summary

Chaos Engineering is not a job description, but a mindset and approach that involves the entire team.  The most important thing about Chaos Engineering is that you do it:

* Holding periodic game days for the entire team should become a regular ritual.
* Start in a pre-production environment and first check if your monitoring is good enough.

Tools will come and go:

* Chaos engineering tools in the Cloud Native ecosystem are evolving fast.
* The context of your Chaos Engineering experiments will also expand.

To give you a better insight into the Chaos Engineering tools, we introduce some of them. We starts with [Chaos Toolkit]({{< relref "/posts/chaos-engineering-chaostoolkit.md" >}})


## ContainerConf 2021 Presentation

{{< slides key="KZzazUQd1hKSpS" id="der-status-quo-des-chaos-engineerings" title="Der Status Quo des Chaos Engineerings" >}}

## Workshop

If you want to learn more about using Chaos Toolkit and Chaos Mesh, join our remote workshop "Chaos Engineering on Azure AKS" on March 29, 2021. More infos and Infos & registration: [www.containerconf.de](https://www.containerconf.de/lecture_workshop.php?id=12764)

{{< figure figcaption="Workshop: Choas Engineering on Azure AKS" >}}
  {{< img src="/images/chaos-engineering/workshop.png" alt="Workshop: Choas Engineering on Azure AKS" >}}
{{< /figure >}}

## Image sources

* Title image: Blindfolded Businessman At Desk Covered With Papers – [gettyimages.de](http://gettyimages.de)
* This is fine meme: [Gunshow (webcomic), KC Green](https://en.wikipedia.org/wiki/Gunshow_(webcomic))
* CNCF landscape: [CNCF Landscape](Chttps://landscape.cncf.io/)

[^1]: [Principles of Chaos Engineering](https://principlesofchaos.org/)
[^2]: [Mean time to recovery(MTTR)](https://en.wikipedia.org/wiki/Mean_time_to_recovery)
[^3]: [Charity Majors, @mipsytipsy CTO @ Honeycomb](https://de.slideshare.net/CharityMajors/chaos-engineering-without-observability-is-just-chaos)
[^4]: [The RED Method: key metrics for microservices architecture](https://www.weave.works/blog/the-red-method-key-metrics-for-microservices-architecture/)
[^5]: [Choas Engineering Category in CNCF Cloud Native Landscape](https://landscape.cncf.io/card-mode?category=chaos-engineering&grouping=category)

