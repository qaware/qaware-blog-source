---
title: "Software Circus"
date: 2017-09-18T15:06:32+02:00
draft: false
author: Felix Obenauer
image: blue.png
tags: [Conference, Machine Learning, AI, Software Architecture, DevOps]
aliases:
    - /posts/2017-09-18-software-circus/
summary: The most interesting topics we experienced during this year's Software Circus include AI/ Machine Learning, Software Architecture, DevOps.

---
## Intro
We just came home from two days of talks, workshops and lots of fun during this year's Software Circus. "Cloudbusting" was the theme this year and it took place in the lovely city of Amsterdam. The organization team did a great job finding a unique venue: A festival location including a Big Top circus tent, a rusty hangar and a large outdoor area is not quite the setting you expect from a software conference!

Not your standard conference at all, the Circus provided some relaxed, fun and joyful atmosphere for learning new stuff, meeting new people and chatting to old friends of the cloud native community. The conference was embedded into a futuristic story arch that was moved forward by several great performances of actors, singers and dancers in between talks and sessions. Loud music, great food and Dutch beer rounded out the experience.

Maybe - just maybe, but don't tell our boss - especially the first day was a bit heavy on the show and too light on the content side. We did, however, get to talk tech, as there were several tracks throughout the day. If anything, we would wish for more talks and hands-on sessions during the next year's event!

The second day was reserved for workshops and some deep-dive sessions. Heavy rain and wet feet couldn't stop us from being there, not like many of the other attendants.

The following sections cover the most interesting topics and talks that we experienced this year.


## Machine Learning/AI
One big topic at the Software Circus 2017 was Artificial Intelligence (AI), especially Machine Learning (ML).

In a practical part Google gave an intro into Tensorflow. It’s an Open Source library for AI and ML, that is developed by Google’s Brain Team. It performs operations on multidimensional arrays, so called tensors. As Google uses it for it’s search ranking, Tensorflow is worth a closer look.

In a theoretical talk Thiago de Faria spoke about ML, AI and DevOps. He introduced the history of AI and ML which goes back to the late 50’s and 60’s, where the first algorithms occurred. In the 90’s support vector machines mark another big step until 1997 IBM’s Deep Blue beat the World Champion at chess. Nowadays IBM’s Watson is one of the most famous AI / ML projects.

As Thiago is an ML practitioner he pointed out some very important questions concerning DevOps in AI and ML systems which still remain unanswered. A normal program is tested automatically in the context of Continuous Integration (CI). But how can you apply CI to AI and ML systems? Can you create automated tests for such a system? As even the smallest change in an AI has unpredictable effects and might break completely disjoint features, this is a very important point. Furthermore, a normal program is debuggable. You can set breakpoints and follow the program execution. But how can you debug AI and ML systems as there exists no traditional program flow? He hopes that those questions might be answered as AI and ML become more and more explainable.

At last he expressed his concerns and fears regarding ML. On the one hand existing biases might propagate into a system’s learned behavior and influence its decisions, on the other hand people might tend to delegate decisions to algorithms as they are too afraid to decide for themselves. Only time will reveal if his concerns were unfounded.


## Software Architecture 
With many buzzwords flying around, it is sometimes forgotten that certain topics never loose their relevance. Independent technology consultant Simon Brown delivered an inspiring (re-) imagination of the modern Software Architect. He debunks the notion that a capable architect is only doing the up-front specification work (the seagull approach), and is an avid proponent of a hands-on approach to software architecture. An architect needs to have people skills as much as technological expertise and is an essential building block for well-performing dev teams.

Simon also advocates the use of modelling tools to support development. This does not mean UML necessarily, he introduced his own creation as an alternative: The C4 model for software architecture is a lightweight alternative to get started with a better architectural documentation.


## DevOps
Improving the software delivery process is still a key concern today and it was an important topic at the Software Circus as well. Often summarized under the 'DevOps' term, speakers and workshop organizers examined the matter from different perspectives, sharing success stories and cautionary tales. Maarten Dirkse of dutch online bookstore bol.com gave a workshop on doing continuous delivery - including automating canary deployments - using Gitlab-CI and Spinnaker.

DevOps is not about a particular technology, it is about culture and collaboration. This is the primary takeaway from Kris Buytaerts emotional talk in which he explained how "Docker Is Killing DevOps Efforts". He uses the Anti-Pattern of the "Enterprise Container", which contain an entire application-stack from Message-Queue to Database. By that he shows that simply adopting a particular technology does not solve the delivery problems and reminds everyone of the core values of the DevOps movement: culture, automation, measurement and sharing (CAMS).

DevOps principals are not only important in application development, as "DataOps" practitioner Thiago de Faria explained. With increasing importance, machine learning and AI projects need to think about their own delivery pipelines to tackle lock-in, onboarding and delivery problems.

![](/images/bigtop.png)

Dealing with Legacy Applications 
Even if this year's Software Circus was using the theme "Cloudbusting", there was some good news for those of us dealing with monolithic legacy applications: David Pilato from Elastic Search demonstrated how legacy applications can easily adopt the Elastic stack with incredibly small effort (see [github.com/dadoonet/legacy-search](http://github.com/dadoonet/legacy-search)). Twelve brave attendants watched this morning's first demo on adopting Elastic Search, all of us defying rain, wind, cold and noise from trains and ice carving...

The new 6.0.0-beta version contains some really cool features: the now build-in client for Elastic's API can be integrated in your JAVA applications quite easily, comes with convenient query builders, and grants out-of-the-box access to the following features:

* Bulk processing for high performance index operations
* Custom analyzers for easy index token definitions
* Easy data aggregations for your application specific needs
* Fuzziness factor for typo tolerance
* Easy Kibana integration


Good to know that Elastic Search cannot be used for time series only. Can't wait to try it out in our applications!


## Conclusion
The Software Circus is worth a visit, especially if you tire a bit of the conventional conference setting. It is a community event in the truest sense, bringing the people together and creating a comfortable backdrop for talks and sessions. If you come for the conversations and the spirit, you will be delighted. If you are only in for the content, then you may leave longing for some more - even though the Circus had lots to offer in that regards as well!