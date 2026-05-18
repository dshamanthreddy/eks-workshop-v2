#!/bin/bash

set -Eeuo pipefail

# The EKS capability, IAM Capability Role, and DynamoDB IAM policies are
# tracked by the shared fastpaths preprovision Terraform and are torn down
# only when the entire fastpaths environment is destroyed. This script
# cleans up the per-lab resources the *learner* applied during Lab 1 so
# the path can be entered/exited cleanly between sessions.

logmessage "Deleting ACK Table custom resources..."
delete-all-if-crd-exists tables.dynamodb.services.k8s.aws

logmessage "Removing carts Pod Identity association..."
for assoc in $(aws eks list-pod-identity-associations \
  --cluster-name "${EKS_CLUSTER_AUTO_NAME:-eks-workshop-auto}" \
  --namespace carts --service-account carts \
  --query 'associations[].associationId' --output text 2>/dev/null); do
  aws eks delete-pod-identity-association \
    --cluster-name "${EKS_CLUSTER_AUTO_NAME:-eks-workshop-auto}" \
    --association-id "$assoc" >/dev/null 2>&1 || true
done

logmessage "Restoring base-application carts ConfigMap..."
kubectl apply -k ~/environment/eks-workshop/base-application/carts >/dev/null 2>&1 || true
