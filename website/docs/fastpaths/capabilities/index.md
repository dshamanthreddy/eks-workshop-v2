---
title: "EKS Capabilities"
sidebar_position: 70
sidebar_custom_props: { "module": true }
description: "Learn how to combine ACK, Argo CD, and KRO on Amazon EKS to provision, deliver, and orchestrate application infrastructure from a single Kubernetes control plane."
---

::required-time

Welcome to the EKS Capabilities learning path. This fast path is designed for
platform engineers and DevOps practitioners who want to see how three
complementary EKS capabilities fit together in a single, app-centric workflow:

1. **AWS Controllers for Kubernetes (ACK)** — provision real AWS infrastructure
   from your cluster.
2. **Argo CD** — deliver application changes with GitOps.
3. **Kubernetes Resource Orchestrator (KRO)** — declare multi-resource stacks
   with topological ordering.

Each lab builds on the last. You start with the retail sample application's
`carts` service talking to a local DynamoDB pod, migrate it to a real AWS
DynamoDB table managed by ACK, deliver the `catalog` service via GitOps using
Argo CD, and finally orchestrate the whole `carts` stack declaratively with
KRO.

By the end you'll be able to describe where each capability fits in a
production EKS platform and how they compose.
