---
title: "Getting started: Chat with your document"
date: "2024-10-23T06:00:00+01:00"
lastmod: "2024-10-23T06:00:00+01:00"
author: "[Alexander Eimer](https://github.com/aeimer)"
type: post
image: getting-started-rag-cwyd/sprint-start-blocks.jpg
tags: [AI, RAG, CWYD, "Retrieval Augmented Generation", "Chat with your documents", "Künstliche Intelligenz"]
draft: true
summary: We will discover CWYD and RAG and how you can utilize it to improve your information finding and polishing skills.
---

{{< rawhtml >}}
<p style="margin-top: 5px; margin-bottom: 5px;">
    Hero image:
    "<a rel="noopener noreferrer" href="https://www.flickr.com/photos/53370644@N06/4976494944">BXP135660</a>"
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
ℹ️&nbsp;&nbsp;The related CNN talk can be found on
<a href="https://speakerdeck.com/aeimer/ais-secret-weapon-turning-documents-into-knowledge-cwyd">Speakerdeck</a>.
{{< /note >}}

"Chat with Your Documents" (CWYD) allows you to interact with text-based documents, such as PDFs or Word files, using a language model (LLM).
You can query specific information from documents, and the model will provide relevant responses based on the content.
It's like having a smart assistant that reads and summarizes documents for you.

We all know how time-consuming it can be to sift through pages of text, looking for specific information.
CWYD enables us to **find, summarize, and polish information quickly**.
This technology is set to **revolutionize** the way we work with documents, speeding up research and decision-making processes by providing **quick, accurate insights**.

> **Using an LLM to get answers and findings from documents**   
> (like txt, pdf, docx or any other format with prosa text)

which enables us to 

> **Find, summarize and polish information efficiently**  
> It will fundamentally change the way we interact with information as the information gathering is faster and easier than ever before

## How does CWYD relate to Retrieval-Augmented Generation (RAG)?

{{< figure figcaption="Hello World Caption" >}}
    {{< img src="/images/getting-started-rag-cwyd/rag-bigger-picture.png" alt="Hello World title picture" >}}
{{< /figure >}}

CWYD is a part of a broader system called **Retrieval-Augmented Generation (RAG)**.

RAG combines the power of search with the generative capabilities of language models.
Here's how it works:

- **Retrieval:** The system searches for relevant documents or document chunks to answer a question.
- **Augmentation:** The retrieved data is provided to the LLM, giving it real-world information to generate a context-aware response.
- **Generation:** The LLM creates a response based on the retrieved information.

This method ensures that your responses are **grounded in actual data**, rather than relying solely on the model’s internal knowledge.

## Why shouldn't I train an LLM with specific information?

Training your own LLM might sound like a good idea, but it comes with challenges:

- **Cost:** Training a model is expensive, both in terms of computation and time.
- **Inflexibility:** Once trained, a model is not easily updated without retraining, making it hard to incorporate new data quickly.
- **Security risks:** Ensuring that your data is protected and that access rights are respected can be difficult during the training process.

Instead, using a pre-trained LLM with RAG allows for **flexible, up-to-date, and cost-efficient** responses.

## How does a RAG-prompt look like?

Taking a look under the hood usually helps to understand the process better.
So let's have a look what happens when we have some plain text that we want to chat with.

Applications like ChatGPT will generate a prompt composed of different elements.
This prompt is ultimately sent to the LLM, which then just answers with the info provided.

* `system_prompt`: The usually hardcoded instructions the developers define.
* `chat_history`: The messages sent to the LLM so far.
LLMs are stateless, so the history of the chat needs to be provided with each request.
* `document`: The document or parts of the document where relevant information are provided
* `user_input`: The latest question of the user

```
ai_model.complete(“
{{ system_prompt }}
{{ chat_history }}
{{ document }}
{{ user_input }}
“)
```

When the placeholder are replaced with explicit content, it may look something like the following.
In this case we provided a rental agreement and want to get some specific information from it.
The output of the LLM is then forwarded to the user and is usually presented as answer of the AI.

