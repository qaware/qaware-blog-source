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



Infrastructure as Code (IaC) should be a given for all

Terraform is turning 10 years old next year, a dinosaur in the hype-based world of cloud software. While Hashicorp's now proprietary software has enabled millions of companies to manage their infrastructure declaratively, the company has done little to improve its core product over time. Perhaps OpenTofu (now GA) will answer the call. In the meantime, contenders like Pulumi and Crossplane have made a name for themselves.


TODO: CDKTF, AwsCDK?




Other alts: Complete Vendor-LockIn?
- Azure Resource Manager (ARM) Templates and Bicep
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


Honorable mentions:
- [StackQL](https://github.com/stackql/stackql) - Use SQL to CRUD multiple cloud providers. Good for analytics.
- [System Initiative](https://www.youtube.com/watch?v=zyEOYl23pd8) - Forget infrastructure as code. Life is a game, so just use a GUI!
- [Winglang](https://github.com/winglang/wing) (a new language) and [Microsoft Radius](https://github.com/radius-project/radius) (a new data structure) both try to be an integrated orchestration platform.


## One More Thing 

The folks at Digger HQ have compiled a [categorized list of tools](https://medium.com/@DiggerHQ/a-list-of-essential-tools-for-platform-engineers-c94f5ef84fb7) competing in the infrastructure management space. These include Terraform Automation and Collaboration Software aka [TACOS](https://itnext.io/spice-up-your-infrastructure-as-code-with-tacos-1a9c179e0783) (hint: don't forget the [SLSA](https://slsa.dev/)) and various PaaS solutions. While some features may easily be replicated with basic pipeline steps (e.g. pipeline stages that run [Checkov](https://github.com/bridgecrewio/checkov) or [Infracost](https://github.com/infracost/infracost) on `tf-plan` output), having all-in-one solutions can be tempting.