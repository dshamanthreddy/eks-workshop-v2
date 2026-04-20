---
title: "Provision a DynamoDB table"
sidebar_position: 30
---

With the ACK DynamoDB controller running, you can describe a DynamoDB table
in a Kubernetes manifest and let the controller create it in AWS.

Here is the `Table` manifest you'll apply. It maps directly to the
[CreateTable](https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_CreateTable.html)
API — the same fields, the same semantics.

::yaml{file="manifests/modules/fastpaths/capabilities/ack/dynamodb/dynamodb-create.yaml" paths="apiVersion,kind,spec.keySchema,spec.attributeDefinitions,spec.billingMode,spec.tableName,spec.globalSecondaryIndexes"}

1. Uses the ACK DynamoDB controller API group.
2. Declares a DynamoDB `Table` resource.
3. Sets `id` as the partition (`HASH`) key.
4. Defines the string attributes used by the primary key and the global
   secondary index.
5. Uses on-demand (`PAY_PER_REQUEST`) billing so you are not provisioning
   read and write capacity up-front.
6. Names the table with the `${EKS_CLUSTER_NAME}` prefix so it does not
   collide with other workshop installs in the same AWS account.
7. Adds a global secondary index on `customerId` with all attributes
   projected.

Apply the manifest. The Table resource lives in the `carts` namespace next
to the service that will use it:

```bash wait=10
$ kubectl kustomize ~/environment/eks-workshop/modules/fastpaths/capabilities/ack/dynamodb \
  | envsubst | kubectl apply -f-
table.dynamodb.services.k8s.aws/items created
```

DynamoDB table creation is asynchronous. Wait for the ACK controller to
report the table as synced and active:

```bash timeout=300
$ kubectl wait table.dynamodb.services.k8s.aws/items -n carts \
  --for=condition=ACK.ResourceSynced --timeout=5m
table.dynamodb.services.k8s.aws/items condition met
$ kubectl get table.dynamodb.services.k8s.aws/items -n carts \
  -o jsonpath='{.status.tableStatus}'
ACTIVE
```

Confirm the table exists in AWS using the AWS CLI:

```bash
$ aws dynamodb describe-table \
  --table-name "${EKS_CLUSTER_NAME}-carts-ack" \
  --query 'Table.TableStatus' --output text
ACTIVE
```

You can also inspect the table in the AWS Console:

<ConsoleButton
  url="https://console.aws.amazon.com/dynamodbv2/home#tables"
  service="dynamodb"
  label="Open DynamoDB console"
/>

The table exists, but the `carts` service is still writing to the local
DynamoDB pod. In the next step you'll migrate it over.
