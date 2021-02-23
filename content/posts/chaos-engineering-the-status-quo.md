---
title: "The status quo of Chaos Engineering"
date: 2021-02-18
draft: true
author: "[Josef Fuchshuber](https://www.linkedin.com/in/fuchshuber)"
tags: ["Diagnosibility", "DevOps", "Observability", "Chaos Engineering", "Testing", "Quality"]
summary: This article shows you the current status of Chaos Engineering rituals, procedures and tooling in the Cloud Native ecosystem.
---

This article shows you the current status of Chaos Engineering rituals, procedures and tooling in the Cloud Native ecosystem. The most important thing up front. Chaos engineering does not mean creating chaos, it means preventing chaos in IT operations.

> Chaos Engineering is the discipline of experimenting on a system in order to build confidence in the system’s capability to withstand turbulent conditions in production. [^1]

## Where can Chaos Engineering help us?

Cloud native software solutions have many advantages. However, there is always one negative point: the execution complexity of the platforms and our micro service components increases. Our architectures are made up of many building blocks in the runtime view. With Chaos Engineering (mindset & process) and Chaos Testing (tooling) we can get a grip on this challenge and build trust in our complex applications. With Chaos Engineering (Mindset & Procedure) and Chaos Testing (Tooling) we can get a grip on this challenge and build more resilient applications and achieve trust in our complex applications.

The human factor is almost more central in Chaos Engineering than our applications. As described above, it is very important that we know the behavior of our cloud native architectures and thus build trust. The second aspect are our ops processes. Is our monitoring and alerting working? Do all on-call colleagues have the knowledge to analyze and fix problems quickly?

{{< figure figcaption="Chaos Engineering Levels" >}}
  {{< img src="/images/chaos-engineering/chaos-engineering-levels.png" alt="Chaos Engineering Levels" >}}
{{< /figure >}}

Beim Chaos Engineering kann das Was wird getestet in vier Kategorien eingeteilt werden:

* **Infrastructure:** Hierbei geht es um unsre virtuelle Infrastruktur bei unseren Cloud Providern. Wir können Testen, ob unser Infrastructuer-as-Code Tooling alles korrekt angelegt hat und ob z.B. die High-Availability VPN Verbindung ins eigene Datacenter wirklich hochferfügbar und ausfallsicher ist.
* **Platform:** In der nächsten Ebene kommen unsere Plattformkomponenten ins Spiel - Kubernetes, DevOps Deployment Tooling, Observability Tooling. Beispiele für Fragen, die Test auf dieser Ebene beantworten können sind: Funktoniert die Selbsteheilung ein Node-Pools falls ein Node ausfällt? Was passiert, wenn die zentrale Container Registry ausfällt und im Cluster neue Pods gestartet werden müssen?
* **Application:** Auf diesem Level wird das Verhalten unserer Anwendungen im Zusammenspiel der Microservices untereinander und mit den Plattformkomponenten getestet: Stimmt das Exception Handling? Sind alle Circuit Breaker und Connection Pools mit ihren Timeouts und Retries korrekt konfiguriert? Wir ein (Teil-)Ausfall eines Service an den Healthchecks korrekt und schnell genug erkannt?
* **People, Ptractices & Process:** In diesem Level geht es weniger um Tooling, sondern um die Menschen im Team. Stimmen in einem Notfall die Kommunikationswege und werden die richtigen Menschen zur richtigen Zeit informiert? Haben die Kollegen alle relevanten Permissions um Analysen und Fehlerbehebungen durchführen zu können? Haben sie das Know-How um die MTTR[^2] nicht zu gefährden.

Fasst man die Ebenen und ihre Fragestellugen zusammen, so kann man als Team bei diesen Aufgaben mit Chaos Engineering starten:

* Battle Test für neue Infrastruktur und Services
* Quality Review: Kontinuierlich die Robustheit von Anwendungen verbessern
* Post Mortem: Reproduktion von Ausfällen
* On-Call Training

Der leichtgewichtigste Start von Chaos Engineering sind Game Days. Am Game Day führt das komplette Team (Dev, Ops, QA, Product Owner, ...) Experimente aus. Dabei steht das Tooling zuerst im Hintergrund. In erster Linie geht es darum, dass das gesamte Team das Chaos Engineering Mindeset verinnerlicht und dabei Anomalien entdeckt und behoben werden.

## How to start?

> Chaos Engineering without observability … is just chaos [^3]

{{< figure figcaption="With open eyes into the disaster." >}}
  {{< img src="/images/chaos-engineering/this-is-fine.jpg" alt="With open eyes into the .disaster" >}}
{{< /figure >}}

Jeder kennt dieses Meme und niemand sollte so ignorant sein, wie unser kleiner Freund aus dem Comic. Man kann Dinge bewusst ignoriren oder man kann sie erst gar nicht ignoriren, weil man sie nicht sieht. Genau das passiert, wenn wir kein ausreichendes Monitoring für unseren Anwendungs- und Plattformkomponten haben. Aus End-To-End sicht bietet die RED Methode [^4] z.B. eine gute Sicht auf den Zustand einer Microservice Architektur. Kümmert euch also zuerst um euer Monitoring.

Die häufigste Frage am Anfang ist: In welcher Umgebung führe ich meine ersten Tests auf? Am Anfang sollte man immer in der Umgebung arbeiten, die der Produktion am nächsten ist (keine Mocks, möglichst identische Cloud Infrastruktur), aber nicht die Produktion. Aber: Choas Engineering Experimente in Produktion sind das Ziel sein, dann nur dort findet ihr die Realität. Wenn ihr in einer Testumgebung startet, muss euch bewust sein, dass ihr keine echte Kundenlast während eurer Experimente habt. Ihr braucht Lastgeneratoren oder Akzeptanztests, über die ihr prüfen könnt, ob euer System so reagiert wie wir annehmt. Falls es diese noch nicht gibt, müsst ihr diese vor dem ersten Experiemnt bauen. Keine Angst, manchmal reicht auch schon ein kleine Shell-Skript oder auch Chaos Testing Tooling bringt die Validierung gleich mit.

Nachdem wir jetzt eine Umgebung und Monitoring haben, können wir mit den ersten Experimenten starten. Dabei hilft uns dieses Bild:

{{< figure figcaption="The Phases of Chaos Engineering" >}}
  {{< img src="/images/chaos-engineering/chaos-experiment-phases.png" alt="The Phases of Chaos Engineering" >}}
{{< /figure >}}

Die Phasen des Chaos Engineerings können als zyklischen Prozess dargetellt werden. Ein Zyklus startet und endet im _Steady State_.

* **Steady State:** Der wichtigste Status des Chaos-Engineerings. Denn dieser beschreibt das Verhalten des Systems unter normalen Bedingungen. 
* **Hypothesis:** In dieser Phase stellen wir eine Hypothese auf. Wir designen also unser Experiment indem wir eine Action ausführen (z.B. den Ausfall einer Datenbank) und das erwartete Ergebnis beschreiben (z.B. Fehlerseite in der Web-UI wird angezeigt, HTTP-Status 200 und nicht 500).
* **Run Experiment:** Wir führen die definierte Aktion aus. In einem Game Day kann man dies manuell (z.B. CLI Tooling der Cloudprovider, `kubectl`) oder automatisiert über ein geeignetes Chaos Test Tooling.
* **Verify:** In dieser Phase validieren wir, ob das erwartete Ergebnis eingetreten ist. Dazu gehört das Verhalten der Anwendung, aber auch das gemessene Verhalten in unseren Monitoring- und Alarmierungstools.
* **Analyze and Improve:** Falls das erwartete Ergebnis nicht engetreten ist, analysieren wir die Ursache und beheben diese.

Nach einem erfolgreichen Test muss das System wieder im *Steady State* sein. Das ist entweder der Fall, wenn die ausgeführte Aktion den Steady State nicht ändert (z.B. Das Cluster erkennt eine Anomalie automatisch und kann sich selbst heilen) oder ein Rollback durchgeführt wird (z.B. Datenbank wird wieder hochgefahren).

Beim Design und Ausführung des Experiments ist eines der wichtigsten Dinge immer den potenziellen Blast Radius, also die Auswirkung des Fehlers, so minimal wie möglich zu halten und ständig zu beobachten. Dabei ist hilfreich, dass man sich im Vorfeld überlegt, wie das Experimten im Notfall abgebrochen werden kann und die der *Steady State* möglichst schnell wieder hergestellt werden kann. Anwendungen, die ein Canary Deployment unterstützten, sind hierbei klar im Vorteil. Denn hierbei kann der User-Strom detailiert auf das Experiment oder die normale Version der Anwendung gelenkt werden.

Jedes Chaos Engineering Experiment erfodert eine detailierte Planung und muss in irgendeiner Form dokumentiert werden. Beispiel:

