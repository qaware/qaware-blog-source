---
title: "Getting started: Chat with your document"
date: "2024-11-04T06:00:00+01:00"
lastmod: "2024-11-04T06:00:00+01:00"
author: "[Alexander Eimer](https://github.com/aeimer)"
type: post
image: getting-started-cwyd/sprint-start-blocks.jpg
tags: [AI, RAG, CWYD, "Retrieval Augmented Generation", "Chat with your documents", "Künstliche Intelligenz"]
draft: true
summary: We will discover CWYD and RAG and how you can utilize it to improve your information finding and polishing skills.
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
The related Cloud Native Night Mainz talk can be found on
<a href="https://speakerdeck.com/aeimer/ais-secret-weapon-turning-documents-into-knowledge-cwyd">Speakerdeck</a>.
{{< /note >}}

**In this article we will show you how "Chat with Your Documents" (CWYD) works and how you can use it to push your efficiency working with documents and information in general with AI.**

CWYD allows you to interact with text-based documents, such as PDFs or Word files, using a large language model (LLM --- often referred as AI).
You can query specific information from documents, and the model will provide relevant responses based on the content.
It's like having a smart assistant that reads and summarizes documents for you.

We all know how time-consuming it can be to sift through pages of text, looking for specific information.
CWYD enables us to **find, summarize, and polish information quickly**.
This technology is set to **revolutionize** the way we work with documents, speeding up research and decision-making processes by providing **quick, accurate insights**.

> What is "Chat with your documents"?
> 
> **Using an LLM to get answers and findings from documents**   
> (like txt, pdf, docx or any other format with prosa text)

which enables us to 

> **Find, summarize and polish information efficiently**
> 
> It will fundamentally change the way we interact with information as the information gathering is faster and easier than ever before

## How does CWYD relate to Retrieval-Augmented Generation (RAG)?

{{< figure figcaption="Bigger picture: CWYD is a part of RAG" >}}
    {{< img src="/images/getting-started-cwyd/d2-venn-CWYD-only.cropped.svg" alt="Bigger picture: CWYD is a part of RAG" >}}
{{< /figure >}}

CWYD is a part of a broader system called **Retrieval-Augmented Generation (RAG)**.

RAG combines three words, which depict the basic working of a RAG system:

- **Retrieval:** The system searches for relevant documents or document chunks to answer the question of the user.
- **Augmentation:** The retrieved data is provided to the LLM, which should give it real-world (live) information to generate hopefully a context-aware response.
- **Generation:** The LLM creates a response based on the retrieved information.

This method ensures that your responses are **grounded in actual data**, rather than relying solely on the model’s internal knowledge.

## Why shouldn't I fine-tune an LLM with specific information?

Training your **own LLM** is very **expensive**, there is a reason why training GPT-4 costed about **$63 million**[^8]!
Another option might sound like a good idea, fine-tune an existing LLM.
But this comes with challenges:

- **Cost:** Fine-tune a model is expensive, both in terms of computation and time.
- **Inflexibility:** Once fine-tuned, a model is not easily updated without retraining, making it hard to incorporate new data quickly.
- **Security risks:** Ensuring that your data is protected and that access rights are respected is impossible when using the fine-tuned LLM.
- **Bad detail retrieval:** LLMs are good at understanding structures, but it can be hard to "remember" details for them.
You can compare it as if you want to memorize a phonebook vs keep the plot of a novel in mind.
Learning a whole phonebook is pretty hard and error-prone, remembering the plot of a book is fairly easy.

Instead, using a pre-trained LLM -- like GPT-4o from OpenAI -- off the shelf with RAG allows for **flexible, up-to-date, and cost-efficient** responses which are more often correct than a fine-tuned LLM.
If you want to let a pre-trained LLM know about a whole knowledge-domain then it is often necessary to fine-tune a LLM.
In any case, data used for the fine-tuning should be allowed to be accessed by anyone who has access to the LLM and should be quite static information.

## Why RAG Works Better with GPT-4 Turbo and later

LLMs **struggled** in past with **remembering details**, just like us humans.
Over time this got better, but **things written in the beginning** of the token-window are **less likely** to be **remembered** when asked at the **end** of the token-window.

