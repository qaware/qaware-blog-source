---
title: "From Monolith to Cloud: Automating Your Migration Journey"
date: 2025-08-08T15:43:46+02:00
lastmod: 2025-08-08T15:43:46+02:00
draft: true
type: post
author: "[Markus Zimmermann](https://github.com/markuszm/)"
image: "cloud-migration-tooling/cover.png"
tags: ["Cloud", "Migration", "Architecture", "Open Source", "Analysis"]
summary: "An overview of how Konveyor and OpenRewrite enable automated cloud migration."
---

## Introduction - Navigating Cloud Migrations

Migrating applications to the cloud is a complex endeavor with substantial technical and organizational implications. It requires assessing cloud readiness, selecting the right migration strategy, and adapting code where necessary. Automated tools now play a key role in streamlining both analysis and transformation.

### Focus Of This Article

This article presents two open-source tools, the CNCF project [Konveyor](https://konveyor.io/) and [OpenRewrite](https://docs.openrewrite.org/) by Moderne, that aid in planning and executing Java-based enterprise application migrations. We cover both strategic considerations and technical workflows down to code-level adjustments.

### Why It Matters

Cloud platforms promise scalability, resilience, automation, and cost control. Legacy systems, however, are often monolithic and tightly coupled to specific infrastructures. Successful migration demands tailored strategies; neither simple “lift and shift” nor full rewrites are always optimal.

### Keys to Success

Effective projects balance cost, functionality, and modernization. They rely on interdisciplinary teams, clear communication, and tools that deliver transparent analyses and reproducible changes. Konveyor helps evaluate migration needs, while OpenRewrite automates code updates—addressing common issues like classpath conflicts, logging frameworks, configuration, and legacy servlet containers.

## Challenges – Making Complexity Visible

Cloud migration is not merely a technical exercise; it is an architectural decision with far-reaching consequences. It affects source code, build processes, infrastructure dependencies, deployment strategies, and security requirements. Common technical obstacles include:

* Tightly coupled components without well-defined interfaces
* Hardcoded configurations that hinder environment changes
* Direct use of infrastructure resources such as local file systems or databases
* Outdated frameworks or unsupported libraries

{{< figure figcaption="Typical obstacles in cloud migration" >}}
  {{< img src="/images/cloud-migration-tooling/typical-obstacles.png" alt="Typical obstacles in cloud migration include tightly coupled components, hardcoded configurations, and outdated technologies—all of which must be systematically identified and addressed." >}}
{{< /figure >}}

Another challenge is the lack of a consistent testing strategy. Applications without reproducible builds, automated tests, or Infrastructure-as-Code are difficult to integrate into automated CI/CD pipelines—yet such pipelines are essential for cloud-native operations.

## Assessing Cloud Readiness with Konveyor

A central concept we use at QAware in cloud readiness assessments is categorizing applications into three groups:

* **Cloud-native**: Designed for the cloud from the ground up. These applications use containers, are stateless, horizontally scalable, and easily automated.
* **Cloud-friendly**: Exhibit some cloud-native characteristics (e.g., externalized configuration, modular architecture) but do not fully meet all criteria.
* **Cloud-alien**: Highly monolithic or technologically outdated applications with minimal decoupling and complex dependencies.

{{< figure figcaption="Cloud Readiness Categories" >}}
  {{< img src="/images/cloud-migration-tooling/readiness-levels.png" alt="Cloud Readiness Categories" >}}
{{< /figure >}}

Konveyor uses a similar classification that is generated automatically and transparently from its analysis results. Key checks include:

* Use of outdated or proprietary frameworks
* Reliance on the file system or local state
* Direct database access without abstraction
* Absence of logging and monitoring interfaces

### Overview of the Konveyor project 

The Konveyor project has three key components:

1. A deployable web application called [Konveyor Hub](https://konveyor.io/docs/konveyor/) for migration planning composed of several modules:

* **Application Inventory**: Serves as the portfolio management system. It enables you to catalog applications, associate them with business services, define interdependencies, and add metadata via an extensible tagging model.

* **Assessment Module** (Pathfinder): A questionnaire-based tool embedded within Tackle that evaluates application suitability for containerization (e.g., Kubernetes). It identifies risks, assesses readiness, and produces reports that help drive an adoption plan.

* **Analysis Module**: Analyzes source code and dependencies using predefined or custom rules. The analysis provides a detailed report outlining what needs to be addressed to migrate to Kubernetes and offers effort estimations.

2. A CLI tool called [Kantra](https://github.com/konveyor/kantra) that encapsulates the analysis capability into a standalone command-line interface. It can be used to analyze source code and dependencies, producing reports that highlight migration blockers and provide actionable insights.

3. A new component to include AI capabilities called [Konveyor AI](https://github.com/konveyor/kai). It is using the analysis results and provides automatic fixes using Generative AI. This component is still evolving, but it is very promising.

Konveyor’s analysis is based on static code analysis and heuristics, detecting elements such as JDBC statements, web frameworks, hardcoded paths, or `sun.*` classes. The output can be produced in HTML or JSON and integrated directly into CI/CD pipelines.

### Example: Analyzing a Java Application with the Konveyor CLI Kantra 

To analyze a Java application using the Konveyor CLI tool Kantra, you can follow these steps:

**1. Install the Kantra CLI by downloading it from the [Kantra releases page](https://github.com/konveyor/kantra/releases).**

**2. Once installed, you can run the following command to analyze your Java application for cloud readiness:**

```bash
kantra \
  analyze \
  -i /path/to/your/java/application \
  -o ../out \
  --mode source-only \
  --target cloud-readiness 
```

**3. Review the generated report to identify any migration blockers and actionable insights:**

The report is typically generated in HTML format and can be found in the specified output directory (`../out` in this example).

{{< figure figcaption="Example report generated from the analysis" >}}
{{< img src="/images/cloud-migration-tooling/initial-konveyor-analysis.png" alt="Image of the generated report from the Kantra analysis" >}}
{{< /figure >}}

The report can be used to assess the cloud readiness of your application, identify potential migration blockers, and provide actionable insights for refactoring or modernization efforts.

## Migration Strategies – Three Paths to the Cloud

Based on the analysis results, teams can select a migration strategy that fits their application landscape and business goals.
In practice, three core migration strategies have emerged, each with distinct goals, efforts, and risks.

{{< figure figcaption="Cloud Migration Strategies" >}}
  {{< img src="/images/cloud-migration-tooling/migration-strategies.png" alt="Cloud Migration Strategies" >}}
{{< /figure >}}

### Rehosting (“Lift & Shift”)

The application is moved to the cloud without modifications. This approach is fast and requires minimal development effort but delivers no structural improvements. It is often used for short-term capacity needs or infrastructure transitions (e.g., data center shutdowns). Technically, this can mean migrating VMs 1:1 to IaaS offerings like AWS EC2 or Azure VM, preserving most existing CI/CD pipelines. Downsides include limited scalability, restricted observability, and modest cost benefits—often leading to “Cloud in Name Only” scenarios.

### Refactoring

The existing code is adapted to cloud-native paradigms, typically involving:

* Modularization and decoupling
* Containerization (e.g., Docker)
* Externalizing state (sessions, temp files)
* Using environment variables for configuration
* Leveraging cloud services (e.g., S3, RDS, Kafka)

Refactoring is common for functionally stable but technically outdated applications. It enables debt reduction, observability (Prometheus, Grafana, OpenTelemetry), resilient Kubernetes deployments, and future-proof scaling. Tools like OpenRewrite facilitate this through rule-based, reproducible code changes.

### Rebuilding

A complete rewrite based on modern cloud architectures. This is justified when:

* The current application is unmaintainable
* Business logic has fundamentally changed
* New business models (API economy, platform services) are the focus

Typical technologies include microservices, serverless components (AWS Lambda, Azure Functions), and event-driven designs. Rebuilding is costly but forward-looking, with ROI tied to innovation potential.

### Hybrid Approaches

Most real-world migrations blend strategies—for example, refactoring the transactional core while rehosting auxiliary modules, combining quick ROI with long-term modernization. Successful migration balances business continuity with technical renewal.

## OpenRewrite – Automated Code Transformation

While Konveyor focuses on analysis and strategy planning, OpenRewrite takes the next step: automated code modifications based on declarative rules.

At its core, OpenRewrite parses code into a full Abstract Syntax Tree (AST), enabling semantically precise transformations. The transformation logic is defined in modular, reusable, and versionable recipes.

### Common Transformation Recipes

OpenRewrite provides a rich set of community recipes for common migration tasks, such as:

* Replacing outdated libraries
* Migrating Spring Boot 1.x → 2.x → 3.x
* Renaming methods, packages, or classes
* Adding security annotations or upgrading dependencies

### Example: Upgrading Spring Boot from 2.x to 3.x

Using Maven, it is easy to integrate OpenRewrite into your build process and apply a specific recipe.

The following example demonstrates how to upgrade a Spring Boot application from version 2.x to 3.4, which includes significant changes such as Jakarta EE namespace migration.

**1. Add the following plugin configuration to your `pom.xml` under `<plugins>`**

```xml
      <plugin>
        <groupId>org.openrewrite.maven</groupId>
        <artifactId>rewrite-maven-plugin</artifactId>
        <version>6.15.0</version> <!-- Update to latest version -->
        <configuration>
          <activeRecipes>
            <recipe>org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_4</recipe>
          </activeRecipes>
          <activeStyles>
            <style>org.openrewrite.java.SpringFormat</style>
          </activeStyles>
        </configuration>
        <dependencies>
          <dependency>
            <groupId>org.openrewrite.recipe</groupId>
            <artifactId>rewrite-spring</artifactId>
            <version>6.11.1</version> <!-- Update to latest version -->
          </dependency>
        </dependencies>
      </plugin>
```

**2. Run the Maven Rewrite Plugin to execute the upgrade:**

```bash
mvn rewrite:run
```
---

### Creating Custom Rules

## Extending OpenRewrite with Custom Recipes

OpenRewrite lets you go beyond community rules by authoring your own recipes. You can do this declaratively with YAML (compose existing building blocks) or imperatively with Java (full control over AST‑level transformations). A pragmatic middle path is to start from Refaster‑style templates to scaffold simple Java recipes quickly.

### Declarative (YAML)

**When to use:** composition, quick wins, and centrally managed policy roll‑outs.

**Example**

```yaml
# Compose existing recipes to roll out standards
name: com.company.platform.baseline
recipeList:
  - org.openrewrite.java.dependencies.UpgradeDependencyVersion:
      groupId: org.springframework.boot
      artifactId: spring-boot-starter
      newVersion: 3.3.x
  - org.openrewrite.java.RemoveUnusedImports
  - org.openrewrite.java.format.AutoFormat
```

**Pros**

* Compose prebuilt recipes (dependency upgrades, search/replace, formatting)
* Fast to author and easy to review in PRs
* Versionable alongside code; simple to parameterize

**Cons**

* Limited to what existing recipes expose
* Complex, cross‑cutting refactorings may require Java

---

### Imperative (Java)

**When to use:** complex, context‑aware refactorings that require AST access.

**Minimal Recipe Skeleton**

```java
@DocumentExample
public class ReplaceSystemOutWithSlf4j extends Recipe {
  @Override public String getDisplayName() { return "Use SLF4J instead of System.out"; }
  @Override public TreeVisitor<?, ExecutionContext> getVisitor() {
    return new JavaIsoVisitor<>() {
      @Override public J.MethodInvocation visitMethodInvocation(J.MethodInvocation m, ExecutionContext ctx) {
        m = super.visitMethodInvocation(m, ctx);
        if (m.getSimpleName().equals("println") &&
            TypeUtils.isOfClassType(m.getSelect().getType(), "java.io.PrintStream")) {
          return m.withName(m.getName().withSimpleName("info"))
                  .withSelect(JavaParser.parseExpression("logger"));
        }
        return m;
      }
    }; }
}
```

**Pros**

* Full flexibility for sophisticated transformations
* Can encode company rules, security hardening, and architecture guardrails

**Cons**

* Higher effort; requires Java/AST know‑how

---

### Refaster Templates (Middle Ground)

Use Refaster‑style before/after patterns to generate Java visitors.

**Example**

```java
import com.google.errorprone.refaster.annotation.AfterTemplate;
import com.google.errorprone.refaster.annotation.BeforeTemplate;

@RecipeDescriptor(
    name = "Prefer StringIsEmpty",
    description = "Prefer String#isEmpty() over alternatives that check the string's length."
)
public class StringIsEmpty {
  @BeforeTemplate
  boolean equalsEmptyString(String string) {
    return string.equals("");
  }

  @BeforeTemplate
  boolean lengthEquals0(String string) {
    return string.length() == 0;
  }

  @AfterTemplate
  boolean optimizedMethod(String string) {
    return string.isEmpty();
  }
}
```

**When to use**

* Straightforward API migrations (method rename, signature change)
* Wide‑spread call‑site edits where a template expresses the intent

**Benefits**

* Faster than hand‑crafting visitors from scratch
* Still produces deterministic, reviewable changes

---

## The Potential of LLMs in Cloud Migration: Complementary Intelligence

With the rise of powerful Large Language Models (LLMs) like GPT‑5 or Claude 4, the question arises: how can these technologies contribute to cloud migration? Unlike rule‑based tools such as OpenRewrite, LLMs operate probabilistically—leveraging statistical language models trained on vast code and text corpora.

### Potential Applications

Promising use cases for LLMs in migration include:

* **Code Analysis**: Detecting code smells, outdated patterns, or security vulnerabilities in context, generating improvement suggestions with textual explanations.
* **Refactoring Suggestions**: Producing semantically meaningful restructurings from prompts or pull requests—often including corresponding tests.
* **Configuration File Migration**: Updating YAML, XML, Helm charts, or Dockerfiles for new versions or target environments.
* **CI/CD Definition Generation**: Creating Jenkinsfiles, GitHub Actions, or GitLab CI configurations from natural language descriptions.
* **Documentation**: Writing technical explanations, architecture diagram descriptions, or changelogs automatically from code.

### Advantages

The strengths of LLMs lie in their:

* **Flexibility**: Understand semantic relationships across frameworks and programming languages.
* **Assistance**: Help developers explore unfamiliar technologies or modernize legacy code.
* **Rapid Prototyping**: Provide quick initial migration recommendations through conversational interfaces.

### Limitations

However, LLMs also have significant limitations:

* **Non‑Deterministic**: Results are not guaranteed to be repeatable—an issue for production CI/CD pipelines.
* **Black‑Box Nature**: Limited transparency into decision‑making and safety guarantees.
* **Prompt Dependency**: Quality and depth depend heavily on how the request is formulated.

### Outlook

Combined with rule‑based tools like OpenRewrite and analysis frameworks like Konveyor, LLMs could serve as a “creative complement” for:

* Identifying semantic patterns
* Generating custom rewrite recipes
* Automating pull request descriptions, migration documentation, and code comments

A hybrid solution where reproducibility is critical and contextual understanding are required, emerges as a promising approach. Konveyor is already exploring this direction with its Konveyor AI component, which integrates LLM capabilities into the migration process.

## Conclusion: Automation as the Key to Scalable Migration

Migrating to the cloud demands strong architectural understanding, high code quality, and precise planning. It is rarely a linear process—instead, it is an iterative cycle of analysis, decision-making, adaptation, and validation. This is where open-source tools like Konveyor and OpenRewrite demonstrate their full value:

* **Konveyor** provides structured, reproducible analysis to guide planning and decision-making—from assessing cloud readiness to detecting technologies and evaluating risks.
* **OpenRewrite** applies rule-based, semantically accurate refactorings, enabling traceable, CI/CD-compatible code transformations with minimal manual effort.

Together, they form a complementary toolset: analysis and execution, strategy and implementation, transparency and automation. For organizations aiming to future-proof their software landscapes, these tools offer a scalable, open, and well-integrated path to the cloud. Free of black-box behavior, but with clear rules, high reusability, and growing community support.

But, the future lies in the combination: Konveyor and OpenRewrite for structured migration, LLMs for creative enhancements, embedded into DevOps processes and cloud-native principles. Migration thus becomes not a one-time effort, but a continuous modernization process - scalable, traceable, and automated.