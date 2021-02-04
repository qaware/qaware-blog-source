---
title: "A Field Report From the O’Reilly Software Architecture in Berlin"
author: "Susanne Apel, Stephan Klapproth, and Andreas Zitzelsberger"
date: 2019-11-15T19:15:32+02:00
draft: false
image: IMG_5684.jpg
tags: [Conference, Software Architecture, CRDT, Microservices, Reactive]
aliases:
    - /posts/2019-11-15-oreilly-field-report/
summary: Last week, we were at the O’Reilly Software Architecture in Berlin. In this article we share our key learnings and takeaways with you.
---

Last week, we were at the O’Reilly Software Architecture in Berlin. Apart from showing off our toys at our booth and chatting with the nice people at the conference, Leander Reimer presented [a hitchhiker's guide to cloud native API gateways](https://www.slideshare.net/QAware/a-hitchhikers-guide-to-cloud-native-api-gateways-192707062) and we visited the conference talks. In this article we share our key learnings and takeaways with you. Slides or videos are provided where available.

---

## Cognitive Biases in the architectures life - Birgitta Böckeler
[by Susanne Apel] [[Video](https://www.oreilly.com/radar/cognitive-biases-in-the-architects-life/)]

I was impressed of how honestly Birgitta spoke about past communications and decisions. She started her presentation by talking openly about how she feels about getting feedback to be ‘even more confident’ and having the immediate impulse to explain herself. This keynote was the profound answer that will hopefully get many minds contemplating about cognitive biases and confidence as a concept.
I was happy to see the topic of cognitive biases in the tech world underlined with good examples. To give one: Featuring the past decisions to use framework X should not be judged while disregarding the outcome bias. You do not know the future of framework X in advance (Reflux in this case). You should be aware of the source of a positive outcome: Was it the decision making or was it luck?
Birgitta is very much aware of the differences and encourages all of us to do the same. This will lead to the point where we will make fewer absolute and more relative statements.

---

## The 3-headed dog: Architecture, Process, Structure - Allen Holub
[by Susanne Apel] [Video](https://www.oreilly.com/radar/the-three-headed-dog-architecture-process-structure/)

In addition to the three heads in the talk’s title, Allen also mentioned culture and physical work environment.
In agile teams, the real goal is to quickly add value to the product - and speed in gaining value can only be achieved by speeding up feedback cycles.
The teams should very much be autonomous and empowered to make decisions.
In my point of view, these are the underlying principles in agile software development, regardless of the particular framework used.
Allen points out the role of teams and offices and the real meaning of a MVP - a small solution that can be enlarged (as opposed to a throw-away product), demonstrated with impressive images of actual houses built this way. He emphasizes that if you want to change one head of the five-headed dog, you also have to change all of the other heads.

---

## A CRDT Primer - John Mumm
[by Susanne Apel]

John explained conflict-free replicated data types (CRDT) with a clear motivation and a nice mathematical introduction providing an intuitive grasp of the topic.

From a computer science point-of-view, the talk seemed very mathematical, from a mathematical point of view it gave plausible explanations while leaving out the more subtle parts of definitions and proofs. The intuition is sufficient, the validity proven elsewhere.

John motivates the issue with a Twitter-like application where the number of likes is to be maintained 'correctly'. This is not a trivial task for a large scale application with many instances.
For the Twitter likes, assume that you cannot unlike a post after you liked it earlier. This gives the following implementation:
Each node maintains a local copy of the local likes of every node in the cluster. When the number of likes is requested, the node sums up the number of likes. If a user likes a tweet, the node 'n' answering the like request increases its own counter of likes. When there 'is time', the node 'n' broadcasts (gossips) the new local copy of its cluster-view. The other nodes will compare and see a higher number of number of ‘n’-likes and will incorporate this number in their own local copy. To be more precise, the node broadcasts its own internal state of all node. This makes the broadcasting more efficient. However, the principle of distribution just explains stays the same. The nice thing is that the broadcasting works very smoothly, and you do not have to think about order of events. It might be that the user sees old data, but there will be eventual consistency. And their own interactions are always reflected immediately.

Mathematics confirm that this works, also with data types other than counters - given that they do fulfill the mathematical relations. Roughly speaking, the relations can be put as following: You need to define lookup, update, merge and compare methods (or variations thereof. The [CRDT Wikipedia page](https://en.wikipedia.org/wiki/Conflict-free_replicated_data_type) provides a good explanation).
If all of these functions together fulfill certain rules, you will get eventual convergence of the lookup value of the data type ([monotonic join semi-lattice](https://en.wikipedia.org/wiki/Semilattice) and the [comparison function](https://en.wikipedia.org/wiki/Comparison_function) should be a [partial order](https://en.wikipedia.org/wiki/Partially_ordered_set#Formal_definition)). Broadcasting is part of the very concept of CRDTs. The CRDTs provide the framework for the actual operations to be executed within the cluster.

---

## The rise and fall of microservices - Mark Richards
[by Stephan Klapproth] [[Presentation](https://cdn.oreillystatic.com/en/assets/1/event/301/The%20rise%20and%20fall%20of%20microservices%20Presentation.pdf)]

Mark talked about how these days microservices are everywhere. DDD, continuous delivery, cloud environments, agility in business and technology were some of the drivers of the rise of microservices. Unfortunately, projects that introduce microservice architectures often are struggling with the complexity. They often miss their project plans and budget.

So before jumping on the bandwagon, you have to be aware of the challenges such a highly distributed architecture comes with. In his talk Mark outlined several pitfalls and gave some best practices to stop the decline and fall of microservices.

---

## How do we take architectural decisions in eBay Classifieds Group - Engin Yöyen
[by Stephan Klapproth]

In his talk Engin presents different approaches to cope with the challenges of a widely distributed team with hundreds of developers, forcing him to rethink the classical role model of a software architect.
Consensual high level architectures, empowering the engineers to lead, architects as supporting enablers (versus architects as governance), techniques like delegation levels and architecture decision records ensured the success of the project at eBay Classifieds Group.

---

## Reactive domain-driven design: From implicit blocking to explicit concurrency - Vaughn Vernon
[by Andreas Zitzelsberger]

Vaughn Vernon took us on an elaborate journey to a reactive domain-driven world. I had two key takeaways:
1. An anemic model, that is a model consisting only of data types, is not sufficient for a reactive domain-driven world. Instead state changing actions should be properly defined. For instance, to provide a method Person.changeAddress instead of Person.setStreet, Person.setCity, … Vaughn pressed the point that this is a necessity for effective reactivity.
2. When migrating to reactive microservices, the strangler pattern is an effective approach. Vaughn pointed out two tools that can help to enable reactivity with the strangler approach: [Debezium](https://debezium.io/), which turns database changes into events and [Oracle Golden Gate](https://www.oracle.com/de/middleware/technologies/goldengate.html).