The **recall** defines how good a model can **remember a "needle"** -- some specific information placed at the beginning of the context -- in a **lot of information**.
The better the recall is the longer the documents can be that we can pass into the LLM and still get reasonable results.

**GPT-4 Turbo** has **improved** its **memory** -- so-called "recall" -- and can handle larger inputs, making it capable of processing (bigger) documents in one go[^1].
Earlier models like GPT-3.5 Turbo with only a 4096 token input-window had limitations in this regard, making chunking a necessity.
The **improvements in recall** make GPT-4 Turbo the first OpenAI model suitable for larger RAG applications, as it consistently provides detailed information from the context it has been given.

With the latest **GPT-4o model** the recall is very good.
This makes it a **perfect choice** for state-of-the-art RAG applications.

## How does a RAG-prompt look like?

Taking a look under the hood usually helps to understand the process better.
So let's have a look what happens when we have some plain text from a document that we want to chat with.

{{< note >}}
ℹ️&nbsp;&nbsp;
This example show a very basic chatbot with RAG.
A realworld application is more complex, but for the sake of learning the process is simplified.
{{< /note >}}

Applications like teh ChatGPT-backend will generate a prompt composed of different elements.
This prompt is ultimately sent to the LLM, which then generates an answer based on the info provided.
The prompt usually consists of different elements.

* `system_prompt`: The usually hardcoded instructions the developers define.
This prompt sets the stage so the LLM knows what it has to do.
* `chat_history`: The messages sent to the LLM so far.
* `document`: The document or parts of the document where relevant information are provided.
* `user_input`: The latest question of the user.

The example code mimics a backend service of a chatbot like ChatGPT.
The prompt can be easily templated by just appending strings.
The function `ai_model.complete()` takes a string and sends a so-called completion request to the AI model, which is the default mode of interacting with an AI.

```
ai_model.complete("
{{ system_prompt }}
---
{{ chat_history }}
---
{{ document }}
---
{{ user_input }}
")
```

Once the placeholders are replaced with specific content, the text may appear as follows.
In this case we provided a rental agreement as `document` and we want to get some specific information from it.
The output of the LLM is then forwarded to the user and is usually presented as answer of the AI.

```
ai_model.complete("
You are a friendly ChatBot called QAbot.
You never get rude or disrespectful.
Always stick with the information provided to you.
Do not answer with knowledge you have outside of the text.
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
")
```

In the next example you can see that for asking a follow-up question the previous chat messages are provided.
Also, the document is provided again.
The new user input is placed at the end.
If we ask a follow-up the actual prompt sent to the LLM looks like the following.

```
ai_model.complete("
You are a friendly ChatBot called QAbot.
You never get rude or disrespectful.
Always stick with the information provided to you.
Do not answer with knowledge you have outside of the text.
---
Your chat history so far was:
USER:
What are my obligations when I want to move out of my flat?
BOT:
You need to paint the walls in white color.
Also, you need to make sure that all stains in the floor are removed and
everything is swept clean before you leave.
---
The user has the following document as further input:
Rental agreement
This is a rental agreement between [...]
---
The userinput is:
Thanks, but do I also need to return the key or can I just throw it away?
")
```

The response from the LLM is then forwarded to the user.
The LLM can now generate an answer that builds upon the previous conversation.
This enables a chatbot to have an actual conversation.

LLMs are stateless, so the **history of the chat** needs to be **provided with each request**.
This is also the reason why chats with ChatBots at some point ask you to start a new chat.
The **input context-window** of the **LLM is limited**, at some point the chat-history outgrows the input-limit.
This also **limits the length** of the **document** which can be passed to the LLM.
The overall prompt with all parts counted together are required to have less token than the LLM models input context-window limitation.

{{< note >}}
ℹ️&nbsp;&nbsp;
The truth is LLMs do have a state, but it is several gigabyte big.
Therefore, the state of an LLM is <i>not</i> saved between requests.
There are ways to do it, and we will probably see it used in the future.
{{< /note >}}

See article about LLM state caching[^10].

## Chunks vs. Full Document in CWYD

