---
title: "A product journey: The QAmail Signature Tool"
date: 2021-05-20T13:50:02+02:00
lastmod: 2021-05-20T13:50:02+02:00
author: "[Susanna Suchan](https://github.com/susisonnenschein)"
type: "post"
image: "qaware-signatur-tool.png"
tags: ["Product Journey", "Confluence", "Signature Tool"]
draft: true
summary: "A product journey: The QAmail Signature Tool generates an email signature from stored Confluence profile data"
---

The QAmail Signature Tool automatically generates an email signature from stored Confluence profile data. In this blog article, I want to take you on my journey from the idea to the final product. Cast off! 

## Initial situation - 1001 signatures

Until now, everyone had been crafting their own email signature using .txt and .htm templates, depending on their email client. This was not very intuitive and thus cumbersome, which in turn led to some delaying signature updates and others not using the templates at all. This resulted in an astonishing variety of different signatures, including occasional typos ("Beste Arbeitgeber ITK 2002", is unfortunately only half as impressive in 2020 as "Beste Arbeitgeber ITK 2020"), transposed digits in phone numbers and overlooked outdated links. A colleague had the idea to automate this. I thought it was a great idea and wanted to implement it. Now the question arose, how to build such a tool best?

## How do I implement it? Hip or better practical? 

My first idea: a hip tool with a fancy UI that gets its data via a Google API. So I read up and was already on fire. Unfortunately, I found that while some data was stored in our Google Contacts, other data (such as the QAware location used) was missing there. Bummer. For privacy reasons I couldn't use the HR department's data either. Too bad. So where to get the data for the signatures? It turned out that most of the required data is stored in Confluence (or at least theoretically should be). The new idea: a Confluence macro. The tool could be easily integrated into our Confluence, would therefore be readily available, could be used without any further approval processes, and by the second use at the latest the necessary data would already be stored in the personal Confluence profile, which would then even be maintained not only theoretically, but also practically. So with a heavy heart, I decided against a hip Google tool and for the more practical Confluence alternative.

## Let's get to work - the pitfalls are always somewhere else than expected

So I read up again. This time how to write a Confluence macro. Unfortunately, you have to be a Confluence admin to create and edit a new Confluence macro. So I booted up my own Confluence and tried my hand at it. Coding was easier than expected. I used our old template and the Confluence API to read and paste the data from the stored Confluence profile. Since the Confluence profile does not include an academic title, I query it at the beginning and include it as an input parameter in my macro. Speaking error messages inform the user which data, if any, needs to be added to his Confluence profile. A nice tutorial and my site was ready for the first test users :confetti_ball:

## Feedback welcome - the users know best what they need & want

So I asked some colleagues to test the tool, and they came up with good ideas: They proposed a box around the generated signature and a copy button. Their wish was my command.   
In the next iteration with other test users, it turned out that with some combinations of browser and email client, horizontal separators of the signature disappeared. Magic? After some research, I found out that the signature template in its original form simply left the styling too many degrees of freedom. After finding the reason, the magic was quickly put to rest. 

## Spreading the word - see what's new

Now it was time to roll out the new tool. With the help of a Confluence admin, the tool went live in QAware's Confluence. I explicitly stated on the page that feedback was welcome. Thereupon a colleague came forward with a use case that I would never have thought of myself: there seem to be colleagues with so many job titles that they need an extra line break in their signature. The solution: Now you can create line breaks in the signature by using semicolons in the corresponding Confluence profile field.  
A few weeks later, a circular email was sent to all employees asking them to adapt their signatures and offering them to use the new tool for this purpose. Since then, I've been pleased to receive a lot of positive feedback from colleagues who have just saved themselves a few minutes of work.  

## Lessons Learned:

* The tool should fit the purpose - often practical is better than hip.  
Keep It Simple, Stupid (KISS :kissing_heart:)
* User feedback is worth its weight in gold!
* After all, life would be boring if everyone used the same combination of browser and email client.
* Let some time pass and look at your own product with new eyes. After I had forgotten what was written in my own manual, I was able to write a much clearer one.
* A project is especially fun when others are also happy about your product :smiley:  
{{< img src="/images/qaware-signatur-tool-feedback.png" alt="Feedback" >}}

If you want to take a look,  
... here you can find the code: https://github.com/susisonnenschein/QAmail-Signatur-Tool  
... here you can find the tool: https://confluence.qaware.de/confluence/display/QAWAREMARKT/QAmail-Signatur-Tool
