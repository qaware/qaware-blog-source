---
title: "Cloud Observability with Grafana and Spring Boot"
date: 2022-03-31T07:00:00+02:00 
lastmod: 2022-03-31T07:00:00+02:00 
author: "[Andreas Grub](https://github.com/neiser)"
type: "post"
image: "cloud-observability-grafana-spring-boot/title.svg"
tags: ["Cloud", "Observability", "Grafana", "Tempo", "Loki", "Prometheus", "Spring Boot", "Spring", "Kubernetes", "Exemplars", "Tracing", "Telemetry", "Instrumentation"]
summary: Cloud Observability of Spring Boot applications in Kubernetes with Grafana, Tempo, Loki, Prometheus showing Traces 2 Logs, Logs 2 Traces and Metrics 2 Traces (Exemplars)
draft: true
---

[demo]: https://github.com/qaware/cloud-observability-grafana-spring-boot
[minikube]: https://minikube.sigs.k8s.io/docs/start/
[spring-boot]: https://spring.io/projects/spring-boot
[grafana-blog-exemplars]: https://grafana.com/blog/2021/03/31/intro-to-exemplars-which-enable-grafana-tempos-distributed-tracing-at-massive-scale/

Cloud observability is a crucial component of any serious Kubernetes deployment. 
It tells operations that something is working too slowly with metrics or helps developers debug tricky issues only occurring on production environments with logs. 
However, have you ever looked at a 0.9-percentile request latency graph and wondered why it spiked at certain times? 
Of course, those spikes are only happening on the busy production environment and are not reproducible with simpler means. 
You, as the poor soul tasked with debugging this issue, start combing the logs for interesting errors around that time span. 
Usually, that is cumbersome as there are so much logs and so little hints where to look at.

[Here, exemplars may help][grafana-blog-exemplars]: In short, they are shown together with metrics and tell you about example events contributing to that 0.9 percentile bucket. Those events (or requests) are uniquely identified with a trace id, which makes it quick and easy to correlate them with logs or look at the corresponding request trace across the whole cluster.   

This post presents a demo in [Minikube][minikube] which instruments and observes a simple [Spring Boot application][spring-boot] using Grafana with Prometheus, Loki and Tempo. 
It focuses on how to use the new and heavily promoted **exemplars** feature, which enables a quick transition from metrics to traces and logs.

If you're impatient, check out [how to run the demo locally][demo]. 

# A short introduction to cloud observability

Being able to observe an application or workload within the cloud is crucial for a reliable operation and for debugging potential issues. 
To this end, observability usually consists of metrics, logs and traces, as detailed in the following:

[usered]: https://orangematter.solarwinds.com/2017/10/05/monitoring-and-observability-with-use-and-red/

**Metrics** are usually counters and gauges exposed by the application, which may tell about the healthiness or enable looking at ["utilization/saturation/rate/error/duration" (USERED)][usered] type information. 
Metrics are limited in cardinality and certainly do not allow per-request investigation. 

**Logs** are written by the application and, depending on the log level, may contain very detailed information about the application. 
They may contain structured data, such as a trace id, to correlate them with particular requests made against the application. 

**Traces** are collected during a single request, uniquely identified with a trace id, and are typically propagated across many applications communicating within a cluster. 
They show application internals such as database accesses and record the duration of each such operation as separate spans.

[kubernetes]: https://kubernetes.io/
[grafana]: https://grafana.com/

There is a large amount of tools and SaaS providers that support the aggregation of the above-mentioned diagnosability data. 
Here, we will propose using the following [Grafana][grafana]-based stack for a [Kubernetes][kubernetes] cluster, which is completely free software:

