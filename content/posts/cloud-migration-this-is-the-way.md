---
title: "Cloud Migration: This is the Way"
date: 2021-07-28T10:54:33+02:00
draft: true
author: "[Andreas Zitzelsberger](https://github.com/az82/)"
tags: ["Cloud", "Migration", "Architecture", "Business and IT"]
image: "cloud-migration/road-to-cloud.jpg"
summary: "There is only one way to to do cloud migration properly: Linking business and technology."
---

There is only one way to to do cloud migration properly: Linking business and technology.
Top down, the business goals and constraints of the migration must be clearly defined.
Typical goals are:

* Cost savings
* Migrating within a budget
* Improving the user experience by improving performance
* Improving developer and operations experience
* Decommissioning data centers

Bottom up, great transparency with technical depth is necessary. on the current state of the application landscape.
We need reliable, detailled information about the current state of our application landscape consolidated in a single source of truth.
![A graph DB as single source of truth](/images/cloud-migration/migration-db.jpg)

Linking the top down goals and constraints with the bottom-up foundation creates the evaluation framework for choosing the best migration strategy for each application.
This overall strategy allows to migrate with confidence, in time and budget.

## Application Migration Strategies

**Lift and shift**: The software will be transferred to the cloud unchanged, except for configuration.
*Lift and shift* should only be the first choice for cloud-ready applications, i.e. applications that can be operated without restrictions in a cloud environment.

**Lift and extend**: The software is adapted to run on a cloud platform.
The strategy of choice for software that can be economically adapted.
We've had great success with a *cloud-friendly* strategy - defining a mandatory baseline of cloud friendliness for application migrations:

* Security
* Elimination of toxic dependencies
* Implementing [12 factor](https://12factor.net/) principles
* Proper isolation of state
* Observability and diagnosability
* Resilience

Migration teams are encouraged to exceed the baseline if possible within the frame of the migration. New applications are build cloud-natively.
With *cloud-friendly*, the focus is on the outcome: Secure applications that can be maintained and operated easily.

![Cloud Nativity Levels](/images/cloud-migration/cloud-levels.jpg)

**Hybrid extension**: The software remains on premise. New functions are built in the cloud, leveraging the strangler pattern until the old application core is no longer used and can be decommissioned.
This strategy has inherent complexity and serious drawbacks such as increased latency.
Nevertheless, this can be a good strategy to get going. At first, critical core systems are left on-premise while know how and trust with the cloud is built up.

**Full rebuild**: Applications are rebuilt cloud-natively from scratch.
In most cases, it will be to expensive and time-consuming to rebuild entire application landscapes.
Therefore, this method should ony be used if an application cannot be brought up to a *cloud-friendly* level in a meaningful, economic way.

**Replacement**: Applications are replaced by a Software-as-a-Service (SaaS) or a cloud-native self-hosted product. \
Feasible, if an application implements a functionality already covered by products.

## Application Types

**Custom applications** that can be changed at will. The migration strategy depends on the overall state of the application and the migration goals. In most cases, a lift and extend strategy with the goal of making the application *cloud-friendly* works well.

**Self-operated purchased products**. Only configuration changes are possible. The product can only be operated in the cloud as offered by the provider. In the worst case, it has to be replaced by an alternate, *cloud-friendly* product.

**Infrastructure** such as databases. In most cases, you want to replace those with platform services or SaaS solutions instead of migrating them. Heavy weight proprietary infrastructure components should be replaced. In special cases, there may be a justification to keep exotic components.

**Mainframe applications**. Mainframes are special.
Off the record, hand on heart: If the software had been adequately maintained, the mainframe would've been gone a long time ago.
Mainframe software usually is a degenerated monolith. Data and business logic are not separated.
The code is littered with assumptions about the runtime environment.
There is only little in-depth technical knowledge available any more, if at all. Mainframes are a tremendous maintenance debt and that also shows during a cloud migration.
Either you bite the bullet and rebuild, or go for a sarcophagus and put the applications in a
compatible cloud-enabled runtime environment, buying time for a more sustainable long-term solution.
If you don't rebuild, the mainframe remains a massive liability.

## Our Approach

![How a migration program is set up](/images/cloud-migration/migration-program-setup.jpg)

1. **We take care to help shape, understand and communicate the goals and constraints of the migration and align the organization**.
    The journey will only be successful if the destination is clear.
2. **We create a single source of truth that reliably provides in-depth transparency about the state of the application landscape to migrate.**
    We tap into existing sources of information and use a tool-based approach to analyze and classify applications.
    Born from experience, we act with a healthy distrust of pre-existing documentation and high-level declarations. The truth is in the code.
3. **We link the business view and the technical foundations.** Results:
    * Reliable bottom-up assessment and planning of the migrations
    * Detecting and resolving problems before they hurt
    * Ensuring compliance and security
    * Confidence that the goals can be achieved
4. **We ensure and efficient and effective migration by:**
    * Helping you design and set up the migration program right from the start
    * Industrializing architecture, common parts and work:
        We solve challenges once, automated as far as possible and in high quality.
    * Establishing an *inner source* approach, facilitating communication and providing transparency across teams.
    * Including enabling from the beginning. The existing teams know their applications best. We ensure that they will be
        able to maintain their newly cloudified applications easily. Many teams will be able to carry out the migrations themselves.
    * Taking responsibility for the outcome and working closely with you and your partners.
5. **We support the after-migration period, ensuring that cost, stability and performance goals are met.**

## See also

* [The good, the bad & the ugly of migrating hundreds of legacy applications to a cloud native platform](https://www.slideshare.net/QAware/the-good-the-bad-the-ugly-of-migrating-hundreds-of-legacy-applications-to-a-cloud-native-platform), Robert Bichler, Josef Adersberger, Handelsblatt annual conference on strategic IT management, 2019
* [IDG Cloud Migration Studie 2021](https://info.qaware.de/de-de/cloud-migration-studie-2021) (German)
