---
title: "Operator Essentials"
sidebar_position: 60
sidebar_custom_props: { "module": true }
---

# Operator Essentials

::required-time

:::tip Before you start
This fast path uses a dedicated Amazon EKS Auto Mode cluster. Amazon EKS Auto Mode extends AWS management of Kubernetes clusters beyond the cluster itself, managing infrastructure that enables smooth operation of your workloads including compute autoscaling, networking, load balancing, DNS, and block storage.

Switch to the Auto Mode cluster:

```bash
$ prepare-environment fastpaths/operator
```
:::

Welcome to the EKS Workshop Operator Essentials! This is a collection of labs optimized for operators to learn the features of Amazon EKS most commonly required when operating EKS clusters.

First, let's deploy the sample application to your cluster:

```bash
$ kubectl apply -k ~/environment/eks-workshop/base-application
```

Wait for all components to be ready:

```bash
$ kubectl wait --for=condition=Ready pods --all -A -l app.kubernetes.io/created-by=eks-workshop --timeout=180s
```

Throughout this series of exercises you'll learn:

- Configuring cluster autoscaling with Karpenter
- Implementing network policies for secure Pod-to-Pod traffic
- Working with secrets in EKS
- Troubleshooting common Pod failure scenarios
- Using AWS services like DynamoDB with EKS Pod Identity

Let's get started!