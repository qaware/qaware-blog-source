---
title: "WireSpock - Testing REST service client components with Spock and WireMock"
date: 2015-12-30T10:39:32+02:00
draft: false
author: Mario-Leander Reimer
tags: [BDD, Java, Microservices, REST, Spock, Testing, WireMock]
summary: A short tutorial on how to use WireMock together with Spock.
aliases:
    - /posts/2015-12-30-wirespock/
summary: I want to showcase a neat technology integration between Spock and the WireMock framework for testing your REST service client components. 
---

In a [previous post](../2015-08-31-spock-testing/) I have written about using the Spock framework for the exploratory testing of open source software. In this post I want to showcase a neat technology integration between Spock and the WireMock framework for testing your REST service client components. This is especially useful when testing micro service based architectures, since you want to test the individual service integrations without firing up all the collaborators.

# Introducing WireMock
As stated on it's [webpage](http://wiremock.org/index.html), WireMock is "a web service test double for all occasions". It supports stubbing and mocking of HTTP calls, as well as request verification, record and playback of stubs, fault injection and much more. It actually fires up a small embedded HTTP server, so your code and test interacts with it on the protocol level.

The most convenient way to use WireMock in your test cases is via a JUnit 4.x rule that handles the lifecycle of starting and stopping the mock server before and after each test. There also is a class rule available in case it is sufficient to use the same WireMock instance for the lifetime of the whole test case. The official documentation for the rule can be found [here](http://wiremock.org/junit-rule.html).

The good thing is that you can use the WireMock rule in your Spock specification just like in an ordinary JUnit based test. No magic here. Let's have a look at the following example.

```java
class BookServiceClientSpec extends Specification {

    @Rule
    WireMockRule wireMockRule = new WireMockRule(18080)

    @Shared
    def client = new BookServiceClient("http://localhost:18080")

    def "Find all books using a WireMock stub server"() {
        given: "a stubbed GET request for all books"
        // TODO

        when: "we invoke the REST client to find all books"
        def books = client.findAll()

        then: "we expect two books to be found"
        books.size() == 2

        and: "the mock to be invoked exactly once"
        // TODO
    }
}
```

First, the JUnit WireMock rule is created and initialized to listen on port 18080. Next the REST client component under test is created and configured to access the local wire mock server. The test method itself does not do much yet. For it to work we need to stub the response for the `findAll()` query and we want to check that the mock has been invoked once. Before we continue, let's have a look at the test dependencies required to compile and run the example.

```groovy
dependencies {
    testCompile 'junit:junit:4.12'
    testCompile 'org.spockframework:spock-core:1.0-groovy-2.4'

    testCompile 'com.github.tomakehurst:wiremock:1.57'
    testCompile 'com.github.tomjankes:wiremock-groovy:0.2.0'
}
```

# Making WireMock Groovy
The last dependency is a small Groovy binding library for WireMock that plays together nicely with Spock. It allows for a more concise stubbing and verification syntax instead of using WireMock's default static imports API. Have a look at the following example to get the idea.

```groovy
def wireMock = new WireMockGroovy(18080)

def "Find all books using a WireMock stub server"() {
    given: "a stubbed GET request for all books"
    wireMock.stub {
        request {
            method "GET"
            url "/book"
        }
        response {
            status 200
            body """[
                      {"title": "Book 1", "isbn": "4711"},
                      {"title": "Book 2", "isbn": "4712"}
                    ]
                 """
            headers { "Content-Type" "application/json" }
        }
    }

    when: "we invoke the REST client to find all books"
    def books = client.findAll()

    then: "we expect two books to be found"
    books.size() == 2

    and: "the mock to be invoked exactly once"
    1 == wireMock.count {
        method "GET"
        url "/book"
    }
}
```

First, we create the WireMock Groovy binding to create stubbed requests and responses. The stub closure takes the definitions of the REST request and response using the WireMock JSON API. As you can see we can even specify the response body as inline JSON multiline _GString_. Finally, we check that the invocation count for the expected request is correct.

Clearly, specifying the responses inline is not very maintenance friendly especially for large response structures. So a better alternative is to externalize the response body in a separate file. The file needs to be located in a directory named `__files` within `src/test/resources`.
The `bodyFileName` value is relative to the `__files` directory and contain any content. You could even return binary files like JPEGs using this mechanism.

```groovy
response {
    status 200
    bodyFileName "books.json"
    headers { "Content-Type" "application/json" }
}
```

A further way of specifying the response body is by using plain Java or Groovy objects that get serialized to JSON automatically.

```groovy
response {
    status 200
    jsonBody new Book(title: "WireSpock Showcase", isbn: "4713")
    headers { "Content-Type" "application/json" }
}
```

The stubbing capabilities of WireMock are quite powerful. You can perform different matchings on the URL, request headers, query parameters or the request body to determine the correct response. Have a look at the [WireMock](http://wiremock.org/stubbing.html) stubbing documentation for a complete description of all features.

So there is only one thing left to say: _Test long and prosper with Spock!_

# References
* [Spock Reference Documentation](https://spockframework.github.io/spock/docs/)
* [WireMock Homepage](http://wiremock.org/index.html)
* [Spock Reference Documentation](https://github.com/tomjankes/wiremock-groovy)
