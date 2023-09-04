---
title: "Don't Crack Under Pressure: Java Microservices and the Battle for Stability Under High Load"
date: 2023-09-04T12:36:33+02:00
author: "[Sebastian Macke](https://github.com/s-macke)"
type: "post"
tags: ["Java", "Web Framework", "REST", "Services", "Thread", "Queue"]
image: "java-service-queues/connections.png"
summary: Explore the challenges of Java microservices under high load conditions.
---

In recent years, I have been working for a large, well-established corporation with an extensive 
IT ecosystem that spans several decades, including various infrastructure, software, and cloud environments, 
with Java being the prominent language. Maintaining seamless operations and ensuring 24/7 availability 
of all these systems is an immense challenge.

As site reliability engineer, I have frequently dealt with outages. Although there 
could be countless reasons for outages, one technical issue that I find particularly bothersome is *high load* in Java services 
and how to fail over safely. Especially when there is no ressource shortage at all.

This article is aimed at those who want to improve the reliability of their Java-based web application services 
and those interested in gaining insights into load testing their services.

# A simple Java Microservice

Let's try an experiment together. Take a Web Application Java Framework. Any framework will do. [Spring Boot](https://spring.io/projects/spring-boot) ? Ok.

We'll stick to a basic "hello world" example without any special configuration, just using plain Spring Boot.

```Java
    @GetMapping("/hello")
    public String hello() {
        return "Hello world";
    }
```

This code is very simple and just returns the string "Hello world". We can easily perform a performance test on this using the load test tool [SlapperX](https://github.com/s-macke/SlapperX).

This test runs on the same machine as the service and sends 5000 requests per second.

{{< animated static="/images/java-service-queues/sb_0s_5000req_play.svg"              anim="/images/java-service-queues/sb_0s_5000req.svg" >}}

The success rate is 100%, and the result always has a status code of 200. Even with such a high number of requests, the average response time for each request is less than 1ms.

# Adding a blocking action

Now, let's discuss a more realistic situation. Typically, a request involves additional actions like authentication, caching, file system access, database queries, and other backend calls. 
These actions delay the current request until the result is ready.

It can take anywhere from a few milliseconds to several seconds, depending on the complexity and specific scenarios. In some cases, a request 
may take up to dozens of seconds to get a response. While this is not ideal for the user, it is generally acceptable. 
After all, we don't have the resources of giants like Google or Amazon to optimize every single request to its full potential.

To simulate a blocking action, we can simply add a *sleep* command to our code.

```log
    @GetMapping("/hello")
    public String hello() {
        Thread.sleep(1000); // Sleep for 1 second        
        return "Hello world";
    }
```    

Now, the "Hello world" response will only be sent after a 1-second delay.

For our performance test, we'll limit it to 200 requests per second.

{{< animated static="/images/java-service-queues/sb_1s_200req_play.svg"               anim="/images/java-service-queues/sb_1s_200req.svg" >}}

The results are what we expected. On average, each request takes exactly 1 second. Additionally, the number of in-flight requests consistently stays around 200.
In-flight requests refer to those requests that have been sent but haven't received a response yet.

# What happens under high load?

Let us make a small change and call the service with 250 requests per second. That is just 50 requests per second more than in the previous example.

{{< animated static="/images/java-service-queues/sb_1s_250req_play.svg"               anim="/images/java-service-queues/sb_1s_250req.svg" >}}

It doesn't look good. Just seconds after starting the calls, the average response time increases significantly. 
Within a minute, the in-flight requests skyrocket, and the average response time reaches 10 seconds. 
The load test was set to have a 10-second timeout. No successful requests are made anymore.

We can play around with the parameters, such as increasing the sleep time to 5 seconds.

{{< animated static="/images/java-service-queues/sb_5s_250req_play.svg"               anim="/images/java-service-queues/sb_5s_250req.svg" >}}

In this case, the service completely fails in less than 10 seconds. A configured liveness probe would not work anymore and would result in a timeout.
Even after stopping the load test, the service remains unusable. Eventually, after several seconds, minutes, or even hours, the service starts to respond normally again.

So far, every Java framework I've encountered behaves like this. However, the threshold varies for each framework.

# What is happening?

We might have reached a certain limit, but which one? First, let's check the complete log output of the service during its run:

```text

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.7.5)

2023-06-18 16:33:45.966  INFO 21785 --- [           main] c.example.restdemo.RestdemoApplication   : Starting RestdemoApplication using Java 17.0.7 on $$$$ with PID 21785 (/home/user/spring_boot/restdemo/build/classes/java/main started by user in /home/user/spring_boot/restdemo)
2023-06-18 16:33:45.969  INFO 21785 --- [           main] c.example.restdemo.RestdemoApplication   : No active profile set, falling back to 1 default profile: "default"
2023-06-18 16:33:46.750  INFO 21785 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2023-06-18 16:33:46.756  INFO 21785 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2023-06-18 16:33:46.757  INFO 21785 --- [           main] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.68]
2023-06-18 16:33:46.824  INFO 21785 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2023-06-18 16:33:46.825  INFO 21785 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 798 ms
2023-06-18 16:33:47.211  INFO 21785 --- [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 9 endpoint(s) beneath base path '/actuator'
2023-06-18 16:33:47.258  INFO 21785 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2023-06-18 16:33:47.271  INFO 21785 --- [           main] c.example.restdemo.RestdemoApplication   : Started RestdemoApplication in 1.596 seconds (JVM running for 1.846)
```

The log output doesn't indicate any issues, and there's nothing in the DEBUG or TRACING log levels either.

Now, let's examine the server's hardware metrics: CPU performance, memory usage, and network throughput:

{{< img src="/images/java-service-queues/metrics.png" >}}

The CPU is idle, network traffic is minimal, and RAM usage is slowly increasing but still low. Clearly, the hardware isn't causing the problem.

So, what's taking up time? Let's look at the tracing output. Every framework allows us to log tracing data, showing how long each request takes:

{{< img src="/images/java-service-queues/tracing.png" >}}

In this tracing output, I've added a gateway that also logs tracing data. The service still 
believes each request takes exactly one second. Only the gateway metrics in relation to the service tracing reveal an issue in the form of a gap in the tracing data.

One final test: let's measure the actual duration of the request:

```Java
    private int counter = 0;

    @GetMapping("/hello")
    public String hello() {
        long startTime = System.nanoTime();
        Thread.sleep(1000); // Sleep for 1 second        
        long stopTime = System.nanoTime();
        System.out.printf("Request No. %5d, Duration=%fs\n", counter, (stopTime - startTime)/1e9);
        counter++;
        return "Hello world";
    }
```

The output is

```text
...
Request No.  2092, Duration=1.000083s
Request No.  2093, Duration=1.000103s
Request No.  2094, Duration=1.000093s
Request No.  2095, Duration=1.000156s
Request No.  2096, Duration=1.000094s
Request No.  2097, Duration=1.000084s
...
```

The request consistently takes one second. Even worse, the request number continues to increase even after stopping the load test for several minutes. 
Calls sent minutes ago are still being processed even if the caller has long disconnected.

<!-- TODO: metrics interface -->

# Recap

To summarize:

We have written a tiny service with a simulated blocking operation and analyzed the response during a high request scenario.

- The service becomes unresponsive and is practically down.
- There is no log output indicating a problem.
- No hardware limitations are present.
- Tracing doesn't reveal any issues. All requests are completed successfully.
- For this reason, no alarms are triggered that directly monitor the service.
- Calls continue to be executed and results are discarded even if the caller disconnects.

{{< note >}}This is the default behaviour of Java microservices under high load conditions!{{< /note >}}

In real-life situations, such scenarios can arise easily. For instance, a backend system might 
take a second longer due to maintenance or a malfunctioning node. One problematic backend system can cause your entire service to fail.

But, the problems don't end there. Users sending requests can also create high load conditions. 
However, this doesn't apply to all endpoints. An example is an endpoint with a large return size, like 5MB:

```Java
    String returnString = new String(new byte[5000000]); // 5 MB
    @GetMapping("/hello")
    public String hello() {
        return returnString;
    }
```

In a test, we request the 5MB output at 10 requests per second. 
At the 10 second mark, another program is launched to download the 5MB file 200 times at a speed 
of 0 bytes per second. This second program stops after an additional 10 seconds.

{{< animated static="/images/java-service-queues/sb_5MB_play.svg"               anim="/images/java-service-queues/sb_5MB.svg" >}}

Since the returned value is larger than the internal buffers, the request remains active until the download is complete. 
The service becomes immediately overwhelmed and unresponsive. Yes, that is all it needs to kill the service. 
To attack a service and cause a denial of service can be easy.

<!-- TODO: Measure latency and metric -->

# Thread Pools and Unbounded Request Queues

The undesireable behavior occurs due to the way thread pools work in Java. The concept is straightforward and can be seen in this image:

{{< img src="/images/java-service-queues/threadpools.png" >}}

The [fixed thread pool](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Executors.html#newFixedThreadPool-int-) documentation states:

```text
public static ExecutorService newFixedThreadPool(int nThreads)

Creates a thread pool that reuses a fixed number of threads operating off a shared
unbounded queue. At any point, at most nThreads threads will be active processing
tasks. If additional tasks are submitted when all threads are active, they will
wait in the queue until a thread is available.
```

Each request uses one worker thread from start to finish. Spring Boot sets the default thread pool size at 200. 
If the thread pool is full, the task is placed in a first in/first out queue. 
However, this queue is *unbounded*, which is the main problem here. 
Each request could wait a long time in the queue, making the service unusable. 
The client connection status doesn't matter at this time as the task is already in the queue and is handled when there is a free worker thread.

So high load in Java Services can be defined as when the maximum number of parallel requests is reached. 
This is typically not related to CPU, RAM, or network limitations.
<!-- That services can run into a high load scenario without exceeding cpu, ram or network capacity should be a running gag in IT. -->

Horizontal scaling fixes the high load problems. With tools like Kubernetes, we made it simple: *Just add more pods*.
It works, and your services run well again. However, is using more hardware and throwing money 
to the problem the real solution?

# Manage your queues

The solution is straightforward: Either increase worker threads or limit your queue size.

First, let's consider worker threads. Should we increase their number? Yes, we can do that. 
However, remember that these threads are managed by the kernel, which is a shared resource 
and responsible for the stability of your system. Overburdening the kernel with thread organization tasks is not recommended. 
Have you ever heard of a [fork bomb](https://en.wikipedia.org/wiki/Fork_bomb)?

Unfortunately, I have not found any information on a reasonable maximum capacity for the kernel. 
Under laboratory conditions, it can handle 10,000 threads without any problem. 
However, I am not sure about its capacity in a shared Kubernetes cluster or in a 24/7 scenario. 
Server operating systems can also impose limits on the maximum number of threads. 
For example, some Linux server distributions set the default limit to a low number, such as 512.

In any case, it is impossible to predict the optimal number of worker threads for every scenario. 
This makes it a parameter that we want to eliminate in the long term (see Reactive and Virtual Threads below).

Now let's consider the queue. Should we limit its size? *Yes, definitely*. Reasonable values can be found in the book:

{{< img src="/images/java-service-queues/sre_book.jpg" >}}


In their *Queue Management* chapter they suggest:

- If the request rate and latency is constant: No queue
- If the request rate is fairly static: 50% or less of the thread pool size
- For bursty loads: Choose a number based on average number of threads in use and the processing time of each request and the size and frequency of bursts.

That are reasonable suggestions. Unbounded queues are not mentioned at all. So the best default value is zero or 50% of the thread pool size.

The exact opposite recommendation I've come across is in the documentation of the [Quarkus](https://quarkus.io/) framework:
{{< img src="/images/java-service-queues/quarkus_queue_suggestion.png" >}}

The discrepancy between Site Reliability Engineers and the author of the Java Framework documentation is just 0 vs. infinite.
Also no description of the parameter is given.

You might think that web frameworks would have reasonable default settings 
in place and provide guidance for configuring services for production use. 
Ideally, every service developer would follow these best practices.
Well, the existence of this article suggests that neither is the case.

# Improving the Spring Boot configuration

<!-- Production readiness or tuning guides. What should we set here? -->

Here's what we want to achieve:
- The service should always be up, running, and responsive.
- If the maximum number of requests is reached, the service should log this issue.
- The service should stop further requests with an appropriate error.


## Tomcat Server

Spring Boot provides three parameters for modifying the behavior of the built-in [Tomcat](https://tomcat.apache.org/) server.
You can easily change the number of threads with a property like `server.tomcat.threads.max=5000`.

However the documentation doesn't mention the queue. Instead, it offers two alternative parameters:

```
server.tomcat.max-connections
server.tomcat.accept-count
```

These parameters can somewhat address high load issues as connections are loosely related to 
requests and can be controlled by both the client and server. 

However, these connection parameters are not appropriate to control the service.
A connection can have different meanings based on the protocol and implementation used. 

- HTTP/1.1: One request per connection at the same time. Keep alive feature can keep a connection alive without a request.
- HTTP/2: Multiplexing allows multiple parallel requests per connection. However, because of [Head-of-line-blocking](https://en.wikipedia.org/wiki/Head-of-line_blocking), this feature might not be used extensively.
- HTTP/3: The connection is no longer handled by the kernel, but your application. Efficient multiplexing allows for separate streams within one connection. Only one connection necessary.

These variants between the implementations and protocols make these connection parameters unpredictable.



Because of the lack to controle the queue I gave this article a developer of Spring Boot for review and as result, a new parameter will be introduced:

```
server.tomcat.threads.max-queue-capacity
```

{{< note >}}Until this parameter is implemented, the lack of control over server internals makes the default server engine in Spring Boot unsuitable for production environments.{{< /note >}}
<!-- https://stackoverflow.com/questions/39644830/what-are-acceptcount-maxconnections-and-maxthreads-in-tomcat-http-connector-con/39645362#39645362 -->

## Jetty Server

But Spring Boot allows using another server instead of Tomcat: [Jetty](https://www.eclipse.org/jetty/).

Switching to Jetty makes a big difference.

{{< animated static="/images/java-service-queues/sb_jetty_1s_250req_play.svg"         anim="/images/java-service-queues/sb_jetty_1s_250req.svg" >}}

Though the timeout issue still isn't solved, the server remains usable, and we get a mix of timeouts and successful calls. 
Jetty's queue is implemented obviously differently and more reasonably.

We can now change the queue size from unbounded to 1 via the parameter `server.jetty.threads.max-queue-capacity=1`.

{{< animated static="/images/java-service-queues/sb_jetty_1s_250req_q1_play.svg"      anim="/images/java-service-queues/sb_jetty_1s_250req_q1.svg" >}}

The service no longer allows requests to be queued and remains responsive under all conditions.
Additionally, we now see an error in the logs, which makes monitoring easier.

```text
2023-06-11 17:46:49.310  WARN 29714 --- [tp466319810-168] o.e.jetty.util.thread.QueuedThreadPool   : QueuedThreadPool[qtp466319810]@1bcb79c2{STARTED,8<=200<=200,i=178,r=-1,q=0}[ReservedTh
readExecutor@29fa40c9{reserved=8/12,pending=0}] rejected org.eclipse.jetty.io.ManagedSelector$DestroyEndPoint@79496273
2023-06-11 17:46:49.310  WARN 29714 --- [qtp466319810-79] o.e.jetty.util.thread.QueuedThreadPool   : QueuedThreadPool[qtp466319810]@1bcb79c2{STARTED,8<=200<=200,i=178,r=-1,q=0}[ReservedTh
readExecutor@29fa40c9{reserved=5/12,pending=0}] rejected org.eclipse.jetty.io.ManagedSelector$DestroyEndPoint@af086f5
2023-06-11 17:46:49.310  WARN 29714 --- [qtp466319810-31] o.e.jetty.util.thread.QueuedThreadPool   : QueuedThreadPool[qtp466319810]@1bcb79c2{STARTED,8<=200<=200,i=178,r=-1,q=0}[ReservedTh
readExecutor@29fa40c9{reserved=5/12,pending=0}] rejected org.eclipse.jetty.io.ManagedSelector$DestroyEndPoint@71038c20
2023-06-11 17:46:49.310  WARN 29714 --- [qtp466319810-37] o.e.jetty.util.thread.QueuedThreadPool   : QueuedThreadPool[qtp466319810]@1bcb79c2{STARTED,8<=200<=200,i=178,r=-1,q=0}[ReservedTh
readExecutor@29fa40c9{reserved=5/12,pending=0}] rejected org.eclipse.jetty.io.ManagedSelector$DestroyEndPoint@242e0902
2023-06-11 17:46:49.310  WARN 29714 --- [qtp466319810-19] o.e.jetty.util.thread.QueuedThreadPool   : QueuedThreadPool[qtp466319810]@1bcb79c2{STARTED,8<=200<=200,i=178,r=-1,q=0}[ReservedTh
readExecutor@29fa40c9{reserved=5/12,pending=0}] rejected org.eclipse.jetty.io.ManagedSelector$DestroyEndPoint@6950a041
2023-06-11 17:46:49.310  WARN 29714 --- [tp466319810-168] o.e.jetty.util.thread.QueuedThreadPool   : QueuedThreadPool[qtp466319810]@1bcb79c2{STARTED,8<=200<=200,i=177,r=-1,q=0}[ReservedTh
readExecutor@29fa40c9{reserved=5/12,pending=0}] rejected org.eclipse.jetty.io.ManagedSelector$DestroyEndPoint@a68223f
```

However, the service only responds with an abrupt disconnect, not an error message for the client. This issue cannot be easily 
fixed in Java and requires a complete change in the internal workings, as explained in the Reactive chapter.

The framework [Quarkus](https://quarkus.io/) has addressed this problem and returns actually an error code when the queue is limited.

{{< animated static="/images/java-service-queues/quarkus_1s_250req_q1_play.svg"    anim="/images/java-service-queues/quarkus_1s_250req_q1.svg" >}}

The `500 Internal Server Error` error code can be changed to a more reasonable `503 Service Unavailable` error.

This is probably the best-case scenario for Java services currently. The service remains responsive, and when worker threads are fully occupied, it returns an error code.

But there is more.

# The importance of Circuit Breakers

Once you understand the behaviour of Java Micro Services under high load you understand the need for circuit breakers in such frameworks.

Circuit breakers monitor error states and contain the logic to prevent future failures. They usually achieve this by not running the problematic code for a certain period of time.

In our case they can be used 

* to protect the backend for being bombarded with more and more requests, which fill up their queues.
* to prevent our service to reach the one-thread-per-request limit.
* to give the user faster feedback about the failure state.

In this case, a circuit breaker can be employed when a backend stops responding (Timeout exception). 
It prevents sending too many requests to an overloaded backend. This way, the backend can recover and function properly again.

However, managing circuit breakers can be challenging. A poorly configured or misunderstood circuit breaker might be even more harmful than not having one at all.
The default of a circuit breaker is usually to trigger on every error state unless the status code is 2xx or 3xx.

Here is a small list of possible errors and how to handle them in general if they are dominant in the response statistics.

* Connection Timeout or Connection Reset: The backend is not even running. No reason to call it. The circuit breaker can trigger.
* Response Timeout: The backend can be overloaded. Trigger the cricuit breaker.
* SSL Handshake Error: One reason could be overloading, but also broken nodes. I would trigger the circuit breaker here.
* Status Code 400 Bad Request: No reason to trigger. The Backend is working as expected.
* Status Code 401 Unauthorized: No reason to trigger. The Backend is working as expected.
* Status Code 500 Internal Server Error: Happens so often for so many reasons that this error state should be excluded from the cricuit breaker. Every non-handled error is mapped to this one.
* Status Code 502 Bad Gateway: The backend is working as expected.
* Status Code 503 Service Unavailable: Sounds like a good idea to trigger the circuit breaker here? But that means, that the server is already protecting itself. Usually no reason to protect it further. 

This short list depicts the difficulty to configure a circuit breaker. Better, the backend server is properly configured and protects itself.


# The argument for Reactive Programming

One problem still exists: the limited number of worker threads and the lack of 
correlation with CPU, RAM, and network usage. 
Java's default operating mode uses blocking I/O, which causes the thread to 
block entirely during an I/O operation. The same goes for the *Thread.sleep* function.

To manage blocking calls without using kernel threads, a solution is to utilize non-blocking I/O operations 
provided by operating systems. This approach only blocks one thread for thousands of parallel I/O operations. 
However, this involves creating an entirely new domain specific language within Java, which is a 
challenging task that takes years of programming forcing reconsideration of control flow, loops, and exception handling. 
This is referred to as Reactive programming in the Java world, and several frameworks are available for it.

The example below shows how a "Hello World" program would look in reactive programming:

```Java
public Mono<ServerResponse> hello(ServerRequest request) {
    return ServerResponse
           .ok()
           .body(BodyInserters.fromValue("Hello world"))
           .log("Request handled")
           .delayElement(Duration.ofSeconds(1))
}
```

Using anything outside of the provided dot-syntax can be risky, as it could result in blocking I/O operations. 
Even an ordinary *System.out.println* line is problematic, because it could be a blocking I/O operation.
Also your entire code must be written in reactive language, and the same goes for all dependencies. 
The style fights the design of Java and pays a high price in maintainability and observability.

But reactive programming for I/O-driven services will soon be replaced by a new Java feature: *Virtual Threads*.

# The argument for Virtual threads

Reactive programming is not the only solution to address this issue. 
For example, the Go programming language has "Goroutines," which are essentially 
virtual threads scheduled in user space. These lightweight threads can be parallelized 
by the millions and do not interfere with the kernel and are only limited by CPU and RAM resources. 
This eliminates the need to limit the number of threads.

With proper runtime support, there's no need to change the code you write. 
A *Thread.sleep* function used in virtual threads puts the virtual thread to sleep, but not the kernel thread. 
A win-win situation both for developers and reliability engineers.

This feature is coming soon with [Java 21](https://www.infoq.com/articles/java-virtual-threads/). 
Framework developers have already pledged their support for virtual threads.


# Conclusion

Java remains the top language for Enterprise applications due to its superior ecosystem compared to other programming languages.

However, it still relies on an outdated threading model, which leads to the *one-kernel-thread-per-request* approach. 
This works well under normal loads and is easy for frameworks to manage but can be difficult to configure and prone to unexpected failures, as highlighted in this article.

A potential solution to these issues is *Virtual Threads*, which could help overcome various 
limitations and simplify the code. The idea of treating parallel running threads like function 
calls is appealing, but it requires unlearning some long-standing Java programming habits.

In the meantime, while we await the introduction of virtual threads, it's important to remember one key suggestion: 

{{< note >}}Limit your request queues!{{< /note >}}



<!--
And please make sure, next time, you run into an overload scenario, that its real.
-->


<!--
#title: "Unbounded Request Queues: What Java Enterprise Applications do Wrong"
#title: "Unbounded Request Queues: The is a flaw in every Java Microservice"
#title: "Unbounded Request Queues: One configuration for more reliability"
#title: "Unbounded Request Queues: One line to safe them all"
1. "Java Under Pressure: Managing High Load in Web Application Services"
2. "Tackling the High Load Challenge: A Guide for Java-Based Web Services"
3. "Surviving High Load: Java Web Application Reliability and Load Testing"
4. "Withstanding the Storm: Load Management for Java-Based Services"
5. "Load and Learn: Mastering High Load Scenarios in Java Web Applications"
6. "Keep Your Java Service Running: Tips on Handling High Load"
7. "Heavy Lifting: A Deep Dive into High Load Management for Java Services"
8. "Under the Weight: Java Web Service Strategies for Handling High Load"
9. "Load Testing and Reliability: Optimizing Java Web Application Services"
10. "Navigate the High Load Minefield: Enhancing Java Web Service Performance"
1. "High Load Havoc: Navigating Java Microservices Under Pressure"
2. "Stress Test Saga: Optimizing Java Microservices for Heavy Traffic"
3. "Hold the Load: Fortifying Java Microservices for High-Stress Scenarios"
4. "Java Microservices Under Siege: Preparing for Load Testing Lightning Rounds"
5. "Lock and Load: Reinforcing Reactive Java Microservices for High-Demand Applications"
6. "Crushing Capacity: Java Microservices and the Battle for Stability Under High Load"
7. "Load Shock: Strengthening Java Microservices for High-Traffic Troubles"
8. "Pushing the Limit: Fine-Tuning Java Microservices for Peak Performance Under Pressure"
9. "Load Hurdles: Scaling Java Microservices to Manage Massive Influxes"
10. "Timeout Terrors: Java Microservices and the Quest for Resilience in High Load Conditions"

-->


<!--
# Outlook

Besides of vitual threads there are two other revolutions waiting: **HTTP/3** in the short term and **WebAssembly** in the long term.

With **HTTP/3** a huge junk of network stack jumps into the user space and into your application. With that every major component is 
in the microservices. The kernel is further disempowered, becomes a controller and just an interface to the hardware.
We will see, how this works out. 
The features of HTTP/3 are eye-opening and might solve many issues and bottle necks we have currently. One of the minor features is, that you can close 
any connection at any time with an application error given an error string and error code leading to a cleaner error handling than we have now.

However, with **Webassembly**, should it finally come, will shake the whole ecosystem. 

**WebAssembly** is supposed to be a compile target into byte code for programming languages with security and portabiloity in mind.
It adds another abstraction layer similar to the **Java Virtual Machine**, but for all languages.
Not only your compiled byte code is executed in a runtime. You don't interface with the kernel directly, but via a system interface specification called [**WASI**](https://wasi.dev/).
**WASI** is supposed, to not only contain low-level abstraction, but also complex objects such as **HTTP**.

However, we the current speed the *WebAssembly* specs are evolving, it might take another five years until we see a usable applications.
How Java will work with WebAssembly is still unknown, because we definitely don't need two abstractions on top of each other.
-->

<!--  but via a separate runtime and a system interface specification callsed *WASI* -->
	
<!--
(Software-) Circuit breakers can be used to protect the application and the backend application. 
It is used to detect failures and encapsulates the logic of preventing a failure from constantly recurring, during maintenance, temporary external system failure or unexpected system difficulties.
-->
<!--
## When to fail?

Backend Connection Timeout ✅
To protect our thread pool
Backend Response Timeout ✅
To protect our and the backend threadpool
Backend 4xx ❌
Bad Request, Not found, Unauthorized are valid responses. Nothing to protect here 
Be careful with error mapping in a complex services mesh. 4xx -> 5xx 
Backend 5xx ?
Indicates an error, that you might want to protect.
In a very complex environment with stateful services, sessions, applicationservers can be counterproductive.
Internal Error ?
It depends

Circuit Breaker are useful but difficult to do right. 
- Lots of parameters involved. 
- Side effects in a complex service network.
-->

<!--
# Other Limits
Incoming Connection-Queues
Outgoing Connection-Queues
Request Headers
-->

<!--
# Why limit kernel ressources
#So, unlimited ressources allocation in the kernel should e avoided.
#But this rule doesn't seem to apply in the user space. Java application all the time allocate and free ressources.
#So why not move the thread handling into user space? That's exactly, what reactive frameworks, Go and Java virtual threads are doing.
-->

