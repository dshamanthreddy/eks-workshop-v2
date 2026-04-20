---
title: "Provision AWS infrastructure with ACK"
sidebar_position: 10
sidebar_custom_props: { "module": true }
description: "Use AWS Controllers for Kubernetes to provision an Amazon DynamoDB table and migrate the carts microservice from a local pod to the cloud-managed table."
---

::required-time

:::tip Before you start
Prepare your environment for this lab:

```bash timeout=300 wait=30
$ prepare-environment fastpaths/capabilities/ack
```

This will make the following changes to your lab environment:

- Create an IAM role for the `carts` ServiceAccount with permission to read
  and write a lab-scoped Amazon DynamoDB table.
- Create an IAM role for the ACK DynamoDB controller ServiceAccount with
  permission to manage the same table.
- Export the role ARNs and the pinned ACK controller version to your shell as
  `CARTS_IAM_ROLE`, `ACK_IAM_ROLE`, and `DYNAMO_ACK_VERSION`.

You can view the Terraform that applies these changes
[here](https://github.com/VAR::MANIFESTS_OWNER/VAR::MANIFESTS_REPOSITORY/tree/VAR::MANIFESTS_REF/manifests/modules/fastpaths/capabilities/ack/.workshop/terraform).

:::

The [AWS Controllers for Kubernetes (ACK)](https://aws-controllers-k8s.github.io/community/)
project lets you define AWS resources as Kubernetes custom resources. A
controller running in the cluster reconciles those custom resources against
the AWS API — creating, updating, and deleting the real resources on your
behalf.

By default, the `carts` microservice in the retail sample application talks
to a **local DynamoDB pod** called `carts-dynamodb`. That's fine for a
development sandbox, but for production you want a real Amazon DynamoDB
table. In this lab you will:

1. Install the ACK DynamoDB controller.
2. Provision a real DynamoDB table using a Kubernetes custom resource.
3. Migrate the `carts` service to use the real table through an IRSA
   service account.

When you're done, the `carts` service will be reading and writing to a
DynamoDB table managed entirely through Kubernetes, with no changes to the
application code.
