---
title: "IaC in 2024"
date: 2024-01-23T17:34:04+01:00
author: "Felix Kampfer"
type: "post"
jinks: Possibly use an image of a dinsoaur in modern society to represent Terraform? 
image: "" 
categories: []
tags: ["IaC", "terraform", "infrastructure", "devops"]
draft: true
summary: It's 2024 and you're STILL using Terraform. It might be time for a switch.
---

(Ideas for metaphors: The Jungle, The Great Race, The Wild West, A County Fair, A Candy Store, A Used Car Store based on "Slaps Roof of Car" meme?)
# Infrastructure as Code in 2024
## Terraform, Pulumi, or Crossplane?

> "Assembly is a 'simpler' way to think about programming, but didn't scale as complexity of application software increases. I believe the same is true about JSON/YAML/HCL and cloud infrastructure". 
> 
> Luke Hoban, CTO of Pulumi


Using Infrastructure as Code (IaC) should be considered standard practice for all serious platform engineering-related projects in 2024. In contrast to procedural frameworks like Ansible, Puppet and Chef, the benefits of declarative infrastructure are [overwhelming](https://blog.gruntwork.io/why-we-use-terraform-and-not-chef-puppet-ansible-saltstack-or-cloudformation-7989dad2865c).

Still, Terraform is turning 10 years old next year, a dinosaur in the hype-based world of cloud software. While Hashicorp's now proprietary software has enabled millions of companies to manage their infrastructure declaratively, the company has done little to improve its core product over time. Perhaps OpenTofu (now GA) will answer the call, or at least put new pressure on Hashicorp to [expand its featureset](https://www.hashicorp.com/blog/terraform-1-7-adds-test-mocking-and-config-driven-remove). In the meantime, contenders like Pulumi and Crossplane have made a name for themselves.

This blog post explores whether Pulumi and Crossplane can replace Terraform for your next project of 2024. We will also take a look at middle-of-the-road solutions like CDKTF (Cloud Development Kit for Terraform) and vendor-specific Kubernetes operators that offer a compromise of features.


## Pulumi

Pulumi has a very similar architectural workflow to Terraform: 

1. Platform developers define the infrastructure using code.
2. The Pulumi engine reads the state file and creates a plan based on the diff between the known infrastructure state and the defined infrastructure state. (STACKS??)
3. Platform developers apply the plan to the infrastructure.

However, Pulumi you to define infrastructure using a general-purpose programming language (like Python or Typescript). This means that teams can use the same language to write applications and infrastructure, and enjoy the benefits of a modern language, such as type safety, code completion, refactoring tools and the simple pleasure of using real nestable `for` loops. Infrastructure code can also be tested using standard testing frameworks.

Other major benefits are:
- Native providers for all major cloud providers, including AWS, Azure, GCP, and Kubernetes.
- A more flexible plugin system, allowing for more advanced features like post-deploy hooks.

While Pulumi is a serious contender in the realm of IaC, it might not be all sunshine and rainbows:
- Pulumi uses Terraform providers as a fallback, meaning it often has the same limitations as Terraform.
- Pulumi only allows you to save a change plan (e.g. for review with a different tool) when using `PULUMI_EXPERIMENTAL=true`, implying that the feature is not yet stable.
- Pulumi's language flexibility, while theoretically being interoperable, causes its plugin ecosystem to be split across multiple languages.


## Cloud Development Kit for Terraform (CDKTF)

If moving to an entirely different IaC tool (with its own ecosystem and peculiarities) is too scary, but the benefits of general-purpose languages are too tempting to ignore, the Cloud Development Kit for Terraform (CDKTF) might be worth a shot.

CDKTF is built on top of Terraform. While it technically allows you to define infrastructure using a general-purpose language, the code always compiles down to 

**AI_GENERATED** a Terraform configuration. This means that you can use the same language to define infrastructure as you use to define applications, but you still get the benefits of Terraform's ecosystem and the ability to use Terraform providers.**AI_GENERATED**

Vendor-specific flavors of CDKTF also exist in the form of the AWS Cloud Development Kit and the  are

- Serverless Framework (?!!!)
- 



## Crossplane

## Vendor-Specific Compromises


There are also other alternatives, specific to each cloud provider.


TODO: Find out more about how CDKTF works (it's not as dumb as HCL, apparently?), add some diagrams to show the differences between the few. Describe Crossplane, consider adding "Serverless Framework" as another alternative...

TODO: minimize links to avoid losing audience to distractions
TODO: design / create diagrams to roughly explain how Pulumi, Crossplane and TF each work? Consider linking to outside Repositories that define things well?

Other alts: Complete Vendor-LockIn?
- Azure Resource Manager (ARM) Templates and *Bicep*
- Google Cloud Deployment Manager 
- AWS CloudFormation



Kubernetes as Control Plane? 
- (Crossplane of course)
- Google Config Connector
- Azure Service Operator
- AWS Controllers for Kubernetes


{}

Whether with support for general-purpose languages (such as Python) or with simpler integration of self-service developer portals, these new architecture configuration tools offer exciting options for platform teams.

This post explores hype factors and caveats of some up and coming Terraform alternatives, while 



===== NEUER POST!! =====
(Testing not very interesting - better to have drills!)

## Honorable mentions:

- [StackQL](https://github.com/stackql/stackql) - Use SQL to CRUD multiple cloud providers. Good for analytics.
- [System Initiative](https://www.youtube.com/watch?v=zyEOYl23pd8) - Forget infrastructure as code. Life is a game, so just use a GUI!
- [Winglang](https://github.com/winglang/wing) (a new language) and [Microsoft Radius](https://github.com/radius-project/radius) (a new data structure) both try to be an integrated orchestration platform.


## One More Thing 

The folks at Digger HQ have compiled a [categorized list of tools](https://medium.com/@DiggerHQ/a-list-of-essential-tools-for-platform-engineers-c94f5ef84fb7) competing in the infrastructure management space. These include Terraform Automation and Collaboration Software aka [TACOS](https://itnext.io/spice-up-your-infrastructure-as-code-with-tacos-1a9c179e0783) (hint: don't forget the [SLSA](https://slsa.dev/)) and various PaaS solutions. While some features may easily be replicated with basic pipeline steps (e.g. pipeline stages that run [Checkov](https://github.com/bridgecrewio/checkov) or [Infracost](https://github.com/infracost/infracost) on `tf-plan` output), having all-in-one solutions can be tempting.