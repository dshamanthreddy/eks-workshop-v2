---
title: "Developer Essentials"
sidebar_position: 50
sidebar_custom_props: { "module": true }
---

# Developer Essentials

::required-time

:::tip Before you start
Apply required lab configurations:

```bash
$ prepare-environment fastpaths/developer
```
:::

Welcome to the EKS Workshop Developer Essentials! This is a collection of labs optimized for developers to learn the features of Amazon EKS most commonly required when deploying workloads.

First, let's deploy the sample application to your cluster:

```bash
$ kubectl apply -k ~/environment/eks-workshop/base-application
```

Wait for all components to be ready:

```bash
$ kubectl wait --for=condition=Ready pods --all -A -l app.kubernetes.io/created-by=eks-workshop --timeout=180s
```

In this learning path, you'll learn:

- How to deploy and manage containerized applications on EKS
- Working with persistent storage using Amazon EBS
- Implementing autoscaling for your workloads
- Exposing applications with load balancers and DNS
- Using AWS services like DynamoDB with EKS Pod Identity

Let's get started!
