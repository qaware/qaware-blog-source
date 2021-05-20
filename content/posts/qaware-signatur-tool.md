---
title: "Eine Produktreise: Das QAmail-Signatur-Tool"
date: 2021-05-20T13:50:02+02:00
lastmod: 2021-05-20T13:50:02+02:00
author: "[Susanna Suchan](https://github.com/susisonnenschein)"
type: "post"
image: "qaware-signatur-tool.png"
tags: ["Produktreise", "Confluence"]
draft: true
summary: Eine Produktreise: Das QAmail-Signatur-Tool generiert aus hinterlegten Confluence-Profil-Daten eine E-Mail-Signatur.
---

# Eine Produktreise: Das QAmail-Signatur-Tool

Das QAmail-Signatur-Tool generiert aus hinterlegten Confluence-Profil-Daten automatisch eine E-Mail-Signatur. In diesem Blog-Artikel möchte ich euch auf meine Reise von der Idee zum Endprodukt mitnehmen. Leinen los! 

### Ausgangssituation – 1001 Signaturen – „Sie müssen nur den Nippel durch die Lasche ziehn…“ 
Bisher hatte jeder seine E-Mail-Signatur je nach E-Mail-Client anhand von .txt und .htm Vorlagen selbst gebastelt. Das war nicht sonderlich intuitiv und dadurch umständlich. Was wiederum dazu führte, dass manche Signatur-Aktualisierungen hinauszögerten und andere die Vorlagen gar nicht mehr nutzten. So ergab sich eine erstaunliche Vielfalt unterschiedlicher Signaturen inklusive vereinzelter Tippfehler („Beste Arbeitgeber ITK 2002“, ist im Jahr 2020 leider nur halb so beeindruckend wie „Beste Arbeitgeber ITK 2020“), Zahlendrehern in Telefonnummern und übersehene, veraltete Links. Ein Kollege hatte die Idee, dass doch mal zu automatisieren. Ich fand die Idee super und wollte sie umsetzen. Es stellte sich nun die Frage, wie man so ein Tool am besten baut…

### Wie setze ich das um? Hip oder doch besser praktisch? 
Meine erste Idee: ein hippes Tool mit schicker UI, das seine Daten über eine Google-API bezieht. Ich habe mich also eingelesen und war schon Feuer und Flamme. Leider musste ich feststellen, dass zwar einige Angaben in unseren Google Kontakten gespeichert waren, aber andere Angaben (wie z. B. der genutzte QAware-Standort) dort fehlten. Blöd. Die Daten der Personal-Abteilung konnte ich aus datenschutzrechtlichen Gründen leider auch nicht nutzen. Schade. Woher also die Daten für die Signaturen bekommen? Es stellte sich heraus, dass die meisten benötigten Daten in Confluence hinterlegt sind (oder zumindest theoretisch hinterlegt sein sollten). Die neue Idee: ein Confluence-Makro. Das Tool ließe sich leicht in unser Confluence integrieren, wäre somit leicht zur Hand, ließe sich ohne weitere Freigabeprozesse nutzen und die nötigen Daten wären spätestens bei der zweiten Nutzung im persönlichen Confluence-Profil hinterlegt, was dann sogar nicht nur theoretisch, sondern auch praktisch gepflegt wäre. Ich entschied mich also schweren Herzens gegen ein hippes Google-Tool und für die praktischere Confluence-Alternative.

### Ran ans Werk – Die Tücken liegen immer woanders als gedacht
Ich habe mich also nochmal eingelesen. Diesmal wie man ein Confluence-Makro schreibt. Leider muss man Confluence-Admin sein, um ein neues Confluence-Makro erstellen und bearbeiten zu können. Ich habe mir daher ein eigenes Confluence hochgefahren und darin rumprobiert. Das Coden war leichter als erwartet. Ich habe unsere alte Vorlage verwendet und mit Hilfe der Confluence-API die Daten aus dem hinterlegten Confluence-Profil ausgelesen und eingesetzt. Da das Confluence-Profil keinen akademischen Titel beinhaltet, frage ich diesen am Anfang ab und beziehe ihn als Input-Parameter in mein Makro ein. Sprechende Fehlermeldungen weisen den Nutzer darauf hin, welche Daten ggf. in seinem Confluence-Profil zu ergänzen sind. Noch eine schöne Anleitung dazu und schon war meine Seite bereit für erste Testnutzer :)

### Feedback herzlich willkommen – Der Nutzer weiß am besten was er braucht & will
Ich bat also ein paar Kollegen das Tool zu testen und die hatten gute Ideen: Sie wünschten sich einen Kasten um die generierte Signatur und einen Copy-Button. Ihr Wunsch war mir Befehl.  
In der nächsten Iteration mit anderen Testnutzern stelle sich heraus, dass bei manchen Kombinationen aus Browser und E-Mail-Client, horizontale Trennlinien der Signatur verschwanden. Zauberei? Nach einiger Recherche stellte sich heraus, dass die Signatu-Vorlage in ihrer ursprünglichen Form einfach zu viele Freiheitsgrade ließ. Nachdem der Grund gefunden war, war dem Zauber schnell das Handwerk gelegt. 

### In die Firma tragen – Schaut mal, was es Neues gibt
Nun ging es daran das neue Tool in die Breite zu tragen. Mit Hilfe eines Confluence-Admins ging das Tool in unserem Firmen-Confluence live. Ich schrieb unten auf die Confluence-Seite, dass Feedback herzlich willkommen sei. Daraufhin meldete sich eine Kollegin mit einem Use-Case auf den ich selbst nie gekommen wäre: Es scheint Kollegen mit so vielen Jobtiteln zu geben, dass sie einen extra Zeilenumbruch in ihrer Signatur benötigen. Die Lösung: Man kann Zeilenumbrüche in der Signatur seither durch Semikola (ja, das ist ein richtiger Plural für Semikolon) im entsprechenden Confluence-Profil-Feld erzeugen.  
Wenige Wochen später folgte eine Rundmail an alle Mitarbeitenden mit der Bitte, ihre Signaturen anzupassen und dafür gerne das neue Tool zu verwenden. Seither darf ich mich über viel positives Feedback von Kollegen freuen, die sich gerade ein paar Minuten Arbeit gespart haben.  

### Lessons Learned:
*	Das Werkzeug sollte zum Rohstoff passen - oft ist praktisch besser als hip.  
Keep It Simple, Stupid :*
*	Nutzer-Feedback ist Gold wert!
*	Das Leben wäre doch langweilig, wenn alle die gleiche Kombination aus Browser und E-Mail-Client verwenden würden.
*	Etwas Zeit vergehen lassen und mit neuen Augen auf das eigene Produkt schauen. Nachdem ich selbst vergessen hatte, was in meiner Anleitung stand, konnte ich eine deutlich übersichtlichere schreiben.
*	Ein Projekt macht besonders viel Spaß, wenn sich auch andere über dein Produkt freuen :)  
{{< img src="/images/qaware-signatur-tool-feedback.png" alt="Feedback" >}}

Hier noch der Link zum Code: https://github.com/susisonnenschein/QAmail-Signatur-Tool
