---
title: "SonarQube with JaCoCo in multi-module Maven project"
date: 2020-12-22
draft: false 
author: "[Andreas Grub](https://github.com/neiser)"
type: "post"
image: "2020-12-08-sonarqube-jacoco-title.png"
tags: ["SonarQube", "JaCoCo", "Coverage", "Maven", "Analysis", "Code Quality"]
aliases:
    - /posts/2020-12-22-sonarqube-and-jacoco/
summary: How to set up a SonarQube code analysis using the Sonar Maven Plugin including code coverage with the JaCoCo Maven plugin.
---

This post explains in detail how to set up a SonarQube code analysis using the [Sonar Maven Plugin][SonarMavenPlugin]
including code coverage with the [JaCoCo Maven plugin][JaCoCoPlugin].

Although the setup is already documented within [this SonarSource Community post][SonarSourceDoc], this post highlights
pitfalls and enables you to adapt any Maven module structure such that it correctly measures and imports code coverage
into your SonarQube analysis. This post focuses on using the official documentation from JaCoCo and Sonar. 
There are alternatives such as using the `merge` goal of the JaCoCo plugin, which are out of scope of this post.

As SonarQube has rightfully deprecated the support of the internal JaCoCo binary format, this post focuses on importing
the XML format into SonarQube.

A completely worked out example can be found in the [OpenApi Generator for Spring library][OpenApiLib], which inspired this post.

[SonarMavenPlugin]: https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-maven/

[JaCoCoPlugin]: https://www.eclemma.org/jacoco/trunk/doc/maven.html

[SonarSourceDoc]: https://community.sonarsource.com/t/coverage-test-data-importing-jacoco-coverage-report-in-xml-format/12151

[OpenApiLib]: https://github.com/qaware/openapi-generator-for-spring

## Maven module structure

The following Maven project module structure is assumed in the following:

A top-level reactor `pom.xml` including three `pom.xml`'s for the modules `module-a`, `module-b`, and `module-c`:

```
/pom.xml
/module-a/pom.xml
/module-b/pom.xml
/module-c/pom.xml
```

The reactor `pom.xml` looks like this:

```xml
<project>
    <groupId>de.qaware.example</groupId>
    <artifactId>reactor</artifactId>
    <packaging>pom</packaging>

    <modules>
        <module>module-a</module>
        <module>module-b</module>
        <module>module-c</module>
    </modules>
    <!-- ... more XML, like plugin management ... -->
</project>
```

And for now, the module `pom.xml`'s may all look the same:

```xml
<project>
    <groupId>de.qaware.example</groupId>
    <artifactId>module-a</artifactId> <!-- or module-b, module-c -->
    <packaging>jar</packaging>

    <!-- ... more XML, like dependencies ... -->
</project>
```

Later on, we assume the dependency relation of the modules as `module-c ⇾ module-b ⇾ module-a`, that means `module-c`
directly depends on `module-b` and transitively depends on `module-a`.

## Setting up the Maven build

We go through the following steps in detail now:

1. Set up the JaCoCo agent to generate `target/jacoco.exec`
   binary files whenever tests are executed within a Maven build.

1. Generate the aggregate JaCoCo XML report in `target/site/jacoco-aggregate/jacoco.xml` using an appropriate module.

1. Configure the SonarQube analysis to pick up the JaCoCo XML report.

### Step 1: Set up JaCoCo agent

Add the following plugin entry to your build in the reactor `pom.xml`:

```xml
<project>
    <!-- ... other XML ... -->
    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.jacoco</groupId>
                    <artifactId>jacoco-maven-plugin</artifactId>
                    <version>0.8.6</version>
                </plugin>
            </plugins>
        </pluginManagement>
        <plugins>
            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <id>prepare-agent</id>
                        <goals>
                            <goal>prepare-agent</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

This lets the JaCoCo agent run in any module of your project. You can disable this for certain modules by binding
the execution to `<phase>none</phase>`
or by specifying the above plugin entry only for some modules.

The `prepare-agent` goal modifies the `argLine` configuration to instrument the `maven-surefire-plugin`, which runs the
tests. [See the documentation][JaCoCoPrepareAgent] if you need to modify command line arguments.

Running `mvn package` now should output something like

```
[INFO] --- jacoco-maven-plugin:0.8.6:prepare-agent (prepare-agent) @ module-a ---
[INFO] argLine set to ...
```

for each subproject. Also, it should make `jacoco.exec` files appear inside the `target` output folder of each
subproject where tests are run. You can also open them in IntelliJ IDEA via Run ⇾ "Show Coverage Data..."
and verify that they correctly contain coverage data for your project.

[JaCoCoPrepareAgent]: https://www.eclemma.org/jacoco/trunk/doc/prepare-agent-mojo.html

### Step 2: Generate the aggregate JaCoCo XML report

We use the [`report-aggregate` goal][JaCoCoReportAggregate]
to generate the XML report from the `jacoco.exec` binary files. This goal picks up the `jacoco.exec` binary files and
generates browsable HTML and parsable XML report in `target/site/jacoco-aggregate`.

Using the `report-aggregate` goal has the following caveats:

* The goal only includes source and coverage information from **direct**
  dependencies. That means, if your current dependency structure looks like `module-c ⇾ module-b ⇾ module-a`
  and if you want to add the `report-aggregate` goal to `module-c`, you need to explicitly add the
  dependency `module-c ⇾ module-a`
  into the `module-c`'s `pom.xml` (see also example below). This is even necessary if `module-a` only contains relevant
  source files but does not run any tests.

* [As documented][JaCoCoReportAggregate], if the direct dependency has `<scope>test</scope>`, only the execution data
  (the `jacoco.exec` file) is considered when generating the XML report. There are no sources imported, which could to
  an incomplete coverage report.

* The goal needs to run later than any test execution, so it might be worthwhile to bind to goal to the phase `verify`.

An example how to set up the `report-aggregate` goal for `module-c`, which may run additional integration tests for the other
modules as well, looks like this:

```xml
<project>
    <dependencies>
        <dependency>
            <!-- Explicitly include module-a for JaCoCo's report-aggregate goal, 
                 although it's already transitively included by module-b, 
                 see explanation above -->
            <dependency>
                <groupId>de.qaware.example</groupId>
                <artifactId>module-a</artifactId>
            </dependency>
            <dependency>
                <groupId>de.qaware.example</groupId>
                <artifactId>module-b</artifactId>
            </dependency>
        </dependency>
    </dependencies>
    <!-- ... other XML ... -->
    <build>
        <plugins>
            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <id>report-aggregate</id>
                        <phase>verify</phase>
                        <goals>
                            <goal>report-aggregate</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

Running `mvn verify` now should output the following when `module-c` is reached:

```
[INFO] --- jacoco-maven-plugin:0.8.6:report-aggregate (report-aggregate) @ module-c ---
[INFO] Loading execution data file .../module-a/target/jacoco.exec
[INFO] Loading execution data file .../module-b/target/jacoco.exec
[INFO] Loading execution data file .../module-c/target/jacoco.exec
[INFO] Analyzed bundle 'module-a' with ... classes
[INFO] Analyzed bundle 'module-b' with ... classes
[INFO] Analyzed bundle 'module-c' with ... classes
```

Make sure that the above output states that the execution data `jacoco.exec` are all loaded and that classes from all 
relevant modules are considered. You can now open `module-c/target/site/jacoco-aggregate/index.html` in your browser and verify
that the report contains all coverage and source files you would expect. 

If the JaCoCo report does not contain all coverage data you would expect, you probably have
forgotten to add another direct dependency to the module running the `report-aggregate` goal 
(here `module-c`), or the JaCoCo agent was not properly set up.

Note that `module-c` may play two distinct roles in the above example: 

* Running additional integration for code contained in other modules, 
  such as `module-a` or `module-b`.

* Generating the JaCoCo XML report once all tests have run. 
   
[The official JaCoCo documentation][JaCoCoWiki] even recommends 
adding a separate module, depending on all other module of the project, 
just to aggregate the XML report, but I think 
it is more elegant to bind to the `verify` phase instead and 
making sure the tests run earlier than this phase.

[JaCoCoReportAggregate]: https://www.eclemma.org/jacoco/trunk/doc/report-aggregate-mojo.html
[JaCoCoWiki]: https://github.com/jacoco/jacoco/wiki/MavenMultiModule

### Step 3: Configure the SonarQube analysis

When running inside your CI, the [Sonar Maven Plugin][SonarMavenPlugin] is usually run explicitly from the command line
as follows:

```
mvn verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar
```

It runs the goal `sonar` after the `verify` phase has completed. The Sonar Maven Plugin (more precisely,
the [Sonar JaCoCo analysis plugin][SonarJaCoCoPlugin]) picks up coverage if it finds a JaCoCo XML report specified by
the property `sonar.coverage.jacoco.xmlReportPaths` when it analyzes a sub-project, such as `module-a`.

The crucial step is to present the aggregated JaCoCo XML report everytime the Sonar analysis runs in any module.
This can be achieved by adding the following property to the reactor `pom.xml`, assuming the `module` has run
the `report-aggregate` goal:

```xml
<project>
    <groupId>de.qaware.example</groupId>
    <artifactId>reactor</artifactId>
    <packaging>pom</packaging>

    <!-- Point the Sonar Qube Plugin always to the same aggregated JaCoCo report -->
    <sonar.coverage.jacoco.xmlReportPaths>
        ${project.basedir}/../module-c/target/site/jacoco-aggregate/jacoco.xml
    </sonar.coverage.jacoco.xmlReportPaths>

    <modules>
        <module>module-a</module>
        <module>module-b</module>
        <module>module-c</module>
    </modules>
    <!-- ... more XML, like plugin management ... -->
</project>
```

The `xmlReportPaths` is correct in any module as long as you don't have any deep nesting of maven modules. The
property `project.basedir` resolves to the sub-directory for modules, and the `../module-c` then relatively points
to the module directory containing the JaCoCo report.

If you do have deeper nesting levels because you like your maven modules to be well-structured, you may add more as
follows:

```xml
<sonar.coverage.jacoco.xmlReportPaths>
    ${project.basedir}/../module-c/target/site/jacoco-aggregate/jacoco.xml,      <!-- don't miss the comma! -->
    ${project.basedir}/../../module-c/target/site/jacoco-aggregate/jacoco.xml,   <!-- don't miss the comma! -->
    ${project.basedir}/../../../module-c/target/site/jacoco-aggregate/jacoco.xml <!-- no comma -->
</sonar.coverage.jacoco.xmlReportPaths>
```

The Sonar Maven Plugin does not output a warning if at least one path of the comma-separated lists points to an existing
JaCoCo maven report.

The [official documentation][SonarSourceDoc] recommends adding the above `xmlReportPaths` property to any module,
but configuring this once in the reactor pom using the relative path trick appears more elegant.

Now, when running the Sonar Maven Plugin with `mvn verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar`, one
should see the following output whenever a module is analyzed:

```
[INFO] --- sonar-maven-plugin:3.7.0.1746:sonar (default-cli) @ reactor ---
...
[INFO] ------------- Run sensors on module module-a
...
[INFO] Sensor JaCoCo XML Report Importer [jacoco]
[INFO] 1/1 source files have been analyzed
[INFO] Importing 1 report(s). Turn your logs in debug mode in order to see the exhaustive list.
...
... similar output for module-b and module-c ...
```

If you have specified more than one `xmlReportPaths`, you encounter an output line

```
...
[INFO] Coverage report doesn't exist for pattern: ...
...
```

This is ok as long as it outputs that one report has been imported.

At this point, you should now enjoy a SonarQube analysis including a complete JaCoCo coverage report. Congratulations!

[SonarJaCoCoPlugin]: https://docs.sonarqube.org/display/PLUG/JaCoCo+Plugin

## Additional tweaks

### Skip SonarQube analysis for "integration test" module

If you do have a module which only runs integration tests at the very end of your Maven build (which also runs
the `jacoco-aggregate` goal), you may set the property `sonar.skip` to `true` for that module. In the above example,
that could be `module-c`:

```xml
<project>
    <groupId>de.qaware.example</groupId>
    <artifactId>module-c</artifactId> <!-- or module-b, module-c -->
    <packaging>jar</packaging>

    <properties>
        <sonar.skip>true</sonar.skip>
    </properties>

    <!-- ... more XML, like dependencies ... -->
</project>
```

### Suppress warning when analyzing reactor module

As the Sonar Maven Plugin also runs on the reactor module, it expects an XML report to be present (although nothing is
to be analyzed). To suppress this warning, add another path to `xmlReportPaths` as follows:

```xml
<sonar.coverage.jacoco.xmlReportPaths>
    ${project.basedir}/../module-c/target/site/jacoco-aggregate/jacoco.xml,  <!-- don't miss the comma! -->
    <!-- Only added to suppress warning during Sonar analysis -->
    ${project.basedir}/module-c/target/site/jacoco-aggregate/jacoco.xml      <!-- no comma -->
</sonar.coverage.jacoco.xmlReportPaths>
```

### Running the analysis as a GitHub workflow

The follow GitHub workflow action runs the analysis and uploads it to [sonarcloud.io](https://sonarcloud.io). You need
to set up a corresponding Sonar project for your code on GitHub and add the `SONAR_TOKEN` as a GitHub secret as well.
Follow the tutorial for "GitHub Actions" in your Sonar project below Administration ⇾ Analysis Method.

```yaml
# This workflow will build a Java project with Maven including tests
# Also runs SonarQube analysis
# For more information see: https://help.github.com/actions/language-and-framework-guides/building-and-testing-java-with-maven

name: build

on:
  push:
    branches:
      - master
  pull_request:
    types: [ opened, synchronize, reopened ]

jobs:
  build-on-linux:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0  # Shallow clones should be disabled for a better relevancy of analysis
      - name: Set up JDK 11
        uses: actions/setup-java@v1
        with:
          java-version: 11
      - name: Cache SonarCloud packages
        uses: actions/cache@v1
        with:
          path: ~/.sonar/cache
          key: ${{ runner.os }}-sonar
          restore-keys: ${{ runner.os }}-sonar
      - name: Cache Maven packages
        uses: actions/cache@v2
        with:
          path: ~/.m2
          key: ${{ runner.os }}-m2-${{ hashFiles('**/pom.xml') }}
          restore-keys: ${{ runner.os }}-m2
      - name: Build with Maven
        run: mvn -B verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} # Needed to get PR information, if any
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

----

## Related posts

* [Breaking Your Build On SonarQube Quality Gate Failure]({{< relref "/posts/sonar-qube-build-breaker.md" >}})
* ["I Know It When I See It" - Perceptions Of Code Quality]({{< relref "/posts/i-know-it-when-i-see-it.md" >}})
* ["I Know It When I See It": Perceptions Of Code Quality (Part 2)]({{< relref "/posts/i-know-it-when-i-see-it-2.md" >}})
