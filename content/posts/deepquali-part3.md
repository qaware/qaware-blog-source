---
title: "DeepQuali Part 3: Experiences, Stumbling Blocks and Outlook"
date: 2025-08-12T18:10:34+02:00
author: "[Jörg Viechtbauer](https://www.xing.com/profile/Joerg_Viechtbauer)"
type: "post"
draft: true
tags: [AI, Code Quality, DeepQuali, Co-Pilot]
summary: Now let's look at what we have learned so far, where there are still issues, and where the journey is heading.

---

In the  [first part](../deepquali-part1) we talked about the motivation, in the  [second part](../deepquali-part2) about the principle behind DeepQuali. Now let's look at what we have learned so far, where there are still issues, and where the journey is heading.

# Layers & God Classes - first experiences with DeepQuali
One of the biggest aha moments: The brief descriptions of what a class does and how it's embedded enormously changes the view of a project. Originally, they were only intended as LLM context for architecture assessment, but have proven to be enormously helpful when trying to understand a project. The abstraction level that ChatGPT or Claude achieve is impressive. DeepQuali becomes a navigation system for codebases: You throw in a repository and quickly get a rough map. This saves a lot of time, especially when approaching unfamiliar code. The architecture-focused assessments also work surprisingly well already. The LLM frequently recognizes whether a project is roughly organized by layers, whether it cleanly separates domain logic from the framework, or whether there's a "God Class" monster lurking somewhere.

# DeepQuali in daily work

We see two main ways DeepQuali can provide value in everyday development:

* __Ad hoc analyses:__ When you want to quickly get a picture of a project – whether at startup, during a review, or when doing "code archaeology."
* __Integration into CI/CD pipelines:__ DeepQuali should be usable as a lightweight tool in pipelines. Instead of building a hard quality gate, we want to offer notifications – because scores may fluctuate a bit .

# Insights and Outlook

* Prompt quality is critical to success. We've learned a lot here, but we also know: we know we're probably not at the end of the road yet.
* LLMs don't always deliver 100% the same answers, even with a fixed seed. With lower temperatures (e.g., 0.3) we get more stable assessments, but a bit of fluctuation remains, and we want that too! Because sometimes the unconventional thought provides exactly the impulse you need.
* Currently we focus on JVM languages (Java, Kotlin, Scala, Groovy). With shallow parsers, we want to open up other ecosystems in the future.
* In the future, we also want to include unit tests. This way you get not only an architecture view, but also a feel for how well the software is secured and what problems it has.

# Conclusion

DeepQuali isn’t a silver bullet. But it's a tool that saves time and provides valuable insights. It reveals strengths and weaknesses, provides impulses for better architectural decisions – and makes it easier to find your way around unfamiliar or old codebases.
Important note: DeepQuali checks structure, not correctness. It won’t tell you if your business logic makes sense – or if your architecture actually fits your domain. For that (and a dozen other things), human expertise is still very much required.
For us, DeepQuali is above all one thing: a contribution to making software quality more transparent and tangible. And if it helps you get up to speed faster in your next project, then it has achieved exactly what we wanted.

