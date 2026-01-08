---
title: "The Creative Director of Code - Orchestrating Agents, Not Writing Lines"
date: 2025-01-02T18:00:00+01:00
author: "Sebastian Macke"
type: "post"
image: "TODO"
categories: []
tags: [AI agents, Coding Agents, Software abstraction, Developer productivity]
draft: true
summary: Programming is shifting from writing code to directing agents in English, where the key skill is managing uncertainty
---

There aren’t many developers anymore who still need to understand what the compiler of a programming language actually does, let alone how the generated assembly code works in detail or what the circuits on the chip have to look like to execute that code. Instead, we now develop on a high level of abstraction with machines.

These layers of abstraction have emerged over the last hundred years and have led to a massive increase in developer productivity. A factor of one hundred per evolutionary step would probably still be an understatement.

But all abstraction layers had one thing in common. It’s unnecessary to understand the internal concepts. You only need to know how to apply them. The results are stable and absolutely reproducible. Only very few developers still seriously think about assembly. Often they wouldn’t even have to know what it is, and they would still be good developers. 

The leverage instead is writing more correct instructions faster than others. Skill means internalizing abstractions, mastering tools, and directly shaping deterministic systems. Output grows essentially linearly with effort and experience. 

That era is now coming to an end.

## The New Programming Language Will Be English

Andrej Karpathy already expressed it in a viral post on X back in 2023, a line that has been quoted almost daily ever since.

> The hottest new programming language is English

If you take that sentence seriously, what we currently call “a programming language” is simply pushed one abstraction layer deeper, just like what happened with assembly. It becomes a compile target, software on demand. In this world, existing code becomes irrelevant, generated at a speed far beyond what we can still read, understand, or maintain. Instead, we shift toward specifications, system prompts and feedback loops with agents. People who write code by hand will seem just as absurd as people who write assembly by hand seem today.

## When Coding Agents Crossed a Threshold

At the end of November, Anthropic released the next update to its coding agents with Opus 4.5, clearly crossing a new threshold. This genuinely feels like something new. In short, this is no longer “pretty good.” This is a turning point.

Not in terms of knowledge, that was already phenomenally good before, but in the agent’s ability to act independently, make decisions, and solve problems together with me. It asks follow up questions, writes plans, and then actually executes them. It behaves proactively and reactively, and it has a capacity for self reflection.

It’s hard to put this behavior into words if you’ve only ever chatted with models on websites that barely require any agent capabilities. You have to experience it yourself on your own problems, and over days or weeks.

Every coding problem I was able to define clearly enough within the limits of the context window, the chatbot could solve and these weren’t easy. This included not just writing and testing code, but also reverse engineering and cracking encoding problems. The most impressive part was active work on problems in a tight feedback loop. Sometimes it no longer feels like an AI, it feels like a coworker.

In the classic sense, I haven’t really coded in the last few weeks. Instead, I’ve been guiding and directing, having it write specifications, and then improving those specifications.


## The slow burn of recognition

Even in the community, it took weeks before this assessment became more widely shared, partly because practically no benchmark captured these properties properly.

An Anthropic developer, Rohan Anil, wrote for example:

> For full disclosure! I work at Anthropic making Claude better now, and if you follow my feed, I have been truly impressed by Claude Code. I understand building these models at the atomic level and the nuts-and-bolts level—aka the core components—but that would not have led me to predict this progress. I’m truly mesmerized by what we have summoned by putting all these pieces together.

And Andrej Karpathy, the person who coined the viral line above in 2023, wrote in a rather panicked tone:

> I've never felt this much behind as a programmer. The profession is being dramatically refactored as the bits contributed by the programmer are increasingly sparse and between. I have a sense that I could be 10X more powerful if I just properly string together what has become available over the last ~year and a failure to claim the boost feels decidedly like skill issue.

And he ended with:

> Clearly some powerful alien tool was handed around except it comes with no manual and everyone has to figure out how to hold it and operate it, while the resulting magnitude 9 earthquake is rocking the profession. Roll up your sleeves to not fall behind.

The fear isn’t coming out of nowhere. What used to be a largely closed system (code, specs, tests, deployment) has now gained a live, working, probabilistic coprocessor, and we’re all learning at the same time how to think alongside it. No manual, no stable abstractions, just raw power and plenty of sharp edges. The effort and the outcome are no longer cleanly correlated.

This new layer rewards neither memorization nor pure coding speed. It rewards systems thinking: how you break work down, how clearly you express intent outwardly, how you constrain and verify something that can hallucinate, and how you build feedback loops so the tool corrects itself faster than you could.

The crucial skill is not “using AI.” The crucial skill is managing uncertainty. That’s new, and so far nobody really has an experience advantage there. Often it’s two steps forward, one step back, and one step sideways.

With the same intellect, you can be ten times more effective if you know how to operate agents properly. Or you can grind endlessly and still fall behind if you cling to manual “write everything yourself” work.

## The Agentic Breakpoint

It’s early 2026, and if you look at the agents as they were in October and then in December and extrapolate, you can start to grasp how crazy 2026 could become.

The tools change monthly. Mental models go stale fast. “Best practices” flip within months. There is no manual, because the system keeps evolving while it’s being used. You’re learning to steer a machine that is simultaneously learning how it should respond to you. Right now, only a fraction of the software developer community understands how much stronger agents have become over the last months. That will change this year.

But programming is only the beginning. As the first profession, we have the privilege of working with AI agents that actually deserve the name. A large part of the thinking that used to sit between desire and outcome is disappearing. There is now a huge gap between what developers at the cutting edge are using and what the rest of the world is doing, which is still figuring out the most basic way to use ChatGPT.

The honest conclusion for me is that the nature of knowledge work is shifting fast. Opus 4.5 made that hard to ignore. In practical coding work, it can already do most of what I need.

At the moment, my advantage is that I can keep more than 200k tokens worth of details “in my head.”. But that likely won’t remain true for long. Anthropic researchers themselves like to emphasize that this is only a temporary limitation.

