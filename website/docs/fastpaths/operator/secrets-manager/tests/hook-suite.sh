set -Eeuo pipefail

before() {
  echo "noop"
}

after() {
  # Clean up secrets lab artifacts
  kubectl delete secretproviderclass catalog-spc -n catalog --ignore-not-found
  kubectl delete externalsecret catalog-external-secret -n catalog --ignore-not-found
  kubectl delete clustersecretstore cluster-secret-store --ignore-not-found

  # Delete the test secret from Secrets Manager
  if [ -n "${SECRET_NAME:-}" ]; then
    aws secretsmanager delete-secret --secret-id "$SECRET_NAME" --force-delete-without-recovery 2>/dev/null || true
  fi

  # Restore catalog to base state
  kubectl apply -k ~/environment/eks-workshop/base-application/catalog
  kubectl rollout status deployment/catalog -n catalog --timeout=120s
}

"$@"
