---
title: "OOP 2020"
date: 2020-02-28T10:39:32+02:00
draft: false
image: IMG_7017.jpg
author: Florian Kowalski, Uli Schweikl, Vanessa Paulisch and Stefan Billet
tags: [Agile, Continuous Delivery, Conference, DevOps, Digital Transformation, Microservices, OOP, pitest, Software Architecture, Specification, Testing, Conference]
aliases:
    - /posts/2020-02-28-oop/
summary: A field report from the 2020 OOP conference in Munich.
---

In the beginning of February, we took part in the OOP Conference in Munich - a conference focused on Software Architecture, Agility and Digital Transformation. We had a booth in the expo and attended different talks. Our highlights and key take-aways are summarized in this article.

---

## 193 Easy Steps To DevOpsing Your Monolith
*[by Vanessa Paulisch]*

Going into the talk of Cat Swetel, I did not expect 193 examples for DevOpsing a monolith, but I also did not expect the monolith to be an emulated VAX. After failed attempts to rewrite the ticketing software, the goal now was to bring it to a point where adding new features is easier again. She described DevOpsing in this context as finding the right balance between growth and maintenance cost – like every living organism needs to. More concretely, it is the interplay of value adding variety (like new features) and value reducing variety (thus everything that requires maintenance) – and finding the right balance is not a simple task, especially not in an emulated VAX.

---

## From Distributed Monolith to Self-contained Systems: a progress report
*[by Vanessa Paulisch]*

Another insightful example into challenges of grown software was given by Marcos Scholtz and Gregor Tudan. The goal of their team was transforming the application which started with a small microservice architecture but had grown to become a distributed monolith (interdependent microservices) to a set of self-contained systems. The challenges they faced were not only of software architectural nature but also an organizational one (for example related to Conway's Law). Even though no concrete best practice recommendations were given, their talk had plenty of thought-provoking impulses.

---

## Building Evolutionary Architectures
*[by Florian Kowalski]*

In line with some other talks on managing change in the codebase, Neal Ford presented a more proactive method to ensure architectural requirements are upheld over time. Changes in projects are driven both from a technological as well as a business side and inevitable. The question then is, how can we make sure that some basic requirements, like a specific architecture, performance or scaling, are always fulfilled. The answer of Neal Ford and his collaborators is “Evolutionary Architecture” [http://evolutionaryarchitecture.com/] which supports guided, incremental change across multiple dimensions. He primarily focused on architectural fitness functions which are an objective integrity assessment of the architecture. Examples of those include dependency checks to avoid cyclic dependencies, consumer driven contract testing at integration level and also concepts like the Simian Army. These rules should be put directly into the code to always validate the fitness functions.

As a side note: One of Neal Ford’s collaborators, Rebecca Parsons, gave a keynote on the same subject at OOP 2019 [https://www.youtube.com/watch?v=r67uQNrvsbQ].

{{< video "r67uQNrvsbQ" >}}

---

## Start being the change you want to see
*[by Florian Kowalski]*

Everybody knows situations that developed more unpleasant than they should have. For example “you wrote an email instead of just calling the other person” or “you were interrupted at work and offer your help immediately, even though it was not that urgent”.

The talk of Nadine Wolf and Stefan Roock tried to focus on the beginning of these situations. They proposed “to change their own behaviour hopefully changes the behaviour of others”.

Changing your own behaviour is not easy. Slow down and break daily automatism seems to be one of the best approaches. To understand how a specific behaviour (which may lead to an automatism) emerges Nadine and Stefan introduced following model: believe systems => emotions => behaviour

As explanation of this system following example was used: Children are taught that they should value food with the following sentence: “Eat your dinner. Somewhere else children are starving.”

This could be the start for the following subconscious mindset: “I have to eat my entire lunch, otherwise children are starving” (believe system). This mindset triggers liability (emotions) and leads to “eat everything even if I’m sated” (behaviour). To change this behaviour slowing down and reverse engineering seem to be a good approach.

So next time you find yourself in an uncomfortable situation try to take a deep breath, slow down and reflect yourself. The talk proposed that methods like affirmation, 7x70, Ho’oponopono-Mantra or Sedona-Method may help you changing your behavior and therefore change others.

---

## Spock vs Super Mutants: Specification Testing meets Mutation Testing
*[by Uli Schweikl]*

Johannes Dienst and Ralf Müller from DBSystel presented two technologies for testing software they use in their projects. Spock as a test framework allows to formulate tests and reports in natural language. This enables them to involve product owners more in the development process. They can not only evaluate whether the written acceptance tests cover all necessary cases. With Spock, product owners should even be enabled to write the tests themselves.

In addition, the two use the pitest framework to dynamically change or mutate the code under test. These mutants show the developer how robust unit tests are against small changes in the code. Such small changes can have a large impact on the behavior of the code. Pitest comes with a large set of heuristics for mutating code. In addition to pitest for Java, there are a number of other frameworks to implement mutation tests.

---

## Durable Software Architectures – Last for Decades without Debt
*[by Uli Schweikl and Stefan Billet]*

Anecdotal examples of real software systems formed the core of the entertaining talk by Carola Lilienthal. She showed how software systems grow over the years and which problems can arise over the decades. Using clear visualizations Carola Lilienthal showed different types of violations of software architecture. From this experience basic rules and concepts arise, how software - without debts - can survive the decades. Long-lived architectures are often modular, hierarchical and use patterns consistently. Keeping the architecture simple and consistent while adding new features is a continuous refactoring task that takes significant effort, e.g. 20% of the development capacity in every sprint. Not investing this time means the architecture will degrade making the development of new features more and more expensive.

---

## Misunderstandings about Continuous Delivery
*[by Stefan Billet]*

Continuous Delivery (CD) is only about faster "time to market" - one of the misconceptions Eberhard Wolff debunked in his talk. He believes there are more and equally important benefits: reduced risk of outages, faster recovery, fewer bugs, less time spent on manual activities like testing, deployments, change approval, more time spent on new features and ultimately: better overall performance of the organization.

However, CD is not free and not easy. Speeding up the delivery pipeline will uncover organizational weak spots. Introducing CD can be seen as a lean optimization of the whole development process. For example, in a CD pipeline with multiple deployments to production per day, there is no time for manual testing or approval. Beyond "automating all the things", the organization must foster an environment of trust and without fear of errors. CD only makes sense if the organization is willing to reflect and improve. It requires a broad collaboration not only between development and operations (Dev-Ops), but also quality assurance and business (Dev-QA-Ops-Biz).

