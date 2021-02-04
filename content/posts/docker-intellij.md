---
title: "How to use Docker within IntelliJ"
date: 2016-04-23T10:39:32+02:00
draft: false
author: Josef Adersberger
tags: [IntelliJ, Docker, Gradle]
aliases:
    - /posts/2016-04-23-docker-intellij/
summary: A short tutorial on how to use Docker within intelliJ and with a little help from Gradle.
---
A short tutorial on how to use Docker within intelliJ and with a little help from Gradle. You can find the sample code & the full description [here](https://github.com/adersberger/intellij-docker-tutorial) 

# Prerequisites
* Install [IntelliJ Docker plugin](https://plugins.jetbrains.com/plugin/7724)
* Install [Docker Machine](https://docs.docker.com/machine/get-started)
* Check that there is a default Docker Machine: docker-machine ls. If there is no default machine create one: `docker-machine create --driver virtualbox default`.
* Start the default Docker Machine: `docker-machine start default`.`
* Bind the env vars to the shell: `eval "$(docker-machine env default)"`
* Check if everything is correct: `docker ps`

# Using Docker within IntelliJ
1) Setup Docker cloud provider in intelliJ global preferences as shown below.

![](/images/docker-pic-1.png)

*Tip*: You can get the API URL by executing `docker-machine ls` and using the shown IP & port for the `default` machine.

2) Check connection to Docker daemon in intelliJ "Docker" tab

![](/images/docker-pic-2.png)

3) Create new project from version control using [github](https://github.com/adersberger/intellij-docker-tutorial.git)

4) Create a new run configuration to deploy application to Docker as shown on the following screenshots:

![](/images/docker-pic-4.png)

*Tips:*
* Be sure not to forget to add the Gradle tasks as a "before launch" action as shown at the very bottom of the screenshot.
* The same is also possible for Docker Compose files. Just point the "Deployment" dropdown to the Docker Compose file.

![](/images/docker-pic-5.png)

5) Run the configuration and inspect the Docker container. A browser will open automagically and point to the REST endpoint. Within intelliJ you can access the containers console output, environment variables, port bindings etc.

![](/images/docker-pic-3.png)

 # Links

* [Tutorial and sample code on github](https://github.com/adersberger/intellij-docker-tutorial)
* [Docker intelliJ Help](https://www.jetbrains.com/help/idea/2016.1/docker.html)
* [Blog post on Docker intelliJ](https://blog.jetbrains.com/idea/2015/03/docker-support-in-intellij-idea-14-1)


