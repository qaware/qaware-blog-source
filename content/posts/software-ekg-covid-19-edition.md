---
title: "Presenting Software EKG - COVID-19 Edition"
date: 2020-11-11
lastmod: 2020-11-11
author: "[Karl Herzog](https://github.com/herzogk)"
type: "post"
image: "software-ekg-covid-01.PNG"
tags: ["Software EKG", "Software ECG", "COVID-19", "JavaFX", "Data Science", "Data Analytics"]
aliases:
    - /posts/2020-11-11-software-ekg-covid-19-edition/
draft: false
summary: Our latest tool to analyze global COVID-19 data.
---

## This is Software EKG - COVID-19 Edition

Software EKG is a powerful tool for time series analysis developed by QAware. Utilizing a highly efficient search index and optimized algorithms, the tool enables you to both visualize and analyze time series containing billions of values.

Our special *COVID-19 Edition* provides you with the latest data on COVID-19 from all countries *worldwide*. Not only can you get a detailed overview of the Coronavirus pandemic in a single country, it is also possible to compare different countries with each other using a plethora of metrics like positive test rate, population density or even hospital beds available.

## Why time series analysis is essential

When analyzing the impacts of the Coronavirus pandemic, considering only absolute numbers will not suffice. Instead, it is crucial to take the dimension of time into account. Thus, time series analysis is the key to fully understand current trends and developments regarding COVID-19 and to detect important correlations between metrics (See, for example, the correlation between new death cases (black) and postitive test rate (red) in Germany in the graph below).

![The correlation between new death cases and postitive test rate in Germany](/images/software-ekg-covid-04.PNG)

We are not offering yet another dashboard. What we are offering is our best and most powerful tool for time series analysis, combined with the latest, comprehensive data on COVID-19.

## What our mission is

Our goal is to provide you with the raw data on COVID-19, included in a tool that lets you analyze, visualize and interpret the impacts of the pandemic on a *long term* basis.
By providing Software EKG - COVID-19 Edition free of charge, QAware wants to contribute to a better understanding of the pandemic and support the global efforts against it.

## Our data source

Software EKG - COVID-19 Edition uses data from [Our World in Data (OWID)](https://ourworldindata.org/), a scientific online publication based at the University of Oxford with a focus on large-scale global problems.

OWID data is trusted both in media (BBC, Washington Post, New York Times) and teaching (Harvard, Stanford, Berkeley). As one of the leading organizations publishing global data on the Coronavirus pandemic, OWID has created and maintained a worldwide database on COVID-19.

Please note: We do *not*, in any way, manipulate or change data gathered by OWID.

## How to use Software EKG - COVID-19 Edition

In order to create the best user experience when using Software EKG - COVID-19 Edition, we have recorded several [video tutorials](https://www.youtube.com/playlist?list=PLeUCKzjz0gD5D6OHRnKDQwr5Rnhm2BXsa) that are meant to give you an easily understandable, concise overview of the tool's most important features.

{{< video PbVhHtFQI1I >}}

## How to interpret the data

Just as COVID-19 is a complex issue, so is the huge amount of data on the pandemic. Software EKG - COVID-19 Edition provides you with a plethora of metrics that can be used for further analysis. To fully understand the meaning of each metric, please refer to the [official documentation](https://github.com/owid/covid-19-data/blob/master/public/data/owid-covid-codebook.csv) by *Our World in Data*. Besides an understandable explanation, OWID also provides the source of each metric. Thus, users can be sure they will get reliable and up-to-date raw data when working with Software EKG - COVID-19 Edition.

Our tool groups the provided data into four logical categories: 
- Cases 
- Deaths
- Tests
- Miscellaneous data (Misc)

Misc includes various metrics that might be of interest in conjunction with COVID-19 specific data. For example, users might find it informative to compare the positive rate of a country with its population, its median age or the percentage of other diseases like diabetes or cardiovascular diseases.
Please note it cannot be guaranteed that data on each metric for each country worldwide will always be available. The existence of reliable data also depends on the individual circumstances in a certain country as well as on how data is collected by local authorities.
Also, it is noteworthy while some metrics like the number of new cases or new tests will change on a daily basis, there are others like population or life expectancy that will remain constant over a longer period of time.

Just as COVID-19 is a complex issue, so is the huge amount of data on the pandemic. Software EKG - COVID-19 Edition provides you with a plethora of metrics that can be used for further analysis. To fully understand the meaning of each metric, please refer to the [official documentation](https://github.com/owid/covid-19-data/blob/master/public/data/owid-covid-codebook.csv) by *Our World in Data*.

## How to get the tool

In order to download Software EKG - COVID-19 Edition, please visit the [official website](https://qaware.de/software-ekg-covid-edition). We provide downloads for all three major operation systems (Windows, Mac and Linux). You will also find a detailed FAQ section, should you have any further questions regarding the tool.

----

## Related posts

* [Software-ECG COVID-19 Edition: The Second Wave Is Breaking in Europe]({{< relref "/posts/software-ecg-second-wave.md" >}})
* [Software-ECG COVID-19 Edition: Where Is The Second Wave In Russia And China?]({{< relref "/posts/software-ecg-second-wave-in-asia.md" >}})
* [Software-ECG COVID-19 Edition: Different Waves]({{< relref "/posts/software-ecg-different-waves.md" >}})
* [Software-ECG COVID-19 Edition: Summer in Oceania]({{< relref "/posts/summer-in-oceania.md" >}})