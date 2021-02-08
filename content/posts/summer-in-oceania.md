---
title: "Software-ECG COVID-19 Edition: Summer in Oceania"
date: 2020-12-18
draft: false
author: "[Johannes Weigend](https://www.qaware.de/unternehmen/johannes-weigend/) & [Karl Herzog](https://github.com/herzogk)"
type: "post"
tags: ["Software EKG", "Software ECG", "COVID-19", "JavaFX", "Data Science", "Data Analytics"]
image: software-ecg-deaths-oceania.png
aliases:
    - /posts/2020-12-18-summer-in-oceania/
summary: Looking at COVID-19 case numbers in Oceania using the Software-ECG.
---

*CW 51: Analyzing COVID-19 data with Software-ECG COVID-19 Edition*

In this series of blogs we are looking at the current figures of the COVID-19 pandemic with *Software-ECG*. It is a free time series analysis tool originally developed for time series analysis for system analysis of computer problems in distributed systems. With its COVID-19 edition, QAware has adapted the tool so that the current data from the data hub of the University of Oxford (*Our World in Data* - [OWID](https://ourworldindata.org/)) are automatically loaded and immediately available for analysis. More information about Software-ECG and download links can be found here: [Presenting Software EKG - COVID-19 Edition]({{< relref "software-ekg-covid-19-edition.md" >}} )

*Note: The German translation for ECG is EKG (Elektrokardiogramm). We are Germans, therefore we use the names “Software ECG” and “Software EKG” as synonyms.*

 Software-ECG ist build on Open-JDK and JavaFX. It leverages the power of a compiled language with a native Rich Client Framework.

## CW 51: Summer in Oceania

Recently, we looked at the current development in Europe, China and South America. In Europe, we saw that the second wave is breaking and has already peaked in most countries. However, the numbers in Germany and Russia have not dropped yet. Here, both the number of people tested positive and the number of people who died (with a positive COVID-19 test result) have continued to rise. The number of deaths are significantly higher in Germany (green line) and Russia (purple line) than in spring 2020.

{{< figure figcaption="Number of deceased in all European countries as of 12/17/2020" >}}
  {{< img src="/images/software-ecg-number-deaths-europe-17-12.png" alt="Current deaths in Europe" >}}
{{< /figure >}}

Unfortunately, this does not look good and therefore we prefer to go back to the southern hemisphere today where it is summer at the moment. In our last blog, we looked at South America and saw that, unfortunately, the recovery phase in Brazil during summer was not as significant as the one we observed in Europe in the summer of 2020.

The data from the [Our World In Data (OWID)](https://ourworldindata.org/) COVID-19 dataset includes the pseudo-continent of Oceania as a collective term for all countries in Australia, New Zealand and Polynesia. In *Software-ECG COVID-19 Edition*, all metrics from this region can be displayed individually or in an aggregated way. To achieve this, you need to select the continent *Oceania* in the tree view on the left side of the application. As a sub-node, you can either select an individual country or the metrics of all countries with *\**. By clicking on a metric in the category *DEATHS*, for example, you will get this metric for all countries in Oceania.

{{< figure figcaption="Software-ECG wildcard selection" >}}
  {{< img src="/images/software-ecg-wildcard-selection.png" alt="Wildcard selection" >}}
{{< /figure >}}

The non-smoothed curves showing the numbers of new deaths associated with COVID-19 are remarkably low.

{{< figure figcaption="Aggregated view as stacked graph of daily COVID-19 death counts in Oceania" >}}
  {{< img src="/images/software-ecg-deaths-oceania.png" alt="Deaths Oceania" >}}
{{< /figure >}}

The curve shows the daily death counts associated with COVID-19 as a stacked graph. The highest value is still very low at 59. Since the curve is almost entirely made up of a yellow area, you can see that essentially only Australia was really affected. In early October the numbers dropped to almost 0 with the exception of a few isolated cases. This is exactly interlaced with the situation in Europe where the second wave was spreading at high speed at the beginning of October.

This curve looks very good and it shows what you would actually expect during the summer months. In our last blog, however, we saw that unfortunately, South America is an exception here.
Looking at the testing situation, it is noticeable that Australia and New Zealand dominate the graph with regard to the daily number of tests performed. Also, the number of tests is relatively constant. This is good because it allows us to estimate the true prevalence of the virus from the graph of the current number of cases, since the number of tests correlates with the number of cases.

{{< figure figcaption="Number of COVID-19 PCR tests performed in Australia (red) and New Zealand (blue)" >}}
  {{< img src="/images/software-ecg-tests-oceania.png" alt="Tests Oceania" >}}
{{< /figure >}}

The cumulative view of the case numbers also shows very well that COVID-19 in Oceania has currently subsided to a background activity. We have too little information about the political decisions and actions that may have influenced or favored this development. In sum, however, you can see that fear of COVID-19 in these countries does not seem to be appropriate.

{{< figure figcaption="Summer in Oceania: Aggregated sum view of case numbers in Oceania" >}}
  {{< img src="/images/software-ecg-oceania-aggregated-2.png" alt="Sum view Oceania" >}}
{{< /figure >}}

As Europeans you might become envious but let us not forget we also had a nice summer and were able to let some normality return into our lives. With this in mind, the people in Oceania should also be granted some normality. However, those having relatives in Oceania should really consider moving their home offices into this region (at least until April).

----

## Related posts

* [Presenting Software EKG - COVID-19 Edition]({{< relref "/posts/software-ekg-covid-19-edition.md" >}})
* [Software-ECG COVID-19 Edition: The Second Wave Is Breaking in Europe]({{< relref "/posts/software-ecg-second-wave.md" >}})
* [Software-ECG COVID-19 Edition: Where Is The Second Wave In Russia And China?]({{< relref "/posts/software-ecg-second-wave-in-asia.md" >}})
* [Software-ECG COVID-19 Edition: Different Waves]({{< relref "/posts/software-ecg-different-waves.md" >}})