* [Prometheus](https://prometheus.io/) to collect metrics
* [Promtail](https://grafana.com/docs/loki/latest/clients/promtail/) to forward logs to [Loki](https://grafana.com/docs/loki/latest/)
* [Tempo](https://grafana.com/docs/tempo/latest/) to receive traces

[opentelemetry-java-agent]: https://github.com/open-telemetry/opentelemetry-java-instrumentation

In order to enable observability for a specific workload, the workload needs to be instrumented. 
How the instrumentation works depends on the chosen programming language and frameworks the application is using. 
Here, we use the [OpenTelemetry Java Agent][opentelemetry-java-agent] to instrument a Spring Boot application written in Java.

# Visual guide through the Observability Demo

This section highlights the [accompanying demo][demo] for this blog post. 
It's now a good time to spin up the demo locally and then follow this guide interactively on your local machine. 
See below for a thorough explanation what design decision are made for the demo and what technical details are taken care of.

[grafana-local]: http://localhost:3000/
[grafana-demo-dashboard]: http://localhost:3000/d/qiDRdxsnk/spring-boot-demo

Open the [locally running Grafana][grafana-local] and browse to the [Spring Boot Demo dashboard][grafana-demo-dashboard]. 
You'll see the following panel:

{{< img src="/images/cloud-observability-grafana-spring-boot/screenshot-request-latency.png.svg" alt="Spring Boot Demo dashboard" >}}

It uses the default Spring Boot `http_server_requests` metric to display the average, 0.7-percentile and 0.9-percentile latency of all HTTP requests made against the application. 
For demo purposes, a cron job runs inside the cluster every 5 minutes executing a request against the `/trigger-me` endpoint of the Spring Boot application. 
So it might take a while to actually see metrics if you've just spun up the demo.

Hovering one of the "exemplar dots" shows:

{{< img src="/images/cloud-observability-grafana-spring-boot/screenshot-request-latency-exemplar2.png.svg" alt="Spring Boot Demo dashboard Exemplar Mouse Over" >}}

Then, clicking the "View in Tempo" button takes you to the trace of the recorded exemplar:

{{< img src="/images/cloud-observability-grafana-spring-boot/screenshot-tempo.png.svg" alt="Trace viewed in Tempo" >}}

The trace would be much more feature-rich thanks to the automatic instrumentation by the [OpenTelemetry agent][opentelemetry-java-agent].
For example, it would show database accesses and also external calls to other applications or remote endpoints. 
However, the deployed demo app is quite simple.

Next, we can have a look at the log output of the application pod by clicking the indicated button above:

{{< img src="/images/cloud-observability-grafana-spring-boot/screenshot-logs-from-trace.png.svg" alt="Loki Logs from Trace" >}}

The above Loki query is limited to the time range of the trace and focuses on the pod which produced the trace (or span).
It would be possible to include the trace id as well to narrow down the shown logs even more, but that approach might miss logs not properly reported with the trace id. 

Finally, whenever you encounter a log reporting a trace id, you can view the trace in Tempo:

{{< img src="/images/cloud-observability-grafana-spring-boot/screenshot-logs-to-traces.png.svg" alt="Loki Logs to Trace" >}}

Hopefully, this visual guide has given you a good impression what the demo is capable of. 
In particular, the exemplar support should appear quite useful to you if you were ever asked by operations why a metric has triggered an alert, and you needed to figure out what could be the root cause. 
Read on if you are interested in more technical details.

# Details of the Observability Demo

Please always refer to the [full implementation of the demo][demo]. The next sections highlight some interesting code snippets only. 

## Instrumenting a Spring Boot application

Injecting the OpenTelemetry agent and building the Spring Boot application is done using Docker:

```dockerfile
FROM curlimages/curl:7.81.0 AS download
ARG OTEL_AGENT_VERSION="1.12.1"
RUN curl --silent --fail -L "https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_AGENT_VERSION}/opentelemetry-javaagent.jar" \
    -o "$HOME/opentelemetry-javaagent.jar"

FROM maven:eclipse-temurin AS build
ADD . /build
RUN cd /build && mvn package --quiet

FROM eclipse-temurin:17
# Healthcheck is done by Kubernetes probes
HEALTHCHECK NONE
COPY --from=build /build/target/*.jar /app.jar
COPY --from=download /home/curl_user/opentelemetry-javaagent.jar /opentelemetry-javaagent.jar
ENTRYPOINT ["java", \
  "-javaagent:/opentelemetry-javaagent.jar", \
  "-jar", "/app.jar" \
  ]
```

The OpenTelemetry agent then injects the `trace_id` into Logback's MDC, which can then be added to all log statements as part of the `application.yaml`:
```yaml
logging.pattern.level: '%prefix(%mdc{trace_id:-0}) %5p'
```
This enables correlation of log statements to a trace, which may involve many applications during one request.

Also, the Spring Boot Helm chart tells the OpenTelemetry agent to deliver traces to Tempo using the following environment variables (see `deployment.yaml`):
```yaml
env:
  - name: OTEL_EXPORTER_OTLP_ENDPOINT
    value: http://tempo.tempo:4317
  - name: OTEL_SERVICE_NAME
    value: {{ include "app.name" . }}
  - name: KUBE_POD_NAME
    valueFrom:
      fieldRef:
        fieldPath: metadata.name
  - name: OTEL_RESOURCE_ATTRIBUTES
    value: pod=$(KUBE_POD_NAME),namespace={{ .Release.Namespace }}
```
The `KUBE_POD_NAME` is important to show logs from a given trace of that pod.

[spring-boot-pr]:https://github.com/spring-projects/spring-boot/pull/30472
[micrometer-releases]: https://github.com/micrometer-metrics/micrometer/releases

Finally, getting the rather new exemplar support working with Spring Boot Actuator currently requires to manually import the `1.9.0-SNAPSHOT` version of Micrometer and also wiring up the `PrometheusMetricsRegistry` with a `DefaultExemplarSampler`. This little hack will become obsolete once [Micrometer 1.9.0 is released][micrometer-releases] and [this PR against Spring Boot][spring-boot-pr] is merged.

Note that exemplars for timer metrics, such as `http_server_requests`, are only reported for histogram bucket counters, from which the quantiles are calculated. 
That means you need to explicitly enable distribution statistics within your `application.yaml` as follows:

```yaml
management:
  metrics:
    distribution:
      percentiles-histogram:
        http.server.requests: true
      minimum-expected-value:
        http.server.requests: 5ms
      maximum-expected-value:
        http.server.requests: 1000ms
```

## Enabling exemplar support in Prometheus

The Prometheus deployment needs to explicitly enable the feature for exemplar support. This is done in the `kube-prometheus-stack` Helm chart using the following `values.yaml` config part:
```yaml
kube-prometheus-stack:
  prometheus:
    prometheusSpec:
      enableFeatures:
        - exemplar-storage
```


## Configuring Grafana data sources

In order to make Grafana show the various buttons to automatically go from
logs to traces, from traces to logs and also from exemplars to traces, the
data sources need to be configured as follows. 
See also `additionalDataSources`
in the `values.yaml` of the `kube-prometheus-stack` Helm chart.

**Tempo data source** 

See [documentation](https://grafana.com/docs/grafana/latest/datasources/tempo/#provision-the-tempo-data-source).

```yaml
- name: Tempo
  type: tempo
  uid: tempo
  access: proxy
  url: http://tempo.tempo:3100
  jsonData:
    httpMethod: GET
    tracesToLogs:
      datasourceUid: 'loki'
      # they must be attached by the instrumentation
      tags: [ 'pod', 'namespace' ]
      # extend time span a little, to ensure catching all logs of that span
      spanStartTimeShift: 1s
      spandEndTimeShift: 1s
      lokiSearch: true
    serviceMap:
      datasourceUid: 'prometheus'
```


You might consider adding one or both of the following lines here: 
```yaml
filterByTraceID: true
filterBySpanID: true
```

**Loki data source** 

See [documentation](https://grafana.com/docs/grafana/latest/datasources/loki/#configure-the-data-source-with-provisioning).

```yaml
- name: Loki
  type: loki
  uid: loki
  access: proxy
  url: http://loki.loki:3100
  jsonData:
    derivedFields:
      - name: trace_id
        datasourceUid: tempo
        matcherRegex: "trace_id=(\\w+)"
        url: '$${__value.raw}'
```


**Prometheus data source**

See [documentation](https://grafana.com/docs/grafana/latest/datasources/prometheus/#provision-the-prometheus-data-source).


```yaml
- name: Prometheus
  type: prometheus
  uid: prometheus
  access: proxy
  url: http://kube-prometheus-stack-prometheus:9090/
  jsonData:
    exemplarTraceIdDestinations:
      - name: trace_id
        datasourceUid: tempo
        urlDisplayLabel: View in Tempo
```

For Prometheus, the `urlDisplayLabel` wasn't really documented in Grafana and omitting it makes the "View in Tempo" button for exemplars disappear. It can be found [in the source](https://github.com/grafana-operator/grafana-operator/blob/master/api/integreatly/v1alpha1/grafanadatasource_types.go#L205) though.

# Outlook

[opentelemetry-operator]: https://github.com/open-telemetry/opentelemetry-operator
[opentelemetry-collector]: https://github.com/open-telemetry/opentelemetry-collector


Currently, the demo just deploys some carefully configured Helm charts into Minikube. 
This could be improved by developing an `cloud-observability-stack` helm chart combining Loki, Tempo, Prometheus, Promtail and Grafana. 

Furthermore, one could build a Kubernetes operator to inject Java instrumentation into the running workloads during startup based on an opt-in Kubernetes annotation. 
Such a solution exists in the form of the [OpenTelemetry operator][opentelemetry-operator]. 
Unfortunately, this operator is less well integrated with Grafana as it is using the OpenTelemetry collector and requires the deployment of the Cert Manager Operator which causes additional operational overhead.

Feel free to raise [issues in the demo project][demo] or [contact the author via mail](mailto:andreas.grub@qaware.de) if you have further ideas or suggestions what to improve.

This blog post was sponsored by my current employer, [QAware](https://qaware.de). If you enjoy working on challenging topics such as engineering proper cloud observability, [then join us!](https://www.qaware.de/karriere-uebersicht)
