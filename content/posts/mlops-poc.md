---
title: "Automating an Machine Learning Pipeline with MLOps"
date: 2024-02-02T14:46:18+01:00
author: "Victor, Lars, Simon & Martin"
type: "post"
image: "mlops-poc/pipeline.png"
tags: [MLOps, AI, Machine Learning, Kubeflow]
draft: true
summary: In diesem Artikel zeigen wir euch unser Konzept eines MLOps Blueprints der QAware.
---

# Was ist MLOps überhaupt?
MLOps (Machine Learning Operations) ist ein Paradigma, das darauf abzielt, Machine Learning Modelle zuverlässig und effizient zu implementieren und zu warten. MLOps unterscheidet sich vom klassischen DevOps insbesondere dadurch, dass es die Integration von  Modellen und Daten im Entwicklungsprozess, sowie Betrieb umfasst.
Eine Herausforderung besteht darin, dass diese Daten und Modelle sehr groß sein können, was die aktive Entwicklung und Wartung dieser Systeme erschwert. Im besten Fall orchestriert MLOps nicht nur das Management von Big Data und komplexen Modellen, sondern erleichtert auch die Zusammenarbeit zwischen Data Scientists, Entwicklern und Operations Engineers.


# Kontext
Mehr als je zuvor spürt man den Einfluss von KI in der heutigen Gesellschaft. Auch in der Projektwelt gibt es derzeit zahlreiche KI-Projekte oder Projekte, die durch KI optimiert werden können. Sei es in der Gesichtserkennung, Produktempfehlung, Anomalie-Erkennung oder Chatbots. Deswegen haben wir im Rahmen unserer KI-Gilde einen Blueprint entworfen, der KI optimal in die Softwareentwicklung integriert..

Neben dem Aufbau von Wissen zu diesem Themengebiet wählten wir einen praktischen Ansatz und setzten uns zum Ziel, ein einfaches ML-Problem mittels der typischen MLOps Techniken anzugehen und in einem PoC festzuhalten. Vor allem war uns wichtig, die Pipeline selbst gestalten zu können und sie in einer von uns gemanagten Cloud zu betreiben.

Dabei kam nun direkt die erste Frage auf: Mit welchen Technologien wollen wir diese Pipeline denn überhaupt bauen und deployen? Nach kurzem googeln fanden wir schnell zahlreiche Lösungen, die einen einfachen Einsatz von MLOps mit einem hohen Maß an Anpassbarkeit an Cloud- und Projektbedingungen versprachen. Also folgten wir einfach mal diesen Ansätzen und testeten verschiedene Frameworks aus. Leider mussten wir dann schnell feststellen, dass wir Opfer von viel zu hohen Versprechungen geworden sind. Die Lösungen waren zum Teil technisch viel zu unreif oder eben doch nicht so flexibel einsetzbar wie erhofft.
ZenML war ein typisches Beispiel dafür. Lokal konnten wir recht schnell eine Pipeline aufsetzen, die unser Problem lösen konnte. Die großen Probleme kamen dann allerdings beim Versuch, diese Pipeline in der Cloud zu betreiben. Die anscheinend einfache Deployment Funktionalität führte zu zahlreichen Fehlern, bei denen wir nach einigen Fix-Versuchen und Einstellen von Issues auf GitHub auch nicht weiter kamen, bis wir das Projekt wieder beiseite legten.
Einen weiteren Versuch machten wir mit TFX. TFX ist ein TensorFlow Execution Framework, welches auf Kubeflow Pipelines aufbaut. Diese Lösung funktioniert ähnlich zu Kubeflow Pipelines und packt nochmals einen Abstraktionslayer obendrauf. Damit konnten wir Pipelines in der Cloud deployen. Der Mehrwert im Vergleich zu Kubeflow Pipelines allerdings war uns zu gering.

Damit kamen wir unserer Entscheidung jedoch schon einen Schritt näher. Also warum nicht einfach direkt Kubeflow Pipelines einsetzen? Mittels Kubeflow Pipelines lassen sich eigene Pipelines recht einfach definieren und direkt auf einem Kubeflow Cluster deployen. Kubeflow selbst setzt direkt auf den Kubernetes Stack auf und läuft deshalb Cloud agnostisch. Für diese Lösung brauchten wir zwar etwas mehr Anpassungen und Konfiguration, um die Komponenten zu verdrahten. Allerdings hatten wir dadurch auch direkten Einfluss auf die Funktionalität, wie wir sie für unsere Pipeline brauchten. Im Endeffekt begannen wir damals unser eigenes MLOps Framework/Blueprint basierend auf Kubeflow Pipelines aufzubauen. Nun haben wir die volle Kontrolle über die Funktionalität und können bei Problemen einfacher reagieren.

Damit machten wir uns auf den Weg, den geplanten PoC anzugehen.


# PoC

Um die Entscheidung für Kubeflow zu validieren, haben wir eine Proof of Concept (PoC) Pipeline entwickelt, um die Funktionsweise von Kubeflow im Detail kennenzulernen. Hierfür haben wir ein simples TensorFlow-Modell (Fashion MNIST) genutzt.

Für die Ausführung und das Deployment haben wir zwei alternative Varianten aufgebaut. Die eine Variante nutzt eine klassische Kubeflow-Instanz, welche wir in der Google Kubernetes Engine (GKE) laufen lassen, die andere nutzt Vertex AI. Vertex AI kann Kubeflow-Pipelines ausführen, mit wenig administrativen Overhead.

Die Vertex AI - Variante ist gut geeignet, wenn man schnell in die Feinheiten von Kubeflow einsteigen möchte, ohne sich um eine Kubeflow-Instanz kümmern zu müssen. Im Sinne der Unabhängigkeit von Cloud-Anbietern macht eine eigene Kubeflow-Instanz aber oftmals mehr Sinn.

Die Pipeline übernimmt vier Schritte:

### 1. Daten laden

Die Daten zum Trainieren und Evaluieren des Modells müssen zu Beginn bereitgestellt werden. In diesem Fall werden die Daten aus dem Keras Fahion-MNIST Datensatz geladen. Alternativ können sie aber auch aus CSV-Dateien, Datenbanken oder anderen Datenquellen geladen werden.

### 2. Modell trainieren

Das Modell wird trainiert. In diesem Fall wird zum Training TensorFlow genutzt. Die Funktionalität ist per Design jedoch so offen, dass jede Art von Modell trainiert werden kann. Die Pipeline legt das trainierte Modell in ein Google Cloud Bucket ab.

### 3. Evaluierung

Um die Korrektheit des Modells und die Qualität gegenüber vorherigen Versionen zu prüfen, werden in diesem Schritt Tests anhand der in Schritt 1 gesammelten Testdaten durchgeführt. Hieraus können Metriken, wie z. B. die Treffsicherheit erhoben werden. Wenn das Modell gewisse Mindestwerte unterschreitet, oder schlechter ist als das vorherige, kann es abgelehnt werden, damit das alte bereitgestellt bleibt.

### 4. Serving

Mithilfe eines Serving-Containers, welcher entweder vorgefertigt ist (z. B. der TensorFlow Serving Container) oder selbst erstellt werden kann, wird das Modell an einem Endpunkt bereitgestellt. Hierfür kann entweder Vertex AI Serving genutzt werden, oder der Container wird im bereits für Kubeflow genutzten GKE Cluster deployt.

Wir sind sehr zufrieden über die gebotenen Funktionalitäten. Ein fremdes Modell wurde, mittels unseres PoCs, in kürzester Zeit integriert. Kubeflow zeigt sich vielseitig und vernünftig einsetzbar. Die vier im PoC implementierten Schritte stellen das Minimum für unseren Use Case dar. Allerdings können problemlos weitere Schritte hinzugefügt werden.


# Ausblick
In unserem Bestreben, das ideale MLOps-Ökosystem zu realisieren, haben wir die Erkenntnisse aus unserem PoC genutzt, um weitere wesentliche Aspekte zu berücksichtigen. Ein kritischer Punkt ist, dass unser aktueller PoC stark von Google Cloud Komponenten abhängt. Daher planen wir die Entwicklung eines universellen Blueprints, der nicht nur cloud-agnostisch und anbieterunabhängig ist, sondern auch einfach in der Konfiguration und Integration. Das Schaubild bietet einen Überblick über die geplanten Komponenten des Blueprints.

![](/images/mlops-poc/blueprint_structure.png)
*Unser MLOps Blueprint Cloud Stack*

Wir beabsichtigen, unseren PoC durch Observability-Komponenten zu erweitern, wobei ein Prometheus-Grafana-Stack zum Einsatz kommen soll. Evidently AI könnte ebenfalls zur Erfassung ML-spezifischer Metriken verwendet werden. Im Bereich des Continuous Delivery streben wir auch eine Verbesserung an, um eine stärkere Ausrichtung auf GitOps zu erreichen. Das könnte durch die Implementierung von Flux geschehen. Zudem planen wir, unseren aktuellen Serving Container durch ein Serving Framework zu stützen. Hier käme BentoML infrage. Im Datensegment möchten wir mehrere konfigurierbare Datenquellen integrieren. Obwohl der Modellaspekt größtenteils durch unseren PoC abgedeckt ist, sehen wir Potenzial für eine Optimierung durch den Einsatz einer effizienten Modell Registry wie MLflow.

Als Fundament für unseren gesamten MLOps-Stack haben wir uns für Kubeflow entschieden. Dies begründet sich durch dessen Kubernetes-Native Eigenschaften, die eine gewisse Unabhängigkeit von Anbietern  gewährleistet, sowie durch die positiven Erfahrungen, die wir bereits in unserem PoC mit Kubeflow gemacht haben

Unser nächstes Ziel ist die Implementierung dieses universellen Blueprints. Damit soll es möglich werden, die vielfältigsten ML Use Cases durch einfache Konfigurationen zu unterstützen. Dies ebnet den Weg für den produktiven Einsatz von ML-Systemen bei QAware, indem es eine flexible und robuste Basis für verschiedene Anwendungen bietet.
