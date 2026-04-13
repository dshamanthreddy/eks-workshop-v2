#!/bin/bash

set -e

echo "Cleaning up operator essentials resources..."

# Delete inflate deployment from Karpenter lab
kubectl delete deployment inflate -n other --ignore-not-found

# Delete network policies
kubectl delete networkpolicy --all -A --ignore-not-found 2>/dev/null || true

# Delete SecretProviderClass and ClusterSecretStore
kubectl delete secretproviderclass --all -A --ignore-not-found 2>/dev/null || true
kubectl delete clustersecretstore --all --ignore-not-found 2>/dev/null || true
kubectl delete externalsecret --all -A --ignore-not-found 2>/dev/null || true

# Delete pod identity associations for carts
for assoc in $(aws eks list-pod-identity-associations --cluster-name ${EKS_CLUSTER_AUTO_NAME:-eks-workshop-auto} --namespace carts --query 'associations[].associationId' --output text 2>/dev/null); do
  aws eks delete-pod-identity-association --cluster-name ${EKS_CLUSTER_AUTO_NAME:-eks-workshop-auto} --association-id $assoc 2>/dev/null || true
done

# Delete modified StatefulSets + PVCs (from any EBS changes)
kubectl delete statefulset -l app.kubernetes.io/created-by=eks-workshop -A --ignore-not-found
kubectl delete pvc --all -A --ignore-not-found
kubectl delete storageclass ebs-sc --ignore-not-found

echo "Cleanup complete!"
