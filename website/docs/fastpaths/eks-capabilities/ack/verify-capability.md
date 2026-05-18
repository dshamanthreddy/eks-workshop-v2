---
title: "Verify the ACK capability"
sidebar_position: 20
---

The `prepare-environment` step has already enabled the ACK capability on the cluster. Before doing anything else, let's confirm it's `ACTIVE` and the DynamoDB CRDs are available.

Inspect the capability resource directly:

```bash
$ aws eks describe-capability \
  --cluster-name $EKS_CLUSTER_AUTO_NAME \
  --capability-name $EKS_CAP_ACK_CAPABILITY \
  --query 'capability.status' --output text
ACTIVE
```

A capability transitions through `CREATING → ACTIVE`. If the status here is anything other than `ACTIVE`, wait a moment and re-run the command — the capability may still be initializing.

Now check that the DynamoDB controller's custom resources are registered in the cluster:

```bash
$ kubectl get crd tables.dynamodb.services.k8s.aws \
  -o jsonpath='{.spec.names.kind}{"\n"}'
Table
```

```bash
$ kubectl api-resources --api-group=dynamodb.services.k8s.aws
NAME             SHORTNAMES   APIVERSION                              NAMESPACED   KIND
backups                       dynamodb.services.k8s.aws/v1alpha1      true         Backup
globaltables                  dynamodb.services.k8s.aws/v1alpha1      true         GlobalTable
tables                        dynamodb.services.k8s.aws/v1alpha1      true         Table
```

:::info
Notice we never installed a Helm chart, never created an `ack-system` namespace, and there's no DynamoDB controller Pod running on your worker nodes. The capability runs in AWS-managed infrastructure outside the cluster — what you see inside the cluster are only the CRDs the capability registered for you to apply.
:::

With the capability `ACTIVE` and the CRDs in place, we're ready to provision a DynamoDB table from Kubernetes.
