---
title: "Generating OpenApi specification from Spring Boot"
date: 2020-12-16
draft: false 
author: "[Andreas Grub](https://github.com/neiser)"
type: "post"
image: "openapi-lib-title.png"
tags: ["OpenApi", "Spring", "Spring Boot", "Library", "Tools"]
aliases:
    - /posts/2020-12-16-openapi-for-spring-generator/
summary: This post highlights some features what the new library for generating OpenAPI v3 specifications from your running Spring Boot application can do.
---

An [OpenAPI specification file][OpenApiSpec] is a document describing the (HTTP) API endpoints of your application. 
Based on the specification, you can generate clients directly interacting with your application for 
almost any programming languages. For example, this is convenient for frontend development using the application's backend API.  
You may know it also as "Swagger", which is the former name for the OpenAPI 
specification version 2. It has now become an open initiative to promote well-documented application APIs everywhere.

Today, we proudly present [a new library][OpenApiLib] for generating [OpenAPI v3 specifications][OpenApiSpec] from 
your running [Spring Boot][SpringBoot] application.
The development was supported by [QAware] and is now released [on GitHub][OpenApiLib].

This post highlights some features what this library can do. You can also just skip reading and 
just include its Spring Boot Starter to give it a shot:
```
<dependency>
    <groupId>de.qaware.tools.openapi-generator-for-spring</groupId>
    <artifactId>openapi-generator-for-spring-starter</artifactId>
    <version>1.0.1</version>
</dependency>
```
After opening `/swagger-ui` relative to your application's endpoint in your browser, 
you should see something like:

{{< img src="/images/openapi-lib-swagger-ui.png" alt="Swagger UI of WebMVC demo" >}}

If you don't see that, please [open an issue](https://github.com/qaware/openapi-generator-for-spring/issues). 
The above screenshot is taken from the included [WebMVC demo application](WebMvcDemo), 
but it works also just the same for [WebFlux][WebFluxDemo].

[OpenApiLib]: https://github.com/qaware/openapi-generator-for-spring
[OpenApiSpec]: https://github.com/OAI/OpenAPI-Specification
[SpringBoot]: https://spring.io/projects/spring-boot
[QAware]: https://www.qaware.de
[WebMvcDemo]: https://github.com/qaware/openapi-generator-for-spring/tree/master/demo/openapi-generator-for-spring-demo-webmvc
[WebFluxDemo]: https://github.com/qaware/openapi-generator-for-spring/tree/master/demo/openapi-generator-for-spring-demo-webflux

## Why this library?

*If you like to read only a few sentences why:*

The library was built from ground up without any prerequisite except Spring Core. 
It natively supports WebMVC and WebFlux and is customizable to any extent thanks to Spring Boot auto-configurations.
The library adheres to as many "Spring best practices" as known to the authors and treats code quality and exhaustive 
testing as a first class citizen.

*If you like a list of some (arbitrarily relevant) bullet points of reasons, here's one:*

* Correctly handles Schema building for self-referencing (nested) types
* Ships Swagger UI out-of-the-box without triggering Spring Boot's WebJar auto-configuration
* Supports WebFlux including Router Functions and WebMVC Handler Methods
* Supports Content Negotiation within the limits of the OpenAPI specification
* Is highly customizable using custom beans for filtering and adapting the generated model
* Support JSON and (optional) YAML output of the specification

*If you like to study examples, here's a list:*

* [Filtering the spec depending on the path prefix][Example1] see [filtered result 1][Example1Result1] 
  and [filtered result 2][Example1Result2].
* [Self-referencing types][Example2] see [result][Example2Result] which shows multiple references 
  due to different descriptions and other properties.
* [Mono and Flux support][Example3] with [result][Example3Result], which is implemented 
  as [an extension for Schema resolving][Example3Extension] only active when running with WebFlux.
* [Elegant support for `@ExceptionHandler`][Example4]

[Example1]: https://github.com/qaware/openapi-generator-for-spring/blob/master/openapi-generator-for-spring-test/src/test/java/de/qaware/openapigeneratorforspring/test/app10/App10Configuration.java
[Example1Result1]:  https://github.com/qaware/openapi-generator-for-spring/blob/master/openapi-generator-for-spring-test/src/test/resources/openApiJson/app10_admin.json
[Example1Result2]: https://github.com/qaware/openapi-generator-for-spring/blob/master/openapi-generator-for-spring-test/src/test/resources/openApiJson/app10_user.json

[Example2]: https://github.com/qaware/openapi-generator-for-spring/blob/master/openapi-generator-for-spring-test/src/test/java/de/qaware/openapigeneratorforspring/test/app5/App5Controller.java#L91
[Example2Result]: https://github.com/qaware/openapi-generator-for-spring/blob/master/openapi-generator-for-spring-test/src/test/resources/openApiJson/app5.json#L164

[Example3]: https://github.com/qaware/openapi-generator-for-spring/blob/master/openapi-generator-for-spring-test/src/test/java/de/qaware/openapigeneratorforspring/test/app20/App20Controller.java#L22
[Example3Result]: https://github.com/qaware/openapi-generator-for-spring/blob/master/openapi-generator-for-spring-test/src/test/resources/openApiJson/app20.json
[Example3Extension]: https://github.com/qaware/openapi-generator-for-spring/tree/master/openapi-generator-for-spring-webflux/src/main/java/de/qaware/openapigeneratorforspring/common/schema/resolver/type

[Example4]: https://github.com/qaware/openapi-generator-for-spring#how-to-handle-error-responses-elegantly

Most of the above links point to integration tests of the library, 
which can be run as standalone Spring Boot applications.

*If you like to read why not any other library, read the next paragraph.*

## Why not SpringFox or SpringDoc?

There have already been other libraries with a similar focus on the market,
such as [Spring Fox][SpringFox] and [Spring Doc][SpringDoc]. 

Before starting this library, we have widely used Spring Fox in our projects but got more and more
constrained by the library. Also, maintenance and inclusion of pull requests
seemed to have died down in 2019, although it got more lively recently. 

Spring Doc seemed to be the perfect alternative about a year ago, and one author
of this new library [actually tried to contribute][SpringDocPRs] and adapt the existing one. However, we found 
more and more that some useful things are not so easy to do even with Spring Doc, and started developing our own. 
It was also just a fun experience!

[SpringFox]: https://github.com/springfox/springfox
[SpringDoc]: https://github.com/springdoc/springdoc-openapi
[SpringDocPRs]: https://github.com/springdoc/springdoc-openapi/pulls?q=is%3Apr+is%3Aclosed+author%3Aneiser

## Acknowledgements

This library was developed by [Dirk Kröhan](https://github.com/dkroehan) and [Andreas Grub](https://github.com/neiser) 
and was gratefully supported by [QAware] by allowing us to do that during paid working hours. 
It was finally released thanks to the QAgarage day end of November, where many of us took the chance 
to do useful stuff but never found time for it outside the usual project churn.

----

## Related posts

* [Introducing Minikube Support Tools]({{< relref "/posts/introducing-minikube-support-tools.md" >}})
* [Virtual Kubelet - Run Pods Without Nodes]({{< relref "/posts/virtual-kubelet.md" >}})