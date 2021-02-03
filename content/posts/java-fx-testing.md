---
title: "GUI Tests for JavaFX"
date: 2015-04-16T10:39:32+02:00
draft: false
author: Andreas Zitzelsberger
tags: [Testing, GUI, JavaFX, Java, JUnit]
aliases:
    - /posts/2015-04-16-java-fx-testing/
summary: This article summarizes my experiences when setting up UI tests for a new JavaFX application at QAware.
---
This article summarizes my experiences when setting up UI tests for a new JavaFX application at QAware.

I had the following requirements for a JavaFX test framework:

* Free (as in beer) Software  with a permissive license
* Lean, pure Java framework
* Integration with  JUnit

Later on, the requirement to do headless tests was added. I will cover headless tests in a follow-up post.

A quick search reveals three contenders:

* TestFX: https://github.com/TestFX/TestFX
* JemmyFX: https://jemmy.java.net/
* MarvinFX: https://github.com/guigarage/MarvinFX

Of these three, MarvinFX seems dead. The last commit to MarvinFX was on May the 4th, 2013, almost two years ago, so I discarded that option.

There are several further possibilities such as Automaton and TestComplete. Test Complete is a full-blown GUI testing product and not a lean framework, and the Automaton developers recommend [TestFX for testing JavaFX](https://github.com/renatoathaydes/Automaton)).

# Testability restrictions in JavaFX
Before dealing with the test frameworks, let me mention that  JavaFX has two important issues that restrict testability. To fix them, both require modifications to the JavaFX platform.

## No lifecylce management on the JavaFX platform
JavaFX allows to start exactly one application exactly once within a JVM. That means:

* No parallel or sequential execution of UI tests within a JVM.
* Each test case must run within it's own JVM.

I'm not aware of any way to get around this restriction.

## No headless testing of JavaFX applications
The Oracle and OpenJDK desktop builds to not allow testing JavaFX applications without a physical display. I will show a way to get around this restriction in a follow-up post.

# TestFX
TestFX promises "Simple and clean testing for JavaFX". The [TestFX Getting Started Guide](https://github.com/TestFX/TestFX/wiki/Getting-started) provides a short primer on how to use TestFX. Currently, TestFX 4 is under active development.

TestFX is [available in Maven Central](http://mvnrepository.com/artifact/org.loadui/testFx), so integration is just a Maven dependency away.

To create a TestFX GUI test, you have to extend the GuiTest class:

```java
public class SomeGuiTest extends GuiTest {

    @Override
    protected Parent getRootNode() {
        FXMLLoader fxmlLoader = new FXMLLoader();
        try (InputStream inputStream = getClass()
                .getResourceAsStream(FXML_FILE)) {
            return fxmlLoader.load(inputStream);
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

}
```

You have to override a single method getRootNode(), which will create the node to test. In TestFX 4, currently in alpha state, the idiom is closer to the regular JavaFX application startup. The method to override has the signature void start(Stage stage).
As you can see, TestFX is geared towards testing GUI components of an application. This approach comes with two important caveats:

1. TestFX does not play nice with customized application startup. Application startup is commonly customized in non-trivial applications, for instance to startup DI containers such as Weld or Spring.
1. The JavaFX platform does not provide lifecycle management of the JavaFX toolkit. As of JavaFX 8, it is not possible to cleanly startup and shutdown JavaFX within a process. That means while it's nice to be able to easily test each GUI component separately, each of these test cases needs to run in it's own JVM.

There is a workaround for caveat #1:

```java
@Override
protected Parent getRootNode() {
    return null;
}

@Override
public void setupStage() throws Throwable {
    new Thread(() -> Application.launch(SomeApplication.class))
        .start();
}
```

Override the `setupStage()` method and startup your application manually. The result of the `getRootNode()` method is no longer used.

For the tests themselves, there is a nice and easy fluent API:

```java
@Test
public void test() throws Exception {
    click("#userNameTextField").type("user");
    click("#passwordTextField").type("password");
    click("#loginButton");

    // Wait for success with a 10s timeout
    waitUntil("#showLabel", is(visible()), 10);

    String text = ((Label) find("#showLabel")).getText();
    verifyThat(text, containsString("OK"));
}
```

I like especially that TestFX exposes the lookup by CSS selector functionality of JavaFX. This makes the creation of page objects superfluous in most cases.

TestFX creates screenshots upon test failures. Unfortunately, it also creates screenshots elsewhen, for example when using the `waitUntil()`  method. Combine that with the fact that the screenshot location is hard-coded to the current working directory, and the screenshot feature becomes annoying instead of useful.

# JemmyFX
JemmyFX is another JavaFX UI test library and part of the offical OpenJFX project. Since 2012,  it resides in the test branch of OpenJFX.

JemmyFX is not provided in binary form. To use JemmyFX, you have to checkout and compile the sources yourself:

* For [JavaFX 8](http://hg.openjdk.java.net/openjfx/8/master/tests/)
* For [JavaFX 2.2.2] (http://hg.openjdk.java.net/openjfx/2.2.2/master/tests/)

The [Jemmy web site](https://jemmy.java.net/) is in disrepair which raises doubts about the project's status. However, the test branch is still included in the newest OpenJFX versions and seems to be actively mainained at a low level.

The build produces quite a number of Jars. In total, 7 JARs are required to use JemmyFX:

* `GlassImage.jar`
* `GlassRobot.jar`
* `JemmyAWTInput.jar`
* `JemmyBrowser.jar`
* `JemmyCore.jar`
* `JemmySupport.jar`
* `JemmyFX.jar`

You can include these JARs in a Maven or Gradle build by installing them in your local repository or on a custom Nexus.

As soon as all that is done, JemmyFX is quite easy to use. You need to create a setup method that initalizes and launches your application:

```java
@BeforeClass
public static void setUp() throws Exception {
    new Thread(() -> Application.launch(LoginApplication.class))
      .start();
}
```

The test cases are somewhat more verbose than with TestFX:

```java
@Test
public void test() throws Exception {
 SceneDock scene = new SceneDock();

 // Create docks for the UI elements. Lookup by Id
 TextInputControlDock userNameDock =
  new TextInputControlDock(
   scene.asParent(),
   new ByID<>("userNameTextField"));
 TextInputControlDock passwordDock =
  new TextInputControlDock(
   scene.asParent(),
   new ByID<>("passwordTextField"));
 LabeledDock loginButtonDock =
  new LabeledDock(
   scene.asParent(),
   new ByID<>("loginButton"));

 userNameDock.type("jemand");
 passwordDock.mouse().click();

 passwordDock.type("geheim");
 passwordDock.mouse().click();

 loginButtonDock.mouse().click();

 LabeledDock showDock = new LabeledDock(
  scene.asParent(), new ByID<>("showLabel"));

 // Wait for success with the default
 // "wait for control" timeout
 showDock.environment().getWaiter(WAIT_CONTROL_TIMEOUT)
  .waitValue(true, showDock::isVisible);
}
```

JemmyFX requires docks to access each UI element. It offers a intuitive but non-fluent API to operate on these docks.
JemmyFX does not directly expose the JavaFX lookup by CSS selector functionality. You can work around this restriction by creating the docks using the exposed JavaFX UI controls:

```java
TextInputControlDock userNameDock = new TextInputControlDock(
 scene.environment(),
 (TextInputControl) scene.control()
  .lookup("#userNameTextField"));
```

# Conclusion
While JavaFX is a powerful and well-engineered GUI framework, it's testability is severely hampered. Once you get around the fundamental restrictions, both TestFX and JemmyFX provide the means to effectively test JavaFX applications.

At the moment, I'd use JemmyFX for a new project because of it's cleaner test case setup and the ability to do headless with Monocle. Also, I dislike abstract base classes used to provide tool-like functionality.
This recommendation will probably change when TestFX 4 is released.