The techniques used for CWYD can be split into two variants.
Each method has its own pros and cons, lets have a look at them.

{{< figure figcaption="CWYD variants are full document and chunks (e.g. semantic or keyword search)" >}}
    {{< img src="/images/getting-started-cwyd/d2-venn-CWYD.cropped.svg" alt="CWYD variants" >}}
{{< /figure >}}

The **two variants** for interacting with documents via AI using **CWYD** are:

**Full Document**: The LLM is provided with the entire document.
This approach works best with shorter documents and provides a comprehensive overview.
This is usually referred as "Long Context RAG".

**Chunks**: The document is divided into smaller, meaningful parts, or "chunks".
Each chunk should represent a distinct idea or section of the document.
This method is more cost-effective regarding token usage and can handle larger documents but requires good chunking-strategies to maintain semantic context.
The most important part when using chunks is the retrieval-strategy.
We will come to that soon.

The simplest way of doing CWYD is to convert the -- lets say `.docx` -- document into a plain text file, add it to the prompt, and you are good to go.

If we look at **RAG applications** in general **chunking is the dominant mode** as it allows to pass just the _right_ information.
The method how the chunks are retrieved is another topic, in the image above two common methods are displayed "semantic search" and "keyword search".
But there are **three problems** with it.
First you **can't summarize** the document as you just have a few snippets of the whole document in your prompt if that is what user asks for.
Second, finding the best **cut-size for chunks** is very hard.
You want to have quite a block of text, but not too long and then most importantly the text should form one semantic block.
You don't want to have two topics in one chunk.
We will have a look into that later on.
Third, finding the **best matching chunks** for the question the user asked is also hard.
There are solutions for that, but you have to tweak and test.

There are many ways to do RAG.
In this article, we'll talk about basic RAG.
In advanced RAG, different techniques are often mixed together.
So, the line between chunks and the full document is not always as clear.

## How does retrieval work?

{{< figure figcaption="Options to retrieve information" >}}
    {{< img src="/images/getting-started-cwyd/d2-venn-RAG.cropped.svg" alt="Options to retrieve information" >}}
{{< /figure >}}

**R**AG relies on retrieval methods to find relevant information.
The **most common** techniques are **keyword-** and **semantic search**.
In RAG applications there can be **any kind of information source** like APIs, Google search results or maybe even other LLMs.
Common retrival techniques are:

- **Full Document:** Loads the full document from e.g. a blob store and passes the information to the LLM.
➡️ _Full document_
- **Keyword Search:** The generally most common form of search where specific keywords are matched and the found chunks passed to the LLM.
➡️ _Chunking based_
- **Semantic Search:** More advanced, it uses embeddings to find chunks with similar meanings, not just matching keywords.
In RAG, semantic search paired with chunking helps the LLM to understand the context of the question, improving the relevancy of the found chunks which leads to an improved quality of the LLM responses.
The user usually asks semantic questions when using a chatbot, not "just a Google search".
Therefore, search results based on semantic search work better with these kind of "seach query".
➡️ _Chunking based_
- **Knowledge Graphs:** Just lately retrieval methods based on graph databases got published by Microsoft[^2] and Neo4j[^3].
Finding the right chunks for the question based on semantic graphs sounds promising.
Using graphs enables us not only to match for keywords or the semantic of a chunk but also other neighbored chunks can be retrieved and provided.
This gives the LLM more context to work with, which will improve the answer quality.
Problem here is the generation of the graph.
➡️ _Chunking based_
- **API:** A very generic example is APIs.
The RAG application can retrieve information from any API/source like the latest weather data, news, a Google search with some specific keywords -- you name it!
The RAG application just passes the data to the LLM, and it will work with it.

## What is semantic search?

Finding the _relevant_ chunks is essential for a RAG application.
Only searching by keywords has some good chances to miss relevant context if it is not named exactly the same.
Therefore, **searching by the semantic** meaning of the text is **better approach**.
In fact semantic search recently got famous with AI and RAG but got **first mentioned in 2003**[^9]!

