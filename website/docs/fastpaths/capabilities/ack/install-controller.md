---
title: "Install the ACK DynamoDB controller"
sidebar_position: 20
---

Each ACK service controller is packaged as a container image published to
the [public ECR gallery](https://gallery.ecr.aws/aws-controllers-k8s).
You install the controller for the AWS service you want to manage — in this
lab, DynamoDB.

The IAM role the controller will assume has already been created by
`prepare-environment` and is available as `$ACK_IAM_ROLE`. The pinned
controller version is available as `$DYNAMO_ACK_VERSION`.

Log in to the public ECR registry and install the ACK DynamoDB controller
using Helm:

```bash wait=60
$ aws ecr-public get-login-password --region us-east-1 | \
  helm registry login --username AWS --password-stdin public.ecr.aws
$ helm install ack-dynamodb-controller \
  oci://public.ecr.aws/aws-controllers-k8s/dynamodb-chart \
  --version=${DYNAMO_ACK_VERSION} \
  --namespace ack-system --create-namespace \
  --set "aws.region=${AWS_REGION}" \
  --set "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"="$ACK_IAM_ROLE" \
  --wait
```

Verify the controller is running in the `ack-system` namespace:

```bash
$ kubectl get deployment -n ack-system
NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
ack-dynamodb-controller-dynamodb-chart   1/1     1            1           30s
```

Installing the controller registered a set of Custom Resource Definitions
that let you describe DynamoDB resources as Kubernetes objects. You can see
them with:

```bash
$ kubectl get crds | grep dynamodb.services.k8s.aws
```

With the controller running and the CRDs installed, you can now provision a
DynamoDB table from Kubernetes.
