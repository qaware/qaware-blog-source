---
title: "Chaos Engineering: Chaos Toolkit Demo"
date: 2021-02-18
draft: true
author: "[Josef Fuchshuber](https://www.linkedin.com/in/fuchshuber)"
tags: ["Diagnosibility", "DevOps", "Observability", "Chaos Engineering", "Testing", "Quality"]
summary: This blog article demonstrates the usage and functionality of the open source chaos engineering tool Chaos Toolkit.
---

This blog article demonstrates the usage and functionality of the open source chaos testing engineering [Chaos Toolkit (CTK)](https://chaostoolkit.org/) with two simple examples. If you want to learn more about Chaos Engineering first, read our article ["The status quo of Chaos Engineering"]({{< relref "/posts/chaos-engineering-the-status-quo.md" >}}). With CTK, chaos engineering experiments can be specified with a custom [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) as a JSON or YAML description. CTK is open source (Apache-2.0), implemented in Python and can be extended by drivers. Some drivers are provided out-of-the-box by the project:

* Infrastructure & platform level: AWS, Azure, Cloud Foundry, Gandi, Google Cloud Platform, Kubernetes, Service Fabric
* Application level: Spring Boot
* Network: Istio, ToxiProxy, WireMock
* Observability: Dynatrace, Humio, Open Tracing, Prometheus

The drivers include actions and probes. Probes are used to validate the steady state, the state before and after the actions. The actions are the core of the experiment. They simulates failures of the application or platform, or perform a slowdown in network traffic. CKT always runs actions and probes by using public APIs of the platforms and applications. The experiment runs outside the cluster and adds no inverse software blocks (e.g. services meshes) to the cluster.

The best feature of CTK is that you can not only run experiments, you have also to define the steady state as a part of your test cases. This makes CTK tests ideal for integration into ongoing CI/CD processes.

## Demo App

We will demonstrate our two examples using a demo application, a contacts management app based on a microservice architecture and Kubernetes runtime. The demo app is taken from the [Azure Developer College](https://github.com/azuredevcollege/trainingdays).

{{< figure figcaption="Contacts App Architecture" >}}
  {{< img src="/images/chaos-engineering/demo-app.png" alt="Contacts App Architecture" >}}
{{< /figure >}}

## Example #1

The first example is the Kubernetes "hello world" of chaos testing. What happens if the contact service fails?

To interact with Kubernetes, CTK has its own extension [^3]. The tool and extension can be easily installed in an existing Python environment ([installation details](https://docs.chaostoolkit.org/reference/usage/install/)).

```bash
pip install -U chaostoolkit
pip install chaostoolkit-kubernetes
```

After we have installed the tool, we can write our first "hello world" test. For the declarative description you can choose between JSON and YAML. JSON should be avoided just because of the missing capability of comments.

The first part of the test describes the Steady State. The CTK core supports three different probe providers: HTTP, Process, Python [^1]. Our first exampe uses the HTTP provider and sends a HTTP request to the search service and vallidates its HTTP response code.

```yaml
# define the steady state hypothesis
steady-state-hypothesis:
  title: Verifying search api remains healthy
  probes:
  - type: probe
    name: search-api-must-still-respond
    tolerance: 200 # http response code 200 is expected
    provider:
      type: http
      timeout: 2
      url: http://${azure_app_endpoint}/api/search/contacts?phrase=mustermann
```

The second part of the test describes our experimental method. Our example uses the Kubernetes driver extension and terminates exactly one pod from the "contactsapp" namespace of all deployments with the label `service=searchapi`. The driver uses your current kubectl context (`~/.kube/config`). 

```yaml
method:
- type: action
  name: terminate-pod
  provider:
    type: python
    module: chaosk8s.pod.actions
    func: terminate_pods
    # Terminates one "searchapi" pod randomly
    arguments:
      label_selector: service=searchapi
      ns: contactsapp
      qty: 1
      rand: true
      grace_period: 0
```

As soon as Kubernetes detects that a pod is missing from the replica set, a new pod is started. This does not happen immediately, but takes a few seconds depending on the Kubernetes configuration and the application in the pod. At the beginne, our example has a replica set of size 1, so there will be a short downtime when terminating the pod. This fails the validation of the steady state and thus the complete chaos test. After increasing the replica set to two instances of the search service, the test can be successfully executed. The following recording shows the failure of the first execution, the fix by rescaling and then the successful repetition of the test.

{{< asciinema hwvzMTDPy1SxrrafyXoNeNJBN >}}

Execution plan used by Chaos Toolkit when running an experiment:

1. Validate experiment description
2. Run Steady State Hypothesis
3. Run Method
4. Run Steady State Hypothesis
5. Run Rollbacks

If one of the steps fails, the experiment is classified as a failure.

The results of the experiment are output directly in the terminal and additionally logged with more detailed information in the output file `journal.json`. With this file HTML or PDF reports of the experiment can be generated.

```bash
chaos report --export-format=html journal.json report.html
```

The source code of the experiment can be found on [Github](https://github.com/qaware/chaos-engineering/blob/master/chaostoolkit/experiment-kill-search-pod.yaml).

## Example #2

The second example uses the Azure Driver extension [^4] from CTK. In this example, a node from the Kubernetes node pool managed by Azure AKS [^2] is shut down temporarily, simulating a virtual machine failure.

```bash
pip install -U chaostoolkit-azure
```

Before the extension can be used, the Azure secrets must be deployed in the Azure credential file. This requires the Azure CLI and the permission for service principal creation ([full doc](https://github.com/chaostoolkit-incubator/chaostoolkit-azure)).

```bash
az login
az ad sp create-for-rbac --sdk-auth > credentials.json
```

credentials.json:

```json
{
  "subscriptionId": "<azure_aubscription_id>",
  "tenantId": "<tenant_id>",
  "clientId": "<application_id>",
  "clientSecret": "<application_secret>",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

Store the path to the file in an environment variable called `AZURE_AUTH_LOCATION` and make sure that your experiment does NOT contain secrets section. When this is done, our Azure experiments can be run. Our experiment stops an instance from the filtered virtual machine scale set (vmss). The filtering is done by the resource group, the scale set name and the instance ID.

```yaml
method:
- type: action
  name: stop-instace
  provider:
    type: python
    module: chaosazure.vmss.actions
    func: stop_vmss
    arguments:
      filter: where resourceGroup=~'${azure_resource_group}' and name=~'${azure_vmss_name}'
      instance_criteria:
      - name: ${azure_vmss_instanceId}
  pauses:
    after: 15
```

This test can be used to verify that the instances of the Search service have been deployed on more than one Kubernetes node, thus guaranteeing the availability of the service in the unavailability of a node.

Because in this test the node remains stopped even after the second steady state validation, we need to execute a rollback. In our example we restart the node with the function `restart_vmss`.

```yaml
rollbacks:
- type: action
  name: restart-instance
  provider:
    type: python
    module: chaosazure.vmss.actions
    func: restart_vmss
    arguments:
      filter: where resourceGroup=~'${azure_resource_group}' and name=~'${azure_vmss_name}'
      instance_criteria:
      - name: ${azure_vmss_instanceId}
```

The source code of the experiment can be found on [Github](https://github.com/qaware/chaos-engineering/blob/master/chaostoolkit/experiment-stop-node.yaml).

## Summary

The Chaos Toolkit is a stable open source tooling for Choas Engineering. The existing driver extensions, the possibility for own extensions or to be able to execute processes directly as action or probe results in a very large flexibility for any kind of Chaos tests.

Because a test always includes the complete experiment (Steady State & Action), Chaos Toolkit is ideal for continuous automated quality assurance.

## Workshop

{{< figure figcaption="Workshop: Choas Engineering on Azure AKS" >}}
  {{< img src="/images/chaos-engineering/workshop.png" alt="Workshop: Choas Engineering on Azure AKS" >}}
{{< /figure >}}

If you want to learn more about using Chaos Toolkit and Chaos Mesh, join our remote workshop "Choas Engineering on Azure AKS" on March 29, 2021. More infos and Infos & registration: [www.containerconf.de](https://www.containerconf.de/lecture_workshop.php?id=12764)



[^1]: [Chaos Toolkit Probe Provider](https://docs.chaostoolkit.org/reference/api/experiment/#action-or-probe-provider)
[^2]: [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/services/kubernetes-service/)
[^3]: [chaosk8s Extension](https://docs.chaostoolkit.org/drivers/kubernetes/)
[^4]: [Azure Extension](https://docs.chaostoolkit.org/drivers/azure/)