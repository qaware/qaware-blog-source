---
title: "The Creative Director of Code - Orchestrating Agents, Building Systems"
date: 2026-01-12T18:00:00+01:00
author: "Sebastian Macke"
type: "post"
image: "creative_director_of_code.png"
categories: []
tags: [AI agents, Coding Agents, Software abstraction, Developer productivity]
draft: false
summary: Programming is shifting from writing code to directing agents, where the key skill is managing uncertainty
---

There are not many developers anymore who still need to understand what a programming language compiler actually does, let alone how the generated assembly code works or what the circuits on the chip have to look like to execute the code. Instead, today we develop at a high level of abstraction, together with machines.

These layers of abstraction have emerged over the last hundred years. They have massively increased developer productivity. A factor of one hundred per evolutionary step would probably still be an understatement. 

The last few decades, in particular, have been shaped by the attempt to pursue programming approaches that are as declarative as possible. We no longer say how to do something, but what we want to achieve. You describe the intent in a specialized syntax, and the concrete code is generated from it automatically.

# The New Programming Language Will Be English

Following the trend of abstraction layers, Andrej Karpathy [coined a sentence](https://x.com/karpathy/status/1617979122625712128) in a viral post on X back in 2023 that has been quoted almost daily ever since:

> The hottest new programming language is English

If you take this idea to its logical conclusion, what we today call programming languages is merely pushed one layer deeper, similar to what happened with assembly back then. In the end, it becomes nothing more than a compile target. Software on demand.

The source code we have today would thus become increasingly irrelevant, generated at a speed far beyond what we can still read, understand, or edit ourselves.

Instead, we shift toward specifications, system prompts for agents, and feedback loops. People who write code by hand will seem as absurd as people who write assembly by hand do today.

# Coding Agents Have Crossed a Threshold

At the end of November, Anthropic shipped an update to their coding agent Claude Code with Opus 4.5 and the first thing I noticed wasn’t “it knows more.” It was that it works differently. For the first time, I had the feeling I wasn’t prompting a model, but collaborating with an agent that can actually carry a project forward on its own.

Not autonomously in a hands-off, “set it and forget it” way, but autonomously in the collaborative sense: it can take initiative, make reasonable decisions, and solve problems with me. It asks follow-up questions, drafts a plan, executes it, and critiques its own output as it goes.

Every coding problem that I could define clearly enough and that fit within the agent’s context size, the chatbot could solve. And these were not simple tasks. It was not just about writing and testing code, but also about reverse engineering and [cracking encoding](https://github.com/s-macke/coding-agent-benchmark?tab=readme-ov-file#8-write-decode-for-an-unknown-encode-function) problems.

One example: the long-forgotten German computer game [“Weltendämmerung”](https://github.com/s-macke/weltendaemmerung) from 1990 existed only as an executable [binary file](https://github.com/s-macke/weltendaemmerung/blob/main/disassembly/archive/xxd.txt), meaning pure machine code. Claude Code was able to disassemble the file, reverse engineer it, produce a specification of the game for me, and then [port the game](https://s-macke.github.io/weltendaemmerung/) to the web. In total, that was three days of work for me. Without the agent, I would have needed one to two months.

It is hard to put this behavior into words if you have so far only chatted with models that practically do not need any agent capabilities. You have to experience it yourself. On your own problems. And over weeks. In the classic sense, I barely coded at all anymore. Instead, I guided, directed, had specifications written, and improved them iteratively.

# The slow burn of recognition

In the community, too, it took weeks before this assessment was more widely shared. One reason: practically no benchmark captured these properties properly.

An Anthropic developer, Rohan Anil, [wrote](https://x.com/_arohan_/status/2007516555962200315) for example:


> For full disclosure! I work at Anthropic making Claude better now, and if you follow my feed, I have been truly impressed by Claude Code. I understand building these models at the atomic level and the nuts-and-bolts level—aka the core components—but that would not have led me to predict this progress. I’m truly mesmerized by what we have summoned by putting all these pieces together.

And Andrej Karpathy, the person who coined the viral sentence in 2023, wrote in an rather [panicked tone](https://x.com/karpathy/status/2004607146781278521):

> I've never felt this much behind as a programmer. The profession is being dramatically refactored as the bits contributed by the programmer are increasingly sparse and between. I have a sense that I could be 10X more powerful if I just properly string together what has become available over the last ~year and a failure to claim the boost feels decidedly like skill issue.

He ended with:

> Clearly some powerful alien tool was handed around except it comes with no manual and everyone has to figure out how to hold it and operate it, while the resulting magnitude 9 earthquake is rocking the profession. Roll up your sleeves to not fall behind.

The fear is not unfounded. What used to be a largely closed system (code, specifications, tests, deployment) has now gained a probabilistic coprocessor. And we are all learning at the same time how to think together with it. No manual, no stable abstractions. Just raw power, plus plenty of sharp edges.

This new layer rewards neither memorization nor pure coding speed. It rewards systems thinking: how you break down work, how clearly you formulate intent, how you constrain and check something that can hallucinate, and how you build feedback loops so the tool corrects itself faster than you could.

The good news: it is still engineering. The same instincts apply: isolate error patterns, make behavior visible, set guardrails, keep the blast radius small, and automate verification. This is a different form of intelligence. Closer to leadership and control than to hands-on execution.

# Working with Amnesia

It is still unclear what future work with agents will look like in detail. That is why any statement about it inevitably has to make assumptions. Many discussions start from one main premise: that we will remain limited by a context window.

As a consequence, you have to imagine working with agents like working with a developer whose job at your company lasts only about 30 to 60 minutes before you fire them and hire a new one. Or like a person with constant amnesia who cannot form new memories and therefore keeps taking notes to maintain an overview.

The limitations are obvious. And they are limitations that future models will probably have as well. Unless the problem of LLM memory or continual learning is solved in a better way. When that will happen, nobody currently knows. Anthropic researchers themselves [like to emphasize](https://www.youtube.com/watch?v=TOsNrV3bXtQ&t=5s) that this is only a temporary limitation.

At the moment, context windows are roughly around 150,000 words, meaning about 500 pages of text. That sounds like a lot. But it gets used up faster than you would think once an agent processes large blocks of code.

Managing the context will therefore make up a non-trivial part of engineering work. Fundamental principles of software engineering act like a force multiplier here.

* If you have a good architecture with many independent modules and clear interfaces, the AI does not need to know all the details.
* If you have tests, the AI can run them after every change and correct itself.
* If you have a good code review process, you catch problems in AI-generated code early.
* If you have solid documentation, the AI understands your codebase much better and produces better code.

# Documentation Is Now a First-Class Citizen

Especially the last point could become decisive. Code is something like an over-specification: it contains far too many unimportant details. Often you only want to know what the code does, not how it does it. To take pressure off the context window, it will therefore be crucial which information the agent actually needs to read in order to complete a task.

Nobody yet knows what the right structure for documentation will look like. Where can you explain an entire concept in a single sentence? And when do you have to go into so much detail that even pseudocode belongs in the specification? These questions have occupied us developers since the beginnings of software development. The difference today is that the usefulness of documentation can now be measured.

The goal is to maximize the agent’s efficiency. So we do not have to speculate: for example, we can have the agent generate code from a specification. If the result is wrong, we adjust the documentation together with the agent and generate the code again. The fact that this documentation should also be optimally understandable for us humans is a welcome side effect.

The new documentation will likely receive equal, perhaps even higher priority than the code we have today. The long-term target picture is clear: in theory, it should be possible to rebuild a piece of software based solely on the documentation. That brings us back to Karpathy’s statement from 2023.

# The Agentic Tipping Point

But maybe I am completely wrong. The tools change weekly. Mental models age quickly. “Best practices” flip within months. There is no manual yet because the system is evolving while it is being used. You are learning to steer a machine that is simultaneously learning how it should respond to you.

As the first professional group, we have the privilege of working with AI agents that truly deserve the name. And that means we are also the first to bear the responsibility of turning their strength into real reliability. Those who learn to lead agents now are primarily learning three things: specify cleanly, verify relentlessly, and orchestrate intelligently. Whoever learns that will set standards for everyone who follows.

