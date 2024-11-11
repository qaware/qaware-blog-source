---
title: "Getting started: RAG testing"
date: "2024-11-05T06:00:00+01:00"
lastmod: "2024-11-05T06:00:00+01:00"
author: "[Alexander Eimer](https://github.com/aeimer)"
type: post
image: getting-started-rag-testing/sprint-start-blocks.jpg
tags: [AI, RAG, CWYD, Testgin, "Retrieval Augmented Generation", "Chat with your documents", "Künstliche Intelligenz"]
draft: true
summary: We will have a look on why and how to test your RAG system to always ensure high quality answers.
---

{{< rawhtml >}}
<p style="margin-top: 5px; margin-bottom: 5px;">
    Hero image:
    <a rel="noopener noreferrer" href="https://www.flickr.com/photos/53370644@N06/4976494944">BXP135660</a>
    by
    <a rel="noopener noreferrer" href="https://www.flickr.com/photos/53370644@N06">tableatny</a>
    is licensed under
    <a rel="noopener noreferrer" href="https://creativecommons.org/licenses/by/2.0/?ref=openverse">
        CC BY 2.0
        <img src="https://mirrors.creativecommons.org/presskit/icons/cc.svg" style="height: 1rem; margin: 0 0.1rem; display: inline;" />
        <img src="https://mirrors.creativecommons.org/presskit/icons/by.svg" style="height: 1rem; margin: 0 0.1rem; display: inline;" />
    </a>
</p>
{{< /rawhtml >}}

{{< note >}}
ℹ️&nbsp;&nbsp;
This article is <b>part 2</b> of the RAG series.
There is also the <a href="/posts/getting-started-cwyd/">Getting started with CWYD article</a>.
{{< /note >}}

{{< note >}}
ℹ️&nbsp;&nbsp;
The related Cloud Native Night Mainz talk can be found on
<a href="https://speakerdeck.com/aeimer/ais-secret-weapon-turning-documents-into-knowledge-cwyd">Speakerdeck</a>.
{{< /note >}}

**In this article we will show you why you should test your Retrieval-Augmented Generation (RAG) -- and therefore your "Chat with Your Documents" (CWYD) -- applications.**

RAG systems aren't perfect.

## Why Test Your AI and RAG Application?

Since AI models can change their outputs over time, it's important to **test regularly**.
In fact to develop and improve your AI systems a **data-driven development** is recommended.
Testing is essential for AI and RAG systems, ensuring consistent quality, relevance, and user alignment.
Unlike traditional software, AI responses are **not deterministic**, meaning that traditional testing approaches -- like unit-tests -- aren’t effective.
Here’s why testing is crucial:

- **Validating System Prompt Quality:** The prompt shapes AI behavior; regular testing ensures it generates accurate, helpful, and unbiased responses.
- **Evaluating Prompt Changes:** As prompts evolve, testing confirms that changes improve responses and don’t introduce new issues.
- **Ensuring Accurate Information Retrieval:** RAG systems rely on retrieving relevant data.
  Testing verifies that only correct information is sourced and used.
- **Maintaining Friendly Tone:** Testing catches responses that might come across as unwelcoming or harsh, keeping user experience positive.
- **Preventing Quality Regression** Ongoing testing mitigates quality drift and keeps responses consistent and aligned with user expectations.

Given AI's variability, innovative testing strategies, like using LLMs as evaluators, are essential to maintain response quality and relevance over time.

## How can I test my AI Application?

As AI and RAG systems continue to evolve, thorough testing becomes essential to ensure high-quality and reliable outputs.
Testing these systems involves a structured approach to assess their accuracy, relevance, and ability to retrieve and generate meaningful answers.
Below, we dive into a step-by-step guide on setting up and running tests for AI/RAG systems, alongside selecting metrics to assess performance.

{{< figure figcaption="Steps to test your AI/RAG system with LLM as a judge" >}}
{{< img src="/images/getting-started-cwyd/llm-testing.drawio.svg" alt="Steps to test your AI/RAG system" >}}
{{< /figure >}}

**Step 1: Choose the Right Metrics**

The foundation of any testing approach is **selecting metrics** that capture the **critical aspects** of the system's performance.
Commonly used metrics for evaluating AI/RAG systems include:

- **Faithfulness:** Measures the system's accuracy and checks for hallucinations, or false information.
  Faithful responses should be grounded in factual content.
- **Context Relevance:** Evaluates how well the retrieved information aligns with the query.
  This metric assesses whether the system selected appropriate data from its knowledge base to construct the response.
- **Answer Relevance:** Assesses the quality of the response relative to the question.
  Even if the context is accurate, the system's generated answer must still directly address the question.

These metrics form the basis for a comprehensive evaluation but can be tailored or expanded based on specific needs.

{{< figure figcaption="The testing triangle" >}}
{{< img src="/images/getting-started-cwyd/testing-triangle.drawio.svg" alt="The testing triangle" >}}
<small>Inspired by <a href="https://freeplay.ai/blog/using-llms-to-automatically-evaluate-rag-prompts-pipelines">freeplay.ai</a></small>
{{< /figure >}}

**Step 2: Create a Test Set**

Once metrics are chosen, the next step is creating a test set that includes **well-defined questions, expected answers**, and **relevant context**.
Test data set ready to be evaluated typically includes:

- **Question:** A prompt designed for the system to respond to, such as "When was the first Super Bowl?"
- **Answer:** The AI’s generated response based on its understanding and available context.
- **Contexts:** The chunks or snippets of data provided to the system for retrieval purposes, ensuring it has relevant background information.
- **Ground Truth:** The accurate, validated answer that represents what the system's response should ideally look like.

A robust test set offers a clear reference to compare the system's output against known correct answers.

**Step 3: Implementing an LLM to Rate Responses**

To avoid side effects while testing, consider using a _different_ LLM to **rate the generated responses**.
This **second LLM** can automatically **evaluate** the main AI model’s answers against the defined metrics, reducing the need for manual checks.
By consistently applying rating criteria, this setup provides an objective measure of how well the AI/RAG system meets expectations.

> LLM as a judge is the way to go!

**Step 4: Regularly Run Tests and Analyze Results**

Testing should be a **continuous process** rather than a one-time task.
Regularly running tests allows teams to monitor performance and identify any degradation or improvements in the system over time.
To optimize this process, leverage automated tools such as RAGAS[^101] for custom test setups or promptfoo[^102] for a UI-driven testing environment.

## Key Learnings

TODO

## Conclusion

TODO

<!-- APPENDIX -->

[^101]: https://docs.ragas.io
[^102]: https://www.promptfoo.dev
