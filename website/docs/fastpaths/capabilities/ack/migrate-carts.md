---
title: "Migrate carts to the real DynamoDB table"
sidebar_position: 40
---

The `carts` microservice already supports DynamoDB as a persistence backend.
Switching from the local pod to the real AWS table is a configuration
change, not a code change.

Two pieces of configuration need to update:

1. The `carts` **ConfigMap** — point the service at the real table name and
   remove the local endpoint so the AWS SDK uses the public DynamoDB
   endpoint.
2. The `carts` **ServiceAccount** — annotate it with the IAM role that grants
   DynamoDB access through IRSA.

Both are applied with a Kustomize overlay on top of the base application.

Here is the ConfigMap override that will replace the existing one:

```kustomization
modules/fastpaths/capabilities/ack/app/kustomization.yaml
ConfigMap/carts
```

And the annotated ServiceAccount:

```kustomization
modules/fastpaths/capabilities/ack/app/carts-serviceAccount.yaml
ServiceAccount/carts
```

See [IAM roles for service accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)
for more on how IRSA works.

Apply the overlay:

```bash
$ kubectl kustomize ~/environment/eks-workshop/modules/fastpaths/capabilities/ack/app \
  | envsubst | kubectl apply -f-
```

The local `carts-dynamodb` Deployment is no longer needed. Remove it:

```bash
$ kubectl delete deployment/carts-dynamodb -n carts
deployment.apps "carts-dynamodb" deleted
```

Restart the `carts` Deployment so the new ConfigMap and ServiceAccount take
effect:

```bash
$ kubectl rollout restart deployment/carts -n carts
$ kubectl rollout status deployment/carts -n carts --timeout=120s
deployment "carts" successfully rolled out
```

Confirm the carts Pod is now using the IAM role from the ServiceAccount:

```bash
$ kubectl describe serviceaccount carts -n carts \
  | grep "eks.amazonaws.com/role-arn"
Annotations:         eks.amazonaws.com/role-arn: arn:aws:iam::...:role/eks-workshop-carts-ack
```

## Verify the migration

Add a few items to the cart through the application UI, or hit the cart
endpoint directly through `kubectl`:

```bash
$ kubectl exec -n carts deployment/carts -- \
  curl -sS -X POST http://localhost:8080/carts/user-fast-path/items \
  -H 'Content-Type: application/json' \
  -d '{"itemId":"sku-123","quantity":2,"unitPrice":19.99}'
```

Then scan the real DynamoDB table and confirm the item landed there:

```bash
$ aws dynamodb scan \
  --table-name "${EKS_CLUSTER_NAME}-carts-ack" \
  --select COUNT \
  --query 'Count' --output text
```

Any non-zero count means `carts` is writing to the ACK-managed table in
AWS, not the local pod.

Congratulations — you've provisioned a real AWS service from Kubernetes and
migrated an application to use it without touching the application code. In
the next lab you'll layer Argo CD on top to deliver application changes
through GitOps.