{{< figure figcaption="RAG with semantic search" >}}
    {{< img src="/images/getting-started-cwyd/RAG-flow-with-phases.drawio.svg" alt="RAG with semantic search" >}}
{{< /figure >}}

Semantic search is often at the heart of R**A**G, enabling more relevant and meaningful information retrieval by **focusing on the meaning** behind words rather than just their lexical similarity.
This approach utilizes embeddings -- vector representations of text -- allowing the system to understand and compare the **semantic "closeness"** of different pieces of text.

RAG with semantic search typically follows a **two-phase process**:

- **Ingestion Phase:**
Text data is broken down into manageable, semantically meaningful chunks.
- **Retrieval Phase:**
When a query is made, the system retrieves the chunks that are semantically close to the query by comparing their vector embeddings.
In this phase, the goal is to match the query to the most relevant content, ensuring that only the text segments with similar semantic value are retrieved.

### Chunking is hard

Cutting text into "chunks" is crucial for successful semantic search and therefore for RAG.
Each chunk should ideally represent **one primary topic**, making it easier for the system to process and retrieve specific information **without mixing topics**.
Several chunking **strategies** can be applied:

- **Simple Chunking:** Cuts the input text into chunks by counting characters or tokens.
- **Recursive Chunking:** This is a commonly used technique which works a bit like a binary search.
Each chunk gets split in half recursively until the chunk size matches the given chunk limit.
The borders of the chunks are chosen at semantic useful points like new lines, dots or headlines.
- **Semantic Chunking:** A more complex approach that uses semantic understanding to ensure each chunk represents one distinct idea or topic.
For example, consider a chunk that captures the essence of QAware's mission and expertise in software engineering.
This approach would help ensure that when a user queries something related to software engineering or agile development, only the relevant chunk from QAware’s mission statement is retrieved.

A common challenge with chunking is that the information needed to answer a question is often distributed across multiple chunks.
If not all chunks are retrieved, the answer will not include the information which it should have included.
Therefore, one of the **big challenges** is how to **size and cut the chunks** that are searched for and served to the LLM.

{{< figure figcaption="Example chunking of a text" >}}
<blockquote style="opacity: 1; text-align: left; margin-bottom: 0;">
<p>
<span style="background-color: #1A73E8;">
QAware unites people who share a passion for coding.
We have a deep expertise in software engineering, and a keen eye for perfectly tailored solutions.
</span>
&nbsp;
<span style="background-color: #3f51b5;">
Since 2005, we’ve been boosting corporations, medium-sized companies, and startups with exceptional quality and productivity in agile software engineering.
Our journey as cloud pioneers began in 2010.
</span>
&nbsp;
<span style="background-color: #f39200;">
We are asked when legacy applications need to be analyzed, stabilized or remediated.
When they need to go lightweight in the cloud.
</span>
&nbsp;
<span style="background-color: #c7d400;">
And we are the ones who build new systems with craft pride, inventiveness and passion.
</span>
&nbsp;
<span style="background-color: #c00d0d;">
You benefit from excellent code. From outstanding quality.
From forward-thinking innovation.
And from insights into the real levers for more impact.
</span>
</p>
</blockquote>
{{< /figure >}}

### Semantic Similarity and Vector Representations

**Semantic similarity measures** how **"close" the meanings** of different pieces of text are.
Unlike exact keyword matching, **semantic similarity** calculates the **"distance" between items** based on their meanings, which is represented through **vectors**.
These vectors are generated by embedding models like OpenAI’s `text-embedding-ada-002`, which translates text into a high-dimensional vector space, where semantically similar texts are closer together.

> Semantic similarity is a metric defined over a set of documents or terms, where the idea of distance between items is based on the likeness of their meaning or semantic content as opposed to lexicographical similarity.
> 
> Wikipedia --- Semantic similarity[^4]

Once text chunks are converted into vectors, they are **stored in a vector database**, enabling fast retrieval.
Vector databases -- such as `Weaviate`, `Chroma`, or `PostgreSQL` with `pg_vector` -- store and search vectors efficiently.
The support of the **cosine similarity function** lets the database quickly locate vectors closest to the query’s vector.
This setup provides the foundation for RAG to retrieve the right information based on meaning, not just surface-level keywords.

