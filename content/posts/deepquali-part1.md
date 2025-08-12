---
title: "DeepQuali Part 1: Determining Software Quality with AI"
date: 2025-08-12T17:50:10+02:00
author: "[Jörg Viechtbauer](https://www.xing.com/profile/Joerg_Viechtbauer)"
type: "post"
draft: true
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

# What classic quality metrics overlook

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

# Outlook

This is the start of a small blog series.
In the next part, we’ll explore how DeepQuali works – no deep, just enough to grasp what’s going on under the hood. 
And in part three, we’ll share lessons learned, stumbling blocks, and where the journey might lead next. 
