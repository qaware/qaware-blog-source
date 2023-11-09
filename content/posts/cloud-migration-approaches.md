--
title: "Cloud Migration Approaches"
date: 2023-05-02T16:17:55+02:00
draft: true
author: "[Michael Frank]https://github.com/Michael-Frank/)"
tags: ["Cloud", "Migration", "Architecture", "Business and IT"]
image: "cloud-migration/road-to-cloud.jpg"
summary: "There is only one way to to do cloud migration properly: Linking business and technology. But there are Bottom.up and Top-Down cases as well."
---

As we have stated before, there is only one way to do cloud migration properly: [Linking business and technology](https://blog.qaware.de/posts/cloud-migration-this-is-the-way/)

But how do we get there: What if business and technology is currently in linking phase? What are proven strategies and tips on the way?

Ideally, business has a good cloud strategy and strong commitment pushing the cloud move "top down", and at the same time all technical teams have an equally strong desire to leverage the offered technical and organization benefits of cloud technologies from the "bottom up".

However, there are also many "bottom up" cases, where teams are pushing to the cloud before strong business commitment is there.
And there are cases where companies have a clear "top down" cloud commitment, but lack adoption of their cloud platform and struggle to find a good strategy to move over their legacy landscape.

We will look at both cases and show what has worked for us and our customers.


## Team driven "bottom up" migration
Doing "bottom up" migrations, the teams usually have a lot of questions and "What-Ifs" in their mind. Let me try to tackle some of them.

Imagine your company announced "Hey, we will (probably) moving to the cloud (soon / once its ready)" and your team is sitting on some not-so-cloud-friendly applications that need some love and polishing to keep them maintainable anyway. So now you need to decide what to do.
Sounds familiar? Good, then this section might be for you.

So why not take the chance to refactor the applications now, and on the way also make them cloud friendly?

**Safe harbor statement:**
We are strong believers in the **cloud-friendly** (or **Lift and extend**) cloud migration strategy, where existing  applications can be economically adapted to run on a cloud platform and the focus is on the outcome: Secure applications that can be maintained and operated easily. 

However, cloud-friendly is not a one-size-fits-all solution, and there are [other migration strategies](https://blog.qaware.de/posts/cloud-migration-this-is-the-way/) that may be better suited for your specific application.

You may ask: _But my companies cloud platform is not available yet or still in flux. Cant I just wait?_

You could, but you probably already know your companies cloud platform is very likely to be at least some kind of "container runtime" or better "some sort of kubernetes" being it on-prem, public cloud, or managed or in-house.

**Targeting Kubernetes is a sane choice!**  
And leveraging cloud design principles are beneficial for any runtime! So it makes sense to implement them as early as possible and is usually faster than expected.


The cloud design (and migration) principles are:
* Implementing the infamous  [12 factor](https://12factor.net/) principles
* Elimination of toxic dependencies
* Proper isolation of state
* Observability and diagnosability
* Resilience
* Shifting Security to the platform where possible

* Teams migrating their applications, are encouraged to exceed this baseline if possible.

By implementing the cloud design principles early, you can avoid doing work twice or worse, doing it wrong when migrating to the cloud! 

But that's not all:
- containerizing your application is beneficial on its own, as it allows for easier deployment, portability, and scalability even on legacy systems.
- having a gentle start into the cloud world, instead of being forced into it by management, makes it more joyful 
- by being familiar with cloud technology early on, you can ask "the right questions" and maybe you can influence and participate in shaping your future cloud platform.
  (This one is pretty huge!)
- as early adopters you are the cloud experts in your company, which is good for you and your teams standing
- and of course production stability and maintainability of your application will rise, as cloud design principles and operation patterns have proven them self over and over to increase these.


New applications should be build cloud-natively, fully leveraging the Cloud-Platform features.

Sounds nice but...
- _"where do i host my containers if the company platform is not ready?"_ 
   
   Maybe you can use a managed kubernetes from a public cloud provider. And dont be afraid to host your own kubernetes. There are awesome distributions for each usecase. e.g. coming from a single host world, or maybe some small shop floor on-prem system? Why not microk8s? Unfortunately listing them all and their use cases would go far beyond the scope of this article.

- _"i don't need Kubernetes"_. 
   Containerizing is almost a must, as it allows a better
   Plain Docker is dying, swarm is dead. At some point, we had to go against the flow and its painful, as you are forced to solve many issues where K8s and its ecosystem already have ready to use solutions. Kubernetes is todos standard for running containerized applications.



## Management driven "Top-Down" migration
Top down, the business goals and constraints of the migration must be clearly defined.
Typical goals are:

* Cost savings
* Migrating within a budget
* Better user experience by improving performance
* Improving developer and operations experience
* Decommissioning data centers

![How a migration program is set up](/images/cloud-migration/migration-program-setup.jpg)

Our approach: Transparency, Good Planing, Stakeholder management and Migration Industrialization as a Service:

1. **We take care to help shape, understand and communicate the goals and constraints of the migration and align the organization**.
   The journey will only be successful if the destination is clear.
2. **We create a single source of truth that reliably provides in-depth transparency about the state of the application landscape to migrate.**
   We tap into existing sources of information and use a tool-based approach to analyze and classify applications.
   Born from experience, we act with a healthy distrust of pre-existing documentation and high-level declarations. The truth is in the code.
    - In the past we did this with our own custom tooling!
    - Today there is CNCF's [Konveyor, most notably "Konveyor Tackle"](https://www.konveyor.io/) to help you!
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


Ever wondered why kubernetes called k8s? Developers found "Kubernetes" to long and shortened it to "K8s" by replacing the middle 8 letters with a number.


## See also
* [Cloud friendly migration through refactoring is often the best solution](https://medium.com/@sbillet/cloud-friendly-migration-through-refactoring-is-often-the-best-solution-afb67f27661c)
* [Cloud Migration: This is the Way](https://blog.qaware.de/posts/cloud-migration-this-is-the-way/)
* [IDG Cloud Migration Studie 2021](https://info.qaware.de/de-de/cloud-migration-studie-2021) (German)
* [The good, the bad & the ugly of migrating hundreds of legacy applications to a cloud native platform](https://www.slideshare.net/QAware/the-good-the-bad-the-ugly-of-migrating-hundreds-of-legacy-applications-to-a-cloud-native-platform), (Robert Bichler, Josef Adersberger, Handelsblatt annual conference on strategic IT management, 2019)
