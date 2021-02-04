---
title: "How to develop Eclipse SmartHome Bindings with IntelliJ and Docker"
date: 2017-09-20T15:06:32+02:00
draft: false
author: "Moritz Kammerer"
tags: [SmartHome, Eclipse, Java, Home Automation, IoT, IntelliJ, Docker]
aliases:
    - /posts/2017-09-20-eclipse-smart-home-bindings/
summary: We show you our approach on how to develop Eclipse SmartHome bindings with IntelliJ And Docker.

---
Developing the Eclipse SmartHome (ESH) bindings with another IDE than Eclipse is difficult because the standard way of developing the bindings requires the tools provided by the Eclipse IDE. One can develop the ESH bindings with IntelliJ, however a crucial question remains open: how to test the developed bindings without having the Eclipse tools at hand?
Using IntelliJ to develop the ESH bindings is different to using Eclipse for two main reasons:

* **First**: Eclipse uses a “manifest first” approach while the Java standard approach is “POM first” with a handwritten or generated manifest. In our example we have used a handwritten manifest.
* **Second**: To debug and test in Eclipse, it is enough start the full environment using the target platform provided by ESH. This starts a JVM with equinox as a local process. To debug and test in IntelliJ, one should copy the binding jar built by MAVEN into a prepared Docker container and then start it.


## Minimal Eclipse SmartHome for testing bindings in IntelliJ
Our approach is based on the [packaging example](https://github.com/eclipse/smarthome-packaging-sample) of ESH in combination with [Eclipse Concierge](http://www.eclipse.org/concierge/) as OSGi Container.
A full MAVEN build with mvn clean package creates a new zip file within the /target directory. This zip file contains a full OSGi container, the Eclipse SmartHome basics, the Yahoo Weather Binding and an addons directory. The OSGi container scans the addons directory for bundles and deploys them automatically. This zip file can be used to create a Docker container.
In order to stop the container gracefully a small change in the start script is needed. A description of it can be found here: [qaware/smarthome-packaging-sample](https://github.com/qaware/smarthome-packaging-sample).

We have updated and added some dependencies to the original repository. One of the updated dependencies is the Jetty webserver, which also includes its client in the latest version of the 9.3.x branch.

## The Docker Container
*All the following examples and commands are based on the [qaware/smarthome-packaging-sample](https://github.com/qaware/smarthome-packaging-sample) repository.*

The Dockerfile creates an image which is runnable out of the box. It contains a full Eclipse SmartHome, which runs on an Alpine Linux with the current OpenJDK 8 Runtime Environment. The image has a final size of less than 140 MB.

```docker
FROM openjdk:8-jre-alpine
 
ENV DEBUG_PORT=5005 HTTPS_PORT=8443 HTTP_PORT=8080
 
WORKDIR /opt/esh/runtime/concierge
ADD /target/smarthome-packaging-sample-*.zip /tmp/
RUN apk add --update unzip \
 && mkdir -p /opt/esh/conf/services \
 && unzip /tmp/smarthome-packaging-sample-*.zip -d /opt/esh \
 && chmod +x /opt/esh/runtime/concierge/start.sh \
 && rm -f /tmp/smarthome-packaging-sample-*.zip \
 && apk del wget \
 && rm -rf /var/cache/apk/*
EXPOSE 5005 8080
ENTRYPOINT exec /opt/esh/runtime/concierge/start.sh
```

You can find the Dockerfile within the forked repository.
To build and tag the container as `eclipse/smarthome:latest`, you need to run:
`./mvnw clean package && docker build . -t eclipse/smarthome:latest`
Now it is possible to start the container:

```bash
docker run -dit \
  -p 127.0.0.1:8080:8080 \
  eclipse/smarthome:latest
```

You can subsequently open the [PaperUI](http://127.0.0.1:8080/) and the [System Console](http://admin:admin@127.0.0.1:8080/system/console) (username & password: admin).
The container can also be started in debug mode, which allows connecting an external debugger to the container. To start the container in debug mode use this command:

```bash
docker run -dit \
  -p 127.0.0.1:8080:8080 \
  -p 127.0.0.1:5005:5005 \
  -e "REMOTE_DEBUG=true" \
  eclipse/smarthome:latest
```

You can now connect the container with a Java debugger (like IntelliJ) using the address `127.0.0.1:5005`.

## Run and Debug an Eclipse SmartHome Binding within the Docker container
This part builds upon our previous blog post about the usage of Docker and IntelliJ: How to use Docker within IntelliJ
You can use the previously created Docker image for the development of bindings. To do that you need another small Dockerfile which copies the binding into /opt/esh/addons/ of the container:

```docker
FROM eclipse/smarthome
# replaces org.eclipse.smarthome.binding.hue with your binding id
ADD target/org.eclipse.smarthome.binding.hue-*.jar /opt/esh/addons
```

You can place this Dockerfile into the main directory of the bundle, next to the MAVEN pom.xml, and subsequently use it for a new Docker deployment in IntelliJ as described in How to use Docker within IntelliJ. In IntelliJ you can directly start the Docker deployment with an attached debugger. Alternatively, you can create a volume mount to /opt/esh/addons and, after the successful completion of the build, copy the binding jar into the mount.

## Recommended Volume Mount
We recommend to mount a volume into the Docker container to store the information about the bindings and the other configurations of the ESH: `/opt/esh/userdata`