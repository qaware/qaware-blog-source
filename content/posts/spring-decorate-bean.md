---
title: "Ways to decorate Spring beans"
date: 2021-01-12
lastmod: 2021-01-12
author: "[Moritz Kammerer](https://github.com/phxql)"
type: "post"
image: "decorator-pattern.png"
tags: ["Java", "Spring"]
aliases:
    - /posts/2021-01-12-spring-decorate-bean/
summary: In this blog post, we'll look at various ways to decorate a Spring bean.
draft: false
---

In this blog post, we'll look at various ways to decorate a Spring bean. The [decorator pattern](https://en.wikipedia.org/wiki/Decorator_pattern) is a software engineering
pattern "that allows behavior to be added to an individual object, dynamically, without affecting the behavior of other objects from the same class." [^1]

First, let's create our interface:

```java
public interface OurService {
    String doSomething();
}
```

and one simple implementation:

```java
public class OurServiceImpl implements OurService {
    @Override
    public String doSomething() {
        return "something";
    }
}
```

Now, let's create our decorator object which will decorate other `OurService` instances:

```java
public class LoggingOurService implements OurService {
    private static final Logger LOGGER = LoggerFactory.getLogger(LoggingOurService.class);

    private final OurService delegate;

    public LoggingOurService(OurService delegate) {
        this.delegate = delegate;
    }

    @Override
    public String doSomething() {
        LOGGER.info("doSomething() called");
        return delegate.doSomething();
    }
}
```

As you see, this class takes another instance of `OurService` via constructor injection and stores it in the `delegate` field.

When the `doSomething()` method is called (that's the method defined in the interface), first a log message is printed and then
the delegate is called.

Using this in a non-Spring application is really easy:

```java
class NonSpringMain {
    private static final Logger LOGGER = LoggerFactory.getLogger(NonSpringMain.class);

    public static void main(String[] args) {
        OurService ourService = new LoggingOurService(new OurServiceImpl());

        String result = ourService.doSomething();

        LOGGER.info("Result: '{}'", result);
    }
}
```

We just created a new `LoggingOurService` and passed a new `OurServiceImpl` via the constructor.

This setup prints:

```
de.qaware.blog.decorator.decorator.impl.LoggingOurService - doSomething() called
de.qaware.blog.decorator.decorator.NonSpringMain - Result: 'something'
```

the "doSomething() called" log message is from `LoggingOurService`, the result is returned from the delegate `OurServiceImpl`.

So far, so good. Now let's get this setup running in Spring. I'm using Spring Boot here, but all this stuff is also applicable to plain Spring.

Our first attempt looks like this:

```java
@Configuration
class OurConfiguration {
    @Bean
    public OurService ourServiceDelegate() {
        return new OurServiceImpl();
    }

    @Bean
    public OurService loggingOurService(OurService delegate) {
        return new LoggingOurService(delegate);
    }
}
```

This defines two beans, first the delegate and second the decorator. The decorator has a dependency on the delegate.

Now we have to use that bean somewhere. We'll use a `CommandLineRunner` which gets executed when the application is started:

```java
@Component
class Runner implements CommandLineRunner {
    private static final Logger LOGGER = LoggerFactory.getLogger(Runner.class);

    private final OurService ourService;

    Runner(OurService ourService) {
        this.ourService = ourService;
    }

    @Override
    public void run(String... args) throws Exception {
        LOGGER.info("Class of ourService: {}", ourService.getClass().getName());

        String result = ourService.doSomething();

        LOGGER.info("Result: '{}'", result);
    }
}
```

When we start that application, Spring fails with:

```
Parameter 0 of constructor in de.qaware.blog.decorator.decorator.Runner required a single bean, but 2 were found:
	- ourServiceDelegate: defined by method 'ourServiceDelegate' in class path resource [de/qaware/blog/decorator/decorator/OurConfiguration.class]
	- loggingOurService: defined by method 'loggingOurService' in class path resource [de/qaware/blog/decorator/decorator/OurConfiguration.class]
```

Spring is complaining that it found 2 beans and now it's confused which one to inject into the `Runner`.

One way to fix that is to mark the `loggingOurService` bean method as `@Primary`:

```java
@Configuration
class OurConfiguration {
    @Bean
    public OurServiceImpl ourServiceDelegate() {
        return new OurServiceImpl();
    }

    @Bean
    @Primary
    public OurService loggingOurService(OurServiceImpl delegate) {
        return new LoggingOurService(delegate);
    }
}
```

Now Spring knows that if there are multiple beans of that type (`OurService`), it has to pick the one marked as `@Primary`.

Another option is to use `@Qualifier`:

```java
@Configuration
class OurConfiguration {
    @Bean
    public OurServiceImpl ourServiceDelegate() {
        return new OurServiceImpl();
    }

    @Bean
    @Qualifier("logging")
    public OurService loggingOurService(OurServiceImpl delegate) {
        return new LoggingOurService(delegate);
    }
}
```

but now you have to change all the injection points to use the qualifier, too:

```java
class Runner implements CommandLineRunner {
// ...
    Runner(@Qualifier("logging") OurService ourService) {
        this.ourService = ourService;
    }
// ...
}
```

Spring still finds two beans, but as the injection point in the `Runner` class has the same qualifier as the `@Bean` method, Spring knows which
bean to pick.

That's the story so far if you have control over the `@Bean` methods, as you'll either have to add `@Primary` or `@Qualifier` to them.
But what should we do if we don't have the ability to change those methods, for example if you try to decorate beans which are created by an autoconfiguration?
There must be a way in the mighty Spring framework?

## Decorating Spring beans if you have no control over the bean creation

And of course, there is. The concept is called [`BeanPostProcessor`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/beans/factory/config/BeanPostProcessor.html),
which is an interface we'll have to implement. The processor is called for each Spring bean in the context and has the ability to replace the bean
with some other bean.

First, let's take a look at our configuration:

```java
@Configuration
class OurConfiguration {
    @Bean
    public OurService ourServiceDelegate() {
        return new OurServiceImpl();
    }

    @Bean
    public LoggingOurServiceBeanProcessor beanProcessor() {
        return new LoggingOurServiceBeanProcessor();
    }
}
```

This configuration class just creates the delegate service and a bean processor. It does **not** create the `LoggingOurService`. 

The bean processor is where the magic happens:

```java
// This bean processor gets called for every bean in the context
class LoggingOurServiceBeanProcessor implements BeanPostProcessor {
    private static final Logger LOGGER = LoggerFactory.getLogger(LoggingOurServiceBeanProcessor.class);

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        if (!(bean instanceof OurService)) {
            // We are only interested in OurService beans
            return bean;
        }

        if (bean instanceof LoggingOurService) {
            // The bean has already been decorated
            return bean;
        }

        // The bean is of type OurService and is no LoggingOurService already -> Wrap LoggingOurService around it
        // Spring will then replace the original bean with the return type of this method
        LOGGER.info("Decorating bean of type {}", bean.getClass().getName());
        return new LoggingOurService((OurService) bean);
    }
}
```

The `postProcessAfterInitialization` gets called for **every** bean in the Spring context.

The first `if` statement returns early if the bean is not of type `OurService`.

The second `if` statement returns early if the bean is already of type `LoggingOurService`, as we don't want to wrap a `LoggingOurService` in another `LoggingOurService`.

The last line wraps a new `LoggingOurService` around the bean (which is a `OurService`) and returns it. Spring now replaces the original bean (the one in the `bean` argument, type `OurService`) with
the one returned from this method (type `LoggingOurService`).

Let's run our application:

```
guration6$LoggingOurServiceBeanProcessor : Decorating bean of type de.qaware.blog.decorator.decorator.impl.OurServiceImpl
d.q.blog.decorator.decorator.Runner      : Class of ourService: de.qaware.blog.decorator.decorator.impl.LoggingOurService
d.q.b.d.d.impl.LoggingOurService         : doSomething() called
d.q.blog.decorator.decorator.Runner      : Result: 'something'
```

As you see from the first log message, our bean processor has been called and decorated a bean of type `OurServiceImpl`.

When the bean is used in the `Runner`, it's no longer of type `OurServiceImpl`, but of type `LoggingOurService` because that's the
bean the post processor has created.

And that's how you decorate beans for which you can't change the `@Bean` methods.

----

## Related posts

* [Generating OpenApi Specification From Spring Boot]({{< relref "/posts/openapi-for-spring-generator.md" >}})
* [WireSpock - Testing REST Service Client Components With Spock And WireMock]({{< relref "/posts/wirespock.md" >}})


*The banner image is from [Wikipedia](https://en.wikipedia.org/wiki/Decorator_pattern#/media/File:UML2_Decorator_Pattern.png).*

[^1]: Gamma, Erich; et al. (1995). Design Patterns. Reading, MA: Addison-Wesley Publishing Co, Inc. pp. 175ff. ISBN 0-201-63361-2.
