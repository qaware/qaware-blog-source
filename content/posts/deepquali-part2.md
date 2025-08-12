---
title: "DeepQuali Part 2: How it works"
date: 2025-08-12T18:10:10+02:00
author: "[Jörg Viechtbauer](https://www.xing.com/profile/Joerg_Viechtbauer)"
type: "post"
draft: true
tags: [AI, Code Quality, DeepQuali, Co-Pilot]
summary: In the first part we explained why we want to rethink software quality with DeepQuali. Today, let’s take a closer look. How does it actually work — without diving deep into algorithms or YAML monstrosities.

---

In the [first part](../deepquali-part1) we explained why we want to rethink software quality with DeepQuali.
Today, let’s take a closer look: How does it actually work — without diving deep into algorithms or YAML monstrosities.

# From classes to architecture – step by step

## Getting started: Sorting the code

Before we as developers can evaluate anything, we need context — and with code, that means understanding how classes are connected. DeepQuali has two approaches for this:

* Bytecode analysis: Super robust, works for all JVM languages (Java, Kotlin, Scala, Groovy...). Ideal when the code can be built.
* Shallow Parser: comes into play when there's no bytecode available (the project doesn't build) or when dealing with non-JVM languages. It reads the source and recognizes the dependencies.

In the end, we have all classes (and by “class” we now mean any source file) and their dependencies — a network. Sometimes circular. (No! Yes. Oh.) 
DeepQuali tames the dependency jungle by linearizing the network — so we usually hit dependencies before the code that uses them. (Technically, it’s an approximation of the Minimum Feedback Arc Set. Graph and algorithm theory folks — we know you're watching.)

## Class-by-class summaries

In this order, we iterate over the classes and create a compact summaries (What does the class do? Which methods are important?), where the previously generated summaries of dependencies flow into the analysis.

### An example:

* Class A uses Class B & C, Class B uses Class C.
* Then Class C is analyzed first.
* Then Class B and the summary of Class C flows into the analysis (so the LLM knows what the method calls do).
* Finally, Class A is analyzed and receives the summaries of B and C.

Besides the methods, the AI model also checks architectural principles: Is the class clear? How is the coupling? Are the interfaces simple and understandable?
The summaries help not only the user but also make the code manageable for the AI, without us having to give it the entire source at once (which would very likely blow the context window). All results end up in an index (DeepQuali currently uses OpenSearch for this). There you can retrieve them, filter them, or click through them via a UI.

## From classes to packages

Then it goes up one level. The results of the classes flow into the package analyses. And in packages, the analyses of subordinate packages flow in. So we work our way bottom-up from the deepest packages up to the root package. In the end, a picture emerges of how the project is structured – including hints about layers, patterns, or anti-patterns.

# Scalable analysis through smart summaries

Many approaches for code analysis quickly hit limits with larger projects because the inputs for an AI model become too large. DeepQuali solves this by summarizing agglomeratively. This means: Instead of dumping tens of thousands of lines of code into a model, it generates compact summaries that then serve as context. This keeps the prompts lean and the results still meaningful – even with really large codebases.

# Results that help developers

The AI doesn't evaluate "code lines" or "LOC values." Instead, it focuses on what actually matters:

* __Strengths:__ clear layer separation, intuitive API, good testability
* __Risks:__ OrderProcessor class is too complex, tight coupling to database details
* __Recommendation:__ refactor OrderProcessor to separate business logic from database access

It gives short, focused assessments — and concrete, actionable hints. You’ll see examples below. 

# Flexible through scripting

One interesting detail (without diving into the nitty-gritty): DeepQuali is built from the ground up for extensibility — with scripting at its core. That makes it easy to adapt to new scenarios, both now and down the road: from architectural assessments to code quality checks — even niche cases like “code archaeology” in legacy system. Just plug in new functionality using Groovy, JavaScript, or any JSR223-compatible script. 

# Examples

This is what DeepQuali outputs look like – two examples:

## The "Summary" of the package de.deepquali.impl.llm:

* __purpose:__ LLM chatbot implementations for multiple providers
* __functionalSummary:__ Provides LLM chatbot functionality across multiple AI providers including OpenAI, Anthropic Claude, Google Gemini, and OpenAI-compatible services. Handles prompt processing, API communication, response extraction, and token usage tracking with provider-specific configurations and tuning parameters embedded in prompts.

You haven’t seen a single line of code — yet you already know what this package does. Now imagine joining a new project. No documentation. No onboarding. Or suddenly owning that gigantic legacy system. DeepQuali brings that kind of clarity — for every package. Helpful? Yep.

## The architecture assessment for "de.deepquali.impl.dependencies.ClassAnalyzer"

### recommendations

* Extract visitor implementations into separate top-level classes to improve readability and reduce nesting complexity
* Add comprehensive error handling with try-catch blocks around ClassReader.accept() calls to gracefully handle malformed bytecode
* Consider introducing an abstraction layer over ASM to reduce direct coupling and enable easier testing with mock implementations

### risks

* Tight coupling to ASM library throughout the implementation, making it difficult to replace the bytecode analysis framework
* Complex nested visitor pattern with anonymous inner classes reduces readability and maintainability
* Limited error handling for malformed bytecode or ASM parsing failures could cause unexpected crashes

### strengths

* Clear separation of concerns with dedicated visitor classes (DependencyGraphCollector) implementing the ASM visitor pattern
* Well-documented public API with comprehensive Javadoc explaining bytecode analysis advantages and limitations
* Thread-safe design using enum singleton pattern with immutable static methods

### verdict

Well-designed bytecode analysis utility with clear API and good documentation, but suffers from tight ASM coupling and complex nested visitor implementation.

| attribute   | rating.       |
| ----------- | ------------- |
| apiDesign   | 8 (very good) |
| complexity  | 5 (average) |
| coupling    | 6 (decent) |
| focus       | 8 (very good) |
| modularity  | 6 (decent) |
| testability | 7 (good) |

What do you think – do you get a feeling from this excerpt of where the architecture is stable and where it struggles? And: Are the recommendations comprehensible enough to derive concrete next steps from them?

# Recognizing technical debt early

Today, cycles are shorter, often accompanied by high pressure. This quickly leads to technical debt that you don't immediately notice in daily work – until it becomes expensive. With DeepQuali, we want to create a way to make such debt visible early. Not through abstract charts, but through concrete hints that come directly from the code. And yes, sometimes it almost feels like code archaeology: An old project without documentation? No problem. DeepQuali works its way through the classes and packages and delivers an overview in minutes that would otherwise take much longer.
In the next part, we'll discuss what experiences we've had so far, what stumbling blocks there are – and where we still want to go with DeepQuali.
