---
title: "Impressions from SEACON 2018 - Part 2"
date: 2018-06-14T15:06:32+02:00
draft: false
author: "Harald Störrle"
tags: [Domain Driven Design, Conference]
aliases:
    - /posts/2018-06-14-seacon-2/
summary: I give you my impressions from a presentation on Domain Driven Design at the SEACON.
---
## "Domain Driven Design" and "Taylorism"

Henning Schwentner (wps solutions GmbH) presented the concepts behind Domain Driven Design (DDD, see sources[^2][^6][^8] for general references, and the slides of the talk[^7]). The general idea behind DDD is to structure applications vertically rather than horizontally into domains: Design small, self-contained portions of an application domain rather than attempt to get (only?) the big picture. It doesn’t stop there, though: The domain-structure ought to be established, says Schwentner, not just in the design (aka. models), but likewise in the architecture, code structure, organisation structure, and tooling (e.g. repositories). The “Design” in DDD refers to domain-level models (mostly conceptual, it appears) that constitute the ontology of a (sub-) domain and allow to define the boundaries ("Bounded Context") which are reflected in the interfaces at code level.

At first hearing, DDD reminds me a lot of the Role-Modeling approaches of the late 1990’s[^1][^3][^4] (then absorbed into UML), or the Business Objects from the early 1990’s[^5], or, even earlier, of the vision and promise of OO technology in general: closing the “semantic gap” between application and technology. Of course, DDD offers modern(ized) terminology, and there certainly is a lot of technical progress since the early days of OO, but the idea is not as new as it might seem… Still, it is a good idea, and it easily survives being renamed, rephrased, and repackaged (again). Maybe, this time around, we will finally see the convergence of application needs and technology opportunities.

Obviously, vertical structuring organisations is all the rage today. The main benefit is obviously the increased agility of small scale teams, hopefully not loosing the capability to tackle large scale problems, or maybe even upgrading organisational capabilities from solving complicated to solving complex problems, never mind wicked problems. Clearly, introducing proper modules into Java 9 is an important contribution towards this goal. And it makes perfect sense to me to bet on this one, even though “module” is not quite a brand new concept either…better late than never. I remain cautious, though, since vertical structures have downsides, too (ever heard the term “information silo”?). And I can’t see the reasons of having horizontal really going away for good (synergy, reuse, integration).

Having said that, I do like the idea of starting at an (elevated) level of abstraction. In my experience, this is difficult enough at the level of models, let alone code. What I find truly interesting, though, is the breadth and prominence that the social or organisational persepective has gained in IT conferences. A side topic in Schwentner's talk, it took center stage in a talk by Frank Düsterbeck. He spoke about leadership in learning organisations ("Taylor ist tot, es lebe der Mensch – Führung in der lernenden Organisation"; "Taylor is dead, long live the human - leadership in learning organisations"). He pointed out that there, in fact, are two types of problems:

* Complicated problems can be tackled by applying diligence, systematic procedure and delegation. Such problems can be solved by mechanical steps in the end.
* Complex problems, on the other hand, are by definition beyond what one person can grasp. Only self-organised teams can hope to conquer them.

Of course, in today's highly dynamic market places the latter abound. With the threat of disruption just around the corner, agility is key for thriving as an organisation. So, the call to take teams seriously, is perfectly plausible to me. Not many organisations have embraced this idea, and many more should. Düsterbeck's plea strikes me as somewhat shallow, though. As he points out himself, a tree has fewer edges than a (connected) graph. If every edge corresponds to a communication link, then the overhead for self-organised teams increases much stronger with increasing numbers than it does for hierarchical organisations (Brooks' Law: adding people to a late project makes it later). He observes that there are two types of communication:

* Steering communication: This is unavoidable, but it is also the smaller part and is thus not the key factor contributiong to communication overhead.
* Knowledge dissemination: This can, at least to some degree, be replaced by converting fluid and tacit knowledge into a more static form (aka. "documentation").


I am not sure, how much slack this distinction cuts a team. And what about those problems that are too big for one (small) team? DDD will answer: Create another subdomain and establish interfaces. However, the overall picture must be established, too, and "emergent interfaces" is boud to create friction, duplication and defects of every sort. Düsterbeck also highlights that the usual T-shaped profile in technology (broad coverage with deep, deep rooting in some place) is not enough. It must be complemented by the second dimension of domain-knowledge, again T-shaped. What is more, he wants a third dimension in this picture, the social dimension of individuals and teams (see figure below as taken from https://twitter.com/fduesterbeck). Indeed, the times of Taylorism are over.

![](DeVuV_JX4AAabcF.jpg)   

[^1]: Epstein, Pete, and Ravi Sandhu. "Towards a UML based approach to role engineering." Proc 4th ACM Ws. Role-based Access Control. ACM, 1999.

[^2]: Evans, Eric: “Domain-driven design: tackling complexity in the heart of software” Addison-Wesley, 2004.

[^3]: Halpin, Terry "Object-role modeling (ORM/NIAM)" Handbook on architectures of Information Systems. Springer, Berlin, Heidelberg, 1998. 81-103.

[^4]: Halpin, Terry, and Anthony Bloesch "Data modeling in UML and ORM: a comparison" Journal of Database Management (JDM) 10.4 (1999): 4-13.

[^5]: Sims, Oliver “Business objects: Delivering cooperative objects for client-server” McGraw-Hill, Inc., 1994.

[^6]: Schwentner, Henning: Domain Storytelling Website http://domainstorytelling.org/

[^7]: Schwentner, Henning: “Models, Modules, and Microservices” Speakerdeck.com/hschwentner

[^8]: Vernon, Vaughn: “Domain-driven design distilled” Addison-Wesley, 2016.

----

## Related posts

* [Impressions from SEACON 2018 - Part 1]({{< relref "/posts/seacon.md" >}})