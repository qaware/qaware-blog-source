---
title: "Breaking your build on SonarQube quality gate failure"
author: "Moritz Kammerer"
date: 2020-02-17T10:39:32+02:00
draft: false
tags: [Software Quality, SonarQube, Continuous Integration, DevOps]
aliases:
    - /posts/2020-02-17-sonar-qube-build-breaker/
summary: A summary on my QAlabs project for a Maven plugin and a standalone application to break the build on SonarQube quality gate failure
---

We use [SonarQube](https://sonarqube.com) to do a static analysis of our code for code smells, security bugs and more. SonarQube had a great feature in earlier versions: breaking the build if the quality gate of your project is red. A quality gate defines the metrics you want your code to have, for example: no detected bugs, code coverage 80% or more, no TODO comments. SonarQube quality gates help us to follow the rule "don't live with broken windows"[^1] in our daily work.

If the quality gate fails, the build breaks and the developer which made the change immediately notices that something went wrong and fixes the code. I found this feature really helpful, especially when working in a pull-request based manner. When running the SonarQube analysis on the pull-request and the quality gate turns red, the build of this branch fails. As a passing build is a requirement for the merge into the master, you have ensured that no broken code (at least how SonarQube sees it) ever reaches the master branch.

Unfortunately the [SonarQube developers don't agree with me on that](https://blog.sonarsource.com/why-you-shouldnt-use-build-breaker/). They removed the functionality to break the build from their Maven SonarQube plugin. They later [posted a way to fail the build using a webhook](https://blog.sonarsource.com/breaking-the-sonarqube-analysis-with-jenkins-pipelines/), which is a really great solution when you are allowed to install Jenkins plugins. That won't work when you are not allowed to install the plugin or if you don't use Jenkins. In my project we work with Gitlab CI and we wanted a way to fail the build if the SonarQube quality gate is red.

Here at QAware there is the concept of QAlabs - this is a place where you essentially get (paid) time to develop something outside of your project if it benefits the company. I did exactly that - told the idea to the QAlabs chief, received green light and implemented it.

We [open sourced the code](https://github.com/qaware/sonarqube-build-breaker), as we think other people also need a solution for that (just google for "SonarQube break build"...). [I wrote a Maven plugin to break the build](https://github.com/qaware/sonarqube-build-breaker/tree/master/sqbb-maven-plugin). Integration is easy, all you need is the URL to the SonarQube server and an API token. "But I don't use Maven", i hear you say. Fear not, as [we also built a standalone application](https://github.com/qaware/sonarqube-build-breaker/tree/master/cli) which you can run in your pipeline. It returns exit code 0 when the quality gate is green and exit code 1 if it's red. You should be able to integrate this in every CI pipeline you use.

At the end of the year, there is a price for the best QAlabs project. And guess which project had won? The SonarQube Build Breaker! Yeah!

You have a cool idea for a QAlabs project and want to participate, too? [We're hiring](https://www.qaware.de/karriere) :)

[^1]: Andrew Hunt, David Thomas (1999). The Pragmatic Programmer. Addison-Wesley
