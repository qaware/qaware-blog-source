---
title: "Building IoT 2018 - shaping the Internet of Things"
date: 2018-06-08T15:06:32+02:00
draft: false
author: "Moritz Kammerer"
tags: [SmartHome, IoT, Home Automation, Conference, Risk Assessment, Connected Cars, MQTT, Kubernetes, Vert.x, IOTA, Privacy by Design, SIMATIC S7, Security, UX Testing, Voice User Interfaces]
aliases:
    - /posts/2018-06-08-building-iot/
summary: I visited the building IoT at Cologne, Germany in June 2018. The following is a list of the talks I attended and found interesting.
---
I visited the building IoT at Cologne, Germany in June 2018. The following is a list of the talks I attended and found interesting. The building IoT is a small conference (180 attendees, 39 talks, 2 days + 1 day of workshops) from heise Developer and the dpunkt publisher. Its target audience are developers and architects who develop hard- and software for the Internet of Things (IoT). Most of the talks were given in German. You can find [some of the talks' videos on the building IoT homepage](https://www.buildingiot.de/videos.php).

## Keynote: Threat Modeling and Risk Assessments Against Connected Cars
Alissa Knight from Brier & Thorn gave an interesting talk about how threat modeling and risk assessment works. She presented multiple threat modeling frameworks and gave some anecdotes what she found in several years working as a penetration tester in the connected car industry. The talk was held in English.

## Reactive IoT with MQTT, Vert.x and Kubernetes
(original German title: Reaktives IoT mit MQTT, Vert.x und Kubernetes)
Jochen Mader from codecentric talked about the fallacies of distributed computing (you know that your network has latency, right?) and the reactive manifesto. He also talked, with funny self-painted slides, about the concept of back pressure and what can go wrong if you chose a framework without it. Jochen is a contributor to the Eclipse vert.x framework, which is a reactive, message driven framework for the JVM. It supports Java, but also every other JVM language, e.g. Scala, Kotlin or Groovy. In a live coding session, he created two small vert.x applications: a MQTT broker and a MQTT client. He then deployed those applications to a Kubernetes instance and demonstrated how vert.x, by magic, handles pod scaling.

## MQTT 5: New Features
(original German title: MQTT 5: Alle Änderungen und neuen Features)
Dominik Obermaier, CEO of dc-square, the company behind the MQTT broker HiveMQ, talked about the new features in MQTT 5. It now supports headers, negative acknowledgments, bidirectional disconnect messages and much more. He also explained why MQTT 5, which follows after MQTT 3.1.1, has not been named MQTT 4. At the end of the talk he announced [MQTTBee](https://github.com/mqtt-bee/mqtt-bee), a fully reactive MQTT client for the JVM which supports back pressure.

## MQTT in the Enterprise - How we successfully run an MQTT Messaging Broker
Despite the English title, Arnold Brechtoldt from Inovex gave the talk in German. He is running a MQTT broker (HiveMQ) with ca. 1.700 messages per second and 40.000 open sessions for a German car maker. The lessons learned are that you absolutely need dashboards which show metrics of the broker (they used Grafana in combination with Prometheus) and also a powerful log analytics (for that they used the ELK stack). The biggest problem when dealing with connected cars isn’t the technology in the car or in the cloud, but the GSM / LTE network. Having dashboards which show the incoming and outgoing messages from the broker allow the on-call team diagnose such issues quickly.

## IOTA – the Next Generation Blockchain?
(original German title: IOTA - die Next Generation Blockchain?)
That was my talk – the headline and the talk is in German, despite the English buzzwords. No need to die for blockchains :) I talked about the IOTA “blockchain”, which isn’t really a chain, but based on a DAG. I showed what problems blockchains solve (spoiler: few) and what problems they bring (spoiler: many). I talked about the basic building blocks for a blockchain, then proceeded to explain how the IOTA system works, what problem it solves and then some attacks on it. I spoke briefly about quantum computers and that they wreck traditional asymmetric crypto and what IOTA did to mitigate these risks. I summarized the pros and cons of the IOTA system and showed which future developments are in planning.
If you’re interested, you can find [the slides here](https://www.slideshare.net/QAware/iota-die-next-generation-blockchain).

## Want a bit more? Privacy by Design and Geolocation
(original German title: Darf es ein bisschen mehr sein? Privacy by Design und Geolokalisierung)
Torsten Jaeschke and Dominik Bial from Opitz Consulting talked about what happens if you don’t plan for privacy when designing a system and then GDPR happens. They had to refactor the whole data architecture to support anonymizing user data. Also, if you just delete user data, the analytics department is going to get angry because their statistics will be skewed. The punchline is: Talk to your customer at the start of the project about privacy, deletion concepts and also think about data warehouses, which store anonymized user data in aggregated format for analytics.

## Security in the High Bay Warehouse
(original German title: Security im Hochregallager)
Stefan Strobel, CEO of cirosec, and his colleague Max Bauert demonstrated how broken the industry controllers S7-300 and S7-1200 from Siemens are. They built a small warehouse using fischertechnik (something like Lego, but with more motors, gears, sensors etc.) and then proceeded to hack the system using Metasploit and ICSsplot (Industrial Exploitation Framework). If you have a S7 running somewhere, please don‘t connect it on the internet. The protocol is seriously broken and inherent unsafe.

## The Worst IoT Products - what we can learn to develop better Smart Products and Services
(original German title: Die schlechtesten IoT-Produkte - was wir lernen können, um bessere smarte Produkte und Services zu bauen)
Mirko Ross, CEO from digital worx, showed the top 10 of bad IoT products. From the Mirai botnet over hackable and breakable smart locks to connected pacemakers, from connected toys for children which spy on them to hacked Smart TVs. You won‘t believe which stupid mistakes have been made in those products. Sad thing is, you can still buy some of them.

## An IoT Project on its Way out into the World
(original German title: Ein IoT-Projekt auf dem Weg vom Schreibtisch in die weite Welt)
Thomas Eichstädt-Engelen worked as a contractor for a start-up which aims to clean the polluted air in cities with the aid of smart trees. A smart tree is a connected device, which uses plants to filter the air. The plants are watered by an automatic system and the air is circulated through the plants with big ventilators. He talked about how they manufactured these smart trees, selected the hardware components and wrote the software. Turns out, hardware engineering is a lot different from software engineering. You have to think about rusting contacts, short circuits, strong electric currents, thin wires, customer grade LTE modems which just break and so much more. On the software side, when entering industry grade hardware, it gets proprietary very fast. Funny and enlightening talk.

## Keynote: End of a Hype: The Internet of Things becomes Mainstream
(original German title: Keynote: Das Ende des Hypes: Das Internet der Dinge wird Mainstream)
Stefan Ferber, CEO of Bosch Software Innovations, talked about what it takes to transform a big mechanical engineering company to a company acting in the Internet of Things and having to deal with software. Now Bosch is a major contributor to various IoT frameworks, has a chair in the Eclipse Foundation and hosts one of the biggest IoT conferences and hackathons in Europe. Very impressive transformation.

## Hardware-based Security for IoT Products: simply (and) secure
(original German title: Hardware-basierte Sicherheit für IoT-Geräte: einfach (und) sicher)
Christian Lesjak from Infineon spoke about Hardware Security Modules (HSM), how they are built, and what they can do for an application. His showcase was an integration in an IoT product to store the device certificates in a hardware module. He then showed how to integrate this Infineon HSM into OpenSSL to authenticate the client to the server in a TLS handshake.

## Agile Software Development for Connected Cars
(original German title: Agile Softwareentwicklung für Connected Cars)
Dino Frese from thoughtworks talked about how difficult it is to develop frontend applications for connected cars. Latency is a big problem when the car is in China and the server is located in a data center in Germany. Cars also have different release cycles compared to a software, and hardware prototypes are only made available late in development. When the software is developed at the same time as the car hardware, they had to mock the complete car software. Also the middleware (backend in the data center of the car manufacture) has been developed from another department in the organization and the collaboration was suboptimal, to say the least. His punchline was: Mock everything, use consumer driven contracts to ensure the APIs are stable and, appealing to the car makers, please publish your car management APIs with a nice documentation.

## UX-Testing and Prototyping for Voice User Interfaces and Chatbots
(original German title: UX-Testing und Prototyping für Voice User Interfaces und Chatbots)
Richard Bretschneider from eresult spoke about prototyping when developing a voice user interface (VUI). He showed three ways how to create such a prototype: The first one are linear stories simulating a fixed path through the voice dialog. You must use a text-to-speech-engine to read the responses and to get a feeling on how they work. The second way needs two rooms: The test subject sits in one room, the the operator in the other one. The operator simulates the voice system and uses a text-to-speech-engine to respond to the user. The third way is to use a real voice system, like Google's [dialogflow](https://dialogflow.com/). This system allows, without programming, to create a prototype which can then be tested with Google Home. After these three ways he explained what makes a voice UX test different from other UX tests: The testers can’t give spoken hints to the test subject when they are stuck, as this interferes with the voice system. The test subject also can’t think aloud, which is a common thing to do in UX tests. The testers also need to phrase the exercise in the right way to not give too many hints on how to solve it. This was a very good talk and I definitely will take that into my team.
