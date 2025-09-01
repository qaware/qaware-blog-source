---
title: "DeepQuali: Determining Software Quality with AI"
date: 2025-09-01T08:00:00+02:00
author: "[Jörg Viechtbauer](https://www.xing.com/profile/Joerg_Viechtbauer)"
type: "post"
draft: true
image: DeepQuali.png
tags: [AI, Code Quality, DeepQuali, Co-Pilot]
summary: DeepQuali is an AI-powered “co-pilot” that helps developers quickly spot issues, anti-patterns, and improvement opportunities in software architecture beyond what traditional metrics reveal.
---

> From developer to developer: What comes to mind when you hear "software quality"?

You probably think of terms like "clean code", "unit tests", "modularity", or "architecture". And probably also the experience that despite all these principles, you often find yourself quite in the fog when taking over a large or unfamiliar project.

* Where are the problem areas?
* Which parts are solidly built?
* And: Where are technical debts lurking that will eventually come back to bite you?

Classic quality metrics like "Cyclomatic Complexity" or "Lines of Code" help to some extent, but they usually remain abstract. They say little about the actual context:

* Why is a class so complex?
* Is it really a problem or simply unavoidable?
* And how does it all fit together in the big picture?

This is exactly where DeepQuali comes in. It's not a magic tool that makes decisions for you – but rather a co-worker who quickly gives you a clear picture of a codebase. We at QAware developed DeepQuali together with partners like Fraunhofer IESE as part of a BMBF research project – and particularly contributed the backend. DeepQuali is a building block on the path to better assess and improve software quality.
It's our contribution to making software quality a bit more transparent and tangible – for developers, by developers.

## What classic quality metrics overlook

Many quality approaches still rely on static metrics. Line count, complexity values, test coverage – all of this provides clues. But let's be honest: Every one of us has experienced a project that, despite "green lights," was still hard to grasp, difficult to extend or even fragile! The problem: Numbers alone provide almost no context. They don't tell you whether a project is logically structured, whether a class has a clear responsibility, or whether the interaction of components is coherent. But these are exactly the questions we developers want to answer.
Important note: DeepQuali is not a black-box oracle, all prompts are visible, the results are comprehensible and based on principles we all know – coupling, cohesion, layer models, and so on.

# Architecture feedback with system: DeepQuali as decision support

This is absolutely not about replacing decisions made by architects. DeepQuali cannot and does not want to do that. In the end, the responsibility always remains with us developers and architects. Rather, it provides structured feedback:
* Where is the architecture stable — yet adaptable?
* Which subtle anti-patterns are lurking beneath the surface?
* What parts are wound so tight that any change sparks a chain reaction?

Think of DeepQuali like a very attentive co-pilot: It reads through your code, takes notes, and then says things like:

* "This class does quite a lot – maybe too much?"
* "Your service layer is more tightly coupled to the database layer than you might have intended."
* "This package seems like a candidate for a clear interface."

In the end, you have not just numbers, but an assessment that supports you in refactoring or architectural decisions.

# From classes to architecture – step by step

Now, naturally, a few questions arise:
* But how does it actually work behind the scenes?
* How do we go from raw source code to meaningful architectural insights — without overwhelming the AI (and your wallet too) with mountains of code?

Let’s take a closer look — without diving too deep into algorithms or YAML monstrosities.

## Getting started: Sorting the code

Before we as developers can evaluate anything, we need context — and with code, that means understanding how classes are connected. DeepQuali has two approaches for this:

* Bytecode analysis: Super robust, works for all JVM languages (Java, Kotlin, Scala, Groovy...). Ideal when the code can be built.
* Shallow Parser: comes into play when there's no bytecode available (the project doesn't build) or when dealing with non-JVM languages. It reads the source and recognizes the dependencies.

In the end, we have all classes (and by “class” we now mean any source file) and their dependencies — a network. Sometimes circular. (No! Yes. Oh.)
DeepQuali tames the dependency jungle by linearizing the network — so we usually hit dependencies before the code that uses them. (Technically, it’s an approximation of the Minimum Feedback Arc Set. Graph and algorithm theory folks — we know you're watching.)

## Class-by-class summaries

In this order, we iterate over the classes and create compact summaries (What does the class do? Which methods are important?), where the previously generated summaries of dependencies flow into the analysis.

### An example:

* Class A uses Class B & C, Class B uses Class C.
* Then Class C is analyzed first.
* Then Class B and the summary of Class C flows into the analysis (so the LLM knows what the method calls do).
* Finally, Class A is analyzed and receives the summaries of B and C.

Besides the methods, the AI model also checks architectural principles: Is the class clear? How is the coupling? Are the interfaces simple and understandable?
The summaries help not only the user but also make the code manageable for the AI, without us having to give it the entire source at once (which would very likely blow the context window). All results end up in an index (DeepQuali currently uses OpenSearch for this). There you can retrieve them, filter them, or click through them via a UI.

## From classes to packages

Then it goes up one level. The results of the classes flow into the package analyses. And in packages, the analyses of subordinate packages flow in. So we work our way bottom-up from the deepest packages up to the root package. In the end, a picture emerges of how the project is structured – including hints about layers, patterns, or anti-patterns.

## Scalable analysis through smart summaries

Many approaches for code analysis quickly hit limits with larger projects because the inputs for an AI model become too large. DeepQuali solves this by summarizing agglomeratively. This means: Instead of dumping tens of thousands of lines of code into a model, it generates compact summaries that then serve as context. This keeps the prompts lean and the results still meaningful – even with really large codebases.

## Results that help developers

The AI doesn't evaluate "code lines" or "LOC values." Instead, it focuses on what actually matters:

* __Strengths:__ clear layer separation, intuitive API, good testability
* __Risks:__ OrderProcessor class is too complex, tight coupling to database details
* __Recommendation:__ refactor OrderProcessor to separate business logic from database access

It gives short, focused assessments — and concrete, actionable hints.

## Flexible through scripting

One interesting detail (without diving into the nitty-gritty): DeepQuali is built from the ground up for extensibility — with scripting at its core. That makes it easy to adapt to new scenarios, both now and down the road: from architectural assessments to code quality checks — even niche cases like “code archaeology” in legacy system. Just plug in new functionality using Groovy, JavaScript, or any JSR223-compatible script.

## Examples

This is what DeepQuali outputs look like – two examples:

### 1. The "Summary" of the package de.deepquali.impl.llm:

* __purpose:__ LLM chatbot implementations for multiple providers
* __functionalSummary:__ Provides LLM chatbot functionality across multiple AI providers including OpenAI, Anthropic Claude, Google Gemini, and OpenAI-compatible services. Handles prompt processing, API communication, response extraction, and token usage tracking with provider-specific configurations and tuning parameters embedded in prompts.

You haven’t seen a single line of code — yet you already know what this package does. Now imagine joining a new project. No documentation. No onboarding. Or suddenly owning that gigantic legacy system. DeepQuali brings that kind of clarity — for every package. Helpful? Yep.

### 2. The architecture assessment for "de.deepquali.impl.dependencies.ClassAnalyzer"

#### recommendations

* Extract visitor implementations into separate top-level classes to improve readability and reduce nesting complexity
* Add comprehensive error handling with try-catch blocks around ClassReader.accept() calls to gracefully handle malformed bytecode
* Consider introducing an abstraction layer over ASM to reduce direct coupling and enable easier testing with mock implementations

#### risks

* Tight coupling to ASM library throughout the implementation, making it difficult to replace the bytecode analysis framework
* Complex nested visitor pattern with anonymous inner classes reduces readability and maintainability
* Limited error handling for malformed bytecode or ASM parsing failures could cause unexpected crashes

#### strengths

* Clear separation of concerns with dedicated visitor classes (DependencyGraphCollector) implementing the ASM visitor pattern
* Well-documented public API with comprehensive Javadoc explaining bytecode analysis advantages and limitations
* Thread-safe design using enum singleton pattern with immutable static methods

#### verdict

Well-designed bytecode analysis utility with clear API and good documentation, but suffers from tight ASM coupling and complex nested visitor implementation.

| attribute   | rating        |
| ----------- |---------------|
| apiDesign   | 8 (very good) |
| complexity  | 5 (average)   |
| coupling    | 6 (decent)    |
| focus       | 8 (very good) |
| modularity  | 6 (decent)    |
| testability | 7 (good)      |

What do you think – do you get a feeling from this excerpt of where the architecture is stable and where it struggles? And: Are the recommendations comprehensible enough to derive concrete next steps from them?

## Recognizing technical debt early

Today, cycles are shorter, often accompanied by high pressure. This quickly leads to technical debt that you don't immediately notice in daily work – until it becomes expensive. With DeepQuali, we want to create a way to make such debt visible early. Not through abstract charts, but through concrete hints that come directly from the code. And yes, sometimes it almost feels like code archaeology: An old project without documentation? No problem. DeepQuali works its way through the classes and packages and delivers an overview in minutes that would otherwise take much longer.

## Layers & God Classes - first experiences with DeepQuali

But that’s the theory.
What happens when DeepQuali meets the real world?
Code that’s messy, complex, undocumented — you know, the usual suspects.

Time to share some real-world insights!

One of the biggest aha moments: The brief descriptions of what a class does and how it's embedded enormously changes the view of a project. Originally, they were only intended as LLM context for architecture assessment, but have proven to be enormously helpful when trying to understand a project. The abstraction level that ChatGPT or Claude achieve is impressive. DeepQuali becomes a navigation system for codebases: You throw in a repository and quickly get a rough map. This saves a lot of time, especially when approaching unfamiliar code.

The architecture-focused assessments also work great: the LLM reliably detects whether a project is roughly organized by layers, whether domain logic is cleanly separated from the framework, or whether there’s a “God Class” monster lurking somewhere.

# DeepQuali in daily work

We see two main ways DeepQuali can provide value in everyday development:

* __Ad hoc analyses:__ When you want to quickly get a picture of a project – whether at startup, during a review, or when doing "code archaeology."
* __Integration into CI/CD pipelines:__ DeepQuali should be usable as a lightweight tool in pipelines. Instead of building a hard quality gate, we want to offer notifications – because scores may fluctuate a bit.

## Insights and Outlook

* Prompt quality is critical to success. We've learned a lot here, but we're probably not at the end of the road yet.
* LLMs don't always deliver 100% the same answers, even with a fixed seed. With lower temperatures (e.g., 0.3) we get more stable assessments, but a bit of fluctuation remains, and we want that too! Because sometimes the unconventional thought provides exactly the impulse you need.
* Currently, we focus on JVM languages (Java, Kotlin, Scala, Groovy). With shallow parsers, we want to open up other ecosystems in the future.
* In the future, we also want to include unit tests. This way you get not only an architecture view, but also a feel for how well the software is secured and what problems it has.

# Conclusion

DeepQuali isn’t a silver bullet. But it's a tool that saves time and provides valuable insights. It reveals strengths and weaknesses, provides impulses for better architectural decisions – and makes it easier to find your way around unfamiliar or old codebases.
Important note: DeepQuali checks structure, not correctness. It won’t tell you if your business logic makes sense – or if your architecture actually fits your domain. For that (and a dozen other things), human expertise is still very much required.

For us, DeepQuali is above all one thing: a contribution to making software quality more transparent and tangible. And if it helps you get up to speed faster in your next project, DeepQuali did its job.