|              |  |
|--------------|-------|
| Target       | Billing Service  |
| Experiment   | Schnittstelle zu Paypal steht nicht zu Verfügung |
| Hypothesis   | Die Anwendung erkennt den Ausfall automatisch und bietet unseren Kunden die Bezahlart nicht mehr an. Die Kunden können nur noch per Kreditkarte oder Vorkasse bezahlen. Das Monitoring erkennt den Ausfall und erstellt automatisch einen Prio-1 Incident |
| Steady State | Alle Arten der Bezahlung stehen für die Kunden zur Verfügung |
| Blast Radius | Während dem Experiment steht den Kunden die Bezahlung per Paypal nicht zur Vefügung. Die alternativen Bezahlungswege sind davon nicht beeinträchtigt. |

Tipp zum Design von Experimenten und Hypthesen: Stellt keine Hypothese auf, von der ihr im Vorfeld schon wisst, dass sie euere Anwendung kaputt macht und somit nicht hatbar ist! Diese Probleme, falls sie wichtig sind, könnt ihr gleich in Angriff nehmen und beheben. Stellt nur Hypothesen über eure Anwendungen auf, von denen ihr glaubt, dass sie belastbar sind. Denn das ist der Sinn eines Experiments.

## Chaos Engineering Tooling

Im Tooling für Chaos Tests ist im Moment viel Bewebung. Es kommen ständig neue OpenSource und komerzielle Produkte hinzu. Eine aktuelle Übersicht über den Markt bietet uns die Cloud Native Landscape der CNCF. Hier gibt es inzwischen eine eigene Chaos Engineering Kategorie [^5].

{{< figure figcaption="Chaos Engineering Tools @ CNCF Landscape" >}}
  {{< img src="/images/chaos-engineering/chaos-engineering-cncf-landscape.png" alt="Chaos Engineering Tools @ CNCF Landscape" >}}
{{< /figure >}}

Die Eigenschaften der Chaos Engineering Tools sind vielfältig:

* **API oder Operator basierend:** Verwendet das Tool nur die öffentlichen APIs von Cloud Providern oder Kubernetes oder müssen im Cluster invasive Agents / Operatoren installiert werden (z.B. als Sidecars).
* **Support des Chaos Engineering Levels:** Nicht alle Tools unterstützen alle Levels. AWS und Kubernetes wird von vielen Tools unterstützt. Cloud Provider oder Plattformen mit weniger Marktdurchdringung sind oft Second-Class-Citizen.
* **Zufallsbasiert oder experimentbasiert:** Bei Tools die nach dem Zufallsprinzip agieren, lässt sich der Blast Radius viel schwerer abschätzen und auch die vergleichbare Wiederholung in CI/CD-Pipelines ist schwierig. Dafür bringen diese Tools eventuell unbekannte Fehlerquellen zu Tage.

Es gibt momentan leider keinen "One-Stop-Shop", der alle Teams glücklich macht. Jedes Team muss sich also Gedanken über die eigenen Anforderungen machen und ein oder mehrere Werkzeuge aussuchen.

## Summary

Chaos Engineering ist keine Jobbeschreibung, sondern eine Mindset und Vorgehen, das das komplette Team betrifft.  Das wichtigste am Chaos Engineering ist, dass man es macht:

* Regelmäßige Game Days im gesamten Team sollten zum festen Ritual werden.
* Startet in einer produktionsnahen Umgebung und prüft zuerst ob euer Monitoring ausreichend ist.

Werkzeuge kommen und gehen:

* Die Chaos Engineering Werkzeuge im Cloud Native Ökosystem entwickeln sich weiter.
* Der Kontext eurer Chaos Engineering Experimente wird sich erweitern.

Damit ihr einen besseren Einblick in die Chaos Engineering Werkzeuge bekommt, stellen wir euch ein paar vor. Wir staten mit [Chaos Toolkit]({{< relref "/posts/chaos-engineering-chaostoolkit.md" >}})


## ContainerConf 2021 Presentation

{{< slides key="KZzazUQd1hKSpS" id="der-status-quo-des-chaos-engineerings" title="Der Status Quo des Chaos Engineerings" >}}

[^1]: [Principles of Chaos Engineering](https://principlesofchaos.org/)
[^2]: [Mean time to recovery(MTTR)](https://en.wikipedia.org/wiki/Mean_time_to_recovery)
[^3]: [Charity Majors, @mipsytipsy CTO @ Honeycomb](https://de.slideshare.net/CharityMajors/chaos-engineering-without-observability-is-just-chaos)
[^4]: [The RED Method: key metrics for microservices architecture](https://www.weave.works/blog/the-red-method-key-metrics-for-microservices-architecture/)
[^5]: [Choas Engineering Category in CNCF Cloud Native Landscape](https://landscape.cncf.io/card-mode?category=chaos-engineering&grouping=category)