By **combining chunking, semantic embedding**, and **vector storage**, we can build a RAG-based system that aligns query intent with relevant content, resulting in **highly effective, context-driven answers**.

## What should I use?

Choosing between full document and semantic search approaches in a RAG application involves weighing several key considerations.
Both methods have their pros and cons depending on factors like **cost, response time, complexity, and document size**.
Here’s a breakdown to help you make the best choice.

**1. Cost Considerations:**
- **Full Document Search:** With this approach, the entire document is fed into the model as context.
However, this means more input tokens, translating to higher usage costs in many LLM APIs.
- **Semantic Search:** This approach relies on embedding the content and storing it in a vector database, which adds a layer of cost related to embeddings and database management.
However, semantic search generally reduces the number of tokens per request since it focuses on relevant chunks.

**2. Time Efficiency:**
- **Full Document Search:** Shorter input requests mean faster responses, so if you’re working with small, straightforward documents, this could be the quicker option.
- **Semantic Search:** Running semantic search can take extra time, as it involves fetching, ranking, and retrieving the most relevant document chunks.
For applications with caching capabilities or context-persisting options, semantic search may be more efficient.

**3. Effort and Complexity:**
- **Full Document Search:** This is a simpler, lower-effort option, as it doesn’t require specialized search or retrieval models --- just the LLM and the document input.
- **Semantic Search:** Implementing semantic search requires additional infrastructure, including embedding generation, chunking, and database storage for document embeddings.
For larger projects, this added complexity might pay off in relevance and flexibility, but it demands a higher level of setup and maintenance.

**4. Document Size:**
- **Full Document Search:** Works well for documents that fit within the maximum token limit of the model.
Beyond that, this method won’t be feasible without truncating content, risking information loss.
- **Semantic Search:** Can handle documents of any size, as larger documents can be split into chunks and queried in sections.
This scalability makes it a better choice for applications dealing with large or complex documents.

To summarize it:
Choose **full document** for **smaller tasks** where simplicity, lower cost, and speed are priorities, and the **documents fit** within the model’s **context limits**.
For **large, detailed documents** or applications requiring more nuanced answers, semantic search offers greater flexibility and scalability, despite at a higher complexity and setup cost.


## Why Test Your AI and RAG Application?

TODO: Zweiter artikel ab hier?

RAG systems aren't perfect.
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
To optimize this process, leverage automated tools such as RAGAS[^6] for custom test setups or promptfoo[^7] for a UI-driven testing environment.

## Key Learnings

- In the long term, RAG or similar technologies will revolutionise the way we search and research information.
- Retrieval is a difficult topic.
  Especially semantic search is difficult to implement in practice.
- Research is strong.
  With RAG, the solution space has exploded.
  But most of the Advanced techniques won’t survive.
- Following and evaluating the innovations is a full-time job.

## Conclusion

Using CWYD with RAG technologies like GPT-4 Turbo can significantly enhance how we interact with large volumes of text.
By combining retrieval and generation, you can quickly get answers from your documents, making research and decision-making faster and more efficient.

Whether you're looking for specific information in a legal document or trying to summarize a report, CWYD makes it possible to chat directly with your files and get the information you need, when you need it.

Setting up an AI/LLM or RAG application can be hard.
Some guidelines on what should be done can be found in the blogpost of Eugene Yan[^5].

<!-- APPENDIX -->

[^1]: https://www.databricks.com/blog/long-context-rag-performance-llms
[^2]: https://github.com/microsoft/graphrag
[^3]: https://neo4j.com/blog/graphrag-manifesto/
[^4]: https://en.wikipedia.org/wiki/Semantic_similarity
[^5]: https://eugeneyan.com/writing/llm-patterns/
[^6]: https://docs.ragas.io
[^7]: https://www.promptfoo.dev
[^8]: https://team-gpt.com/blog/how-much-did-it-cost-to-train-gpt-4/
[^9]: https://www2003.org/cdrom/papers/refereed/p779/ess.html
[^10]: https://medium.com/@plienhar/llm-inference-series-3-kv-caching-unveiled-048152e461c8