```
ai_model.complete(“
You are a friendly ChatBot called QAbot. You never get rude or disrespectful.
---
Your chat history so far was:
N/A
---
The user has the following document as further input:
Rental agreement
This is a rental agreement between [...]
---
The userinput is:
What are my obligations when I want to move out of my flat?
“)
```

If we ask a follow-up question the actual prompt sent to the LLM looks like the following.
You can see that the previous chat messages are provided.
The document is provided again.
The new user input is placed again at the end.

```
ai_model.complete(“
You are a friendly ChatBot called QAbot. You never get rude or disrespectful.
---
Your chat history so far was:
USER:
What are my obligations when I want to move out of my flat?
BOT:
You need to paint the walls in white color. Also, you need to make sure that all stains in the floor are removed and everything is swept clean before you leave.
---
The user has the following document as further input:
Rental agreement
This is a rental agreement between [...]
---
The userinput is:
Thanks, but do I also need to return the key or can I just throw it away?
“)
```

The response of the LLM is again forwarded to the user.
The LLM can now generate a better answer which also builds upon the already happened conversation.

## Chunks vs. Full Document in CWYD

There are two methods for interacting with documents using CWYD/RAG:

**Full Document**: The LLM is provided with the entire document.
This approach works best with shorter documents and provides a comprehensive overview.

**Chunks**: The document is divided into smaller, meaningful parts, or "chunks".
Each chunk represents a distinct idea or section of the document.
This method is more cost-effective and can handle larger documents but requires good chunking strategies to maintain context.

## Why Full Document Works Better with GPT-4 Turbo

GPT-4 Turbo has improved memory and can handle larger inputs, making it capable of processing entire documents in one go.
Earlier models had limitations in this regard, making chunking a necessity.
Especially the improvements on the "recall" makes it the first model of OpenAI which can be used for larger RAG applications.

## How does retrieval work?

{{< figure figcaption="Hello World Caption" >}}
    {{< img src="/images/getting-started-rag-cwyd/rag-information-sources.png" alt="Hello World title picture" >}}
{{< /figure >}}

RAG relies on retrieval methods to find relevant information.
The most common techniques are:

**Keyword Search**: A basic form of search where specific keywords are matched.

**Semantic Search**: More advanced, it uses embeddings to find documents with similar meanings, not just matching keywords.
In RAG, semantic search paired with chunking helps the system understand the context better, improving the quality of the responses.

{{< figure figcaption="Hello World Caption" >}}
    {{< img src="/images/getting-started-rag-cwyd/cwyd-variants.png" alt="Hello World title picture" >}}
{{< /figure >}}

{{< figure figcaption="Hello World Caption" >}}
    {{< img src="/images/getting-started-rag-cwyd/semantic-search.png" alt="Hello World title picture" >}}
{{< /figure >}}


## Why and How Should You Test RAG Systems?

RAG systems aren't perfect.
Since AI models can change their outputs over time, it's important to test regularly.
Here’s why:

**Hallucinations**: Sometimes the AI might make up information, so you need to ensure it’s giving accurate responses.

**Context relevance**: Make sure the system is retrieving the right chunks or documents for a query.

**Response quality**: Evaluate whether the answers are appropriate and relevant to the question asked.

## Testing approach:

{{< figure figcaption="Hello World Caption" >}}
    {{< img src="/images/getting-started-rag-cwyd/testing-process.png" alt="Hello World title picture" >}}
{{< /figure >}}

Create a set of test questions.
Use an LLM to evaluate the quality of the responses.
Check that the correct document sections (chunks) are retrieved.

## Stages of Chatbots

{{< figure figcaption="Hello World Caption" >}}
    {{< img src="/images/getting-started-rag-cwyd/ai-bot-stages.png" alt="Hello World title picture" >}}
{{< /figure >}}

## Conclusion

Using CWYD with RAG technologies like GPT-4 Turbo can significantly enhance how we interact with large volumes of text.
By combining retrieval and generation, you can quickly get answers from your documents, making research and decision-making faster and more efficient.

Whether you're looking for specific information in a legal document or trying to summarize a report, CWYD makes it possible to chat directly with your files and get the information you need, when you need it.

If you want to enhance your information retrieval we can help you with a custom solution specifically tailored to your needs.
