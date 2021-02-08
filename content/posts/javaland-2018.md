---
title: "JavaLand 2018"
date: 2018-04-27T15:06:32+02:00
draft: false
tags: [Conference, REST, Security, Legacy, Jupyter Notebooks, Java, Java 10, Valhalla, Pattern Matching, Testing, Regression Testing]
aliases:
    - /posts/2018-04-27-javaland/
summary: Our highlights of JavaLand 2018
---
 
JavaLand is a Java-focused conference which takes place in the theme park Phantasialand close to Cologne. Every year Java developers from all over the country visit exciting talks to expand their knowledge.

We were one of the exhibitors and presented our portable cloud showcase which lets you control OpenShift using a DJ pad. Besides, we held the talks [A Hitchhiker's Guide to Cloud Native Java EE](https://www.slideshare.net/QAware/a-hitchhikers-guide-to-cloud-native-java-ee-90509212) and [Docker und Kubernetes Patterns & Anti-Patterns](https://www.slideshare.net/QAware/docker-und-kubernetes-patters-antipatterns) and visited some others. These were our highlights of JavaLand 2018:

## Deconstructing and Evolving REST Security
* [Talk](https://programm.javaland.eu/2018/#/scheduledEvent/549020) 
* [Slides](https://www.slideshare.net/dblevins1/2018-javaland-deconstructing-and-evolving-rest-security)

The talk summarizes descriptive the advantages and disadvantages of OAuth 2.0, how it compares to Basic Auth and JWT and some hints for the future.

A major problem of Basic Auth is that credentials are sent unencrypted within the HTTP header. With many requests, credentials will repeatedly appear within the transmitted data, making it easier to catch them in one of those requests. OAuth 2.0 reduces this threat by generating new passwords (tokens) regularly. That is basically the only difference to Basic Auth.

Often, it is also required to know who has been authenticated. For example, to give a user access to certain resources only. When using passwords or tokens, this additional information has to be retrieved through a backend call, for example through a LDAP server. An attacker could put lots of load to this backend easily by firing many requests with invalid passwords.

JWT is one possible solution to the aforementioned problem. This token can contain information about the user (like access roles) and thus avoids an additional call to a backend. The signature of this token guaranties that no data has been modified. Additionally, services can verify the signature locally without calling a backend. Attackers will thus be rejected early.

A similar approach is used with HTTP signatures (IETF draft). There, relevant parts of the HTTP request will be signed. A token is not required and the request can be verified locally. There is no information of the user, though.

A promising approach for the future is [OAuth 2.0 Proof-of-Possession](https://tools.ietf.org/html/draft-ietf-oauth-pop-key-distribution-03). The OAuth grant will return a signed JWT with identity information and a key for signing requests on the client. The client will sign the whole request and include the JWT. The backend can verify the request locally and has access to the identity information. No backend calls are necessary.

## Analyze (legacy) applications and show development problems
* [Talk](https://programm.javaland.eu/2018/#/scheduledEvent/549265)  
* [Slides](https://www.javaland.eu/formes/pubfiles/9955104/2018-nn-markus_harrer-mit_datenanalysen_probleme_in_der_entwicklung_aufzeigen-praesentation.pdf)


Have you had problems during development you can't fix correctly because there is no budget / time for it? Do you think there really is no time or budget? Or are it just your 'wonderful designed UI' and the pink glasses of your project manager?

The JavaLand talk of 'legacy code lover' @Feststelltaste tries to give an overview what he is doing and why all project managers are dancing to his tune. From his point of view the main problem is that most development problems are not visible from the outside. There are rule based code analysis tools like SonarQube which answer frequent, common, small technical faults and can give a hint according the software quality. But they do not really help the project manager to understand or see diverse problems.

Also there is no correlation between risk and frequency of a fault and no statement about the impact of a fault.

Clearly SonarQube is good and needed, but it's not enough for a more specific visual code view. It also does not provide any statement about the quality of the 'subject-specific' code and does not prevent from oversleeping upcoming problems.

*We need another approach to convince our project manager!*


## The Jupyter and (Einstein) scientific approach
The foundation of each proceeding success is a proven approach. In our case a good analysis is like a good scientific paper, which normally provides these four components:

1. Context definition
1. Ideas, data assumptions and simplifications
1. Understandable analysis
1. Conclusion

To combine this scientific approach and writing code, you can use [Jupyter Notebook](https://jupyter.org/) ([demo](http://nbviewer.jupyter.org/github/jupyter/notebook/blob/master/docs/source/examples/Notebook/Notebook%20Basics.ipynb)) a notebook style IDE/dashboard which speaks different languages, like Java, Python, R, Haskell, C#, etc. and Markdown. A jupyter notebook provides the ability to define / explain via markdown (1. & 2.), write code (3.) and present your results (4.).

The procedure should now be clear, but which tool to use to extract relevant data from the source code?

For this task [jQAsisstant](https://jqassistant.org/get-started/) ([demo](https://jqassistant.org/demo/java8/); [maven-plugin](https://mvnrepository.com/artifact/com.buschmais.jqassistant.scm/jqassistant-maven-plugin)) could be an option. jQAssistant grabs information from the source code and pushes it into a graph database neo4j. This graph database (with browser frontend) gives the possibility to analyze / create **subject-specific** connections and **adding own concepts**, via query a simple query language in build or via [Neo4j](https://neo4j.com/) browser frontend.

A possible walk-through model to get the analysis data could consist of these steps:

1. Scan software structures
1. Save it to a graph database
1. Analyze and create subject-specific connections
1. Add own concepts (ordinarily the most important part to bring it into management)
1. Export to jupyter notebook, analyze and find the answers

In the end visualize results in jupyter notebook and correct faults or convince the project manager about the technical or subject-specific debts!

## Refactoring to Java 10
* [Talk](https://programm.javaland.eu/2018/#/scheduledEvent/549331)
* [Slides](https://www.javaland.eu/formes/pubfiles/9952507/2018-nn-reinier_zwitserloot-refactoring_to_java_10-praesentation.pdf)


In the talk "Refatoring to Java 10" the guys of [Lombok](https://projectlombok.org/) introduced some of their favorite upcoming Java features and showed how they can be used with Lombok in version 1.9 and earlier using thier library.

As Java 10 comes with a new version numbering scheme upcoming Java versions will be released semi-annual at fixed dates. In opposite to the past releases there are no more promises about the contained features but about the release dates. Therefore, you can't assign some of the following features to specific versions.
 
### var
Imagine a line of code like the following one:
  
```java
ArrayList<String> names = new ArrayList<>()
```

As Java 10 comes with Local-Variable Type interference (var) you can reduce the previous line using the var keyword to:  

```java
var names = new ArrayList<String>();
```

In this case the type of names would be inferred automatically and you wouldn't need to declare it explicitly. This way you can reduce boilerplate code.

But there are some restrictions with var. Consider something like that:

```java
var name = "FOO";
name = name.toLowerCase();
name = name.subSequence(0, 1);
```

The last statement wouldn't work as the method `subSequence` returns a `CharSequence` but the name variable was already inferred as `String`. So it's not possible to change the type of a `var` as it's inferred only once.

Project Lombok allows the usage of `var` (local final variables) and `val` (local non-final variables) already in Java versions 1.9 and below, by adding just a simple dependency. This way you can write your applications the Java 10 way.
 
### Valhalla
Project Valhalla develops new Java language features focusing on memory and performance. One of those features is the so called value type which might come with Java 1.13.[^1]

Imagine the following class representing a point:

```java
class Point {
    int x;
    int y;
}
```

And an array of points like the following:

```java
Point[] points = new Point[1000];
```

In current Java versions the point objects within the array are stored in memory using pointers to both attributes (`x` and `y`). Therefore they need more space than the 8000 (= 1000 (#points) * 2 (#attributes: `x` and `y`) * 4 (size of `int`)) bytes you would assume. Additionally the points are stored together with metadata while they are distributed across memory which might lead to cache misses during retrieval.

With Project Valhalla you can create your own primitives using the `value` keyword. This way the class `Point` would perform like an `int` but can be coded like a class. The elements are stored without any metadata and pointers directly in a successive memory region (like C structs). The class `Point` would look like the following:

```java
value class Point {
    int x;
    int y;
}
```

Furthermore value types...

* support autoboxing. This means that every Valhalla type is its own boxed (wrapped) type like Integer and int. Therefore your primitive can be used as it would extend Object.
* offer a constructor and implementations for equals, toString and hashCode out of the box. All of them are based on the fields of your primitive.
* offer generic specialization. This way you can use your primitives in generics. Consider a list of points for example:

```java
    List<Point> points = new ArrayList<Point>;
```


If you want to try Valhalla types in current Java versions take a look at Lombok and the `@Value` keyword.
 
### Pattern Matching
Amber is another project which focuses on productivity. One of the features of Amber is pattern matching ,which is a pretty simple but effective boilerplate killer.[^2]

Everybody knows lines of code like this:

```java
if (obj instanceof Number) {
    Number number = (Number) obj;
    return Math.abs(number.doubleValue());
} ...
```

With pattern matching you can do the typecast directly in the if-statement:

```java
if (obj instanceof Number number) {
    return Math.abs(number.doubleValue());
} ...
```

You can go even further and use a switch-statement to reduce even more boilerplate code:

```java
switch(obj) {
    case Number number:
        return Math.abs(number.doubleValue());
    ...
}
```

Unfortunately Lombok offers no such feature like Pattern Matching. So you have to wait until it's released in a upcoming version of Java.


As shown, the upcoming Java versions contain a lot of exciting features which help to reduce boilerplate code. If you're interested, project Lombok is worth a look!

### Automatic Regression Test Generation for Legacy Code
* [Talk](https://programm.javaland.eu/2018/#/scheduledEvent/549037)
* [Slides](https://www.javaland.eu/formes/pubfiles/9947732/2018-nn-felix_schumacher-generierung_von_regressionstests_fuer_legacy_code-praesentation.pdf)


Ever had to work on a legacy application with zero tests? Sounds familiar? Felix Schumacher talks about his daily hassles with them and has evaluated several tools for automatic generation of unit-test producing (editable) Java code.

While automatically generated unit-tests in no way replace handwritten tests, they can serve as a good baseline to prepare and conduct initial refactorings on legacy applications. Most of the automatic test generation tools generate several thousands of unit-tests - resulting in long test run times - but dramatically fail to detect the errors introduced by a mutation test frameworks. 

Only one framwork showed promising results while at the same time managing to severely limit the number of produced unit-tests: [Evosuite](http://www.evosuite.org/)

Evosuite sucessfully employs genetic algorithms to let only those unit-tests and parameters survive which really help to bring up the testcoverage. 
Compared to another popular unit-test generation tool called [Randoop](https://randoop.github.io/randoop/), Evosuite manages to produce 66% linecoverage vs. 10%, detect 77% of mutations (generated with [PIT](http://pitest.org/)) vs. 13% while using only 7 testcases vs. 4402 produced by randoop.
Seeing these promising numbers we are looking forward to employ and evaluate Evosuite the next time we have to deal with a legacy application

[^1]: What Is Project Valhalla?
[^2]: Java 10 & Beyond: Diese fünf Features erwarten uns
