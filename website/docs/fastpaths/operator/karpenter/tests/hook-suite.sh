set -Eeuo pipefail

before() {
  echo "noop"
}

after() {
  # Clean up inflate deployment from karpenter lab
  kubectl delete deployment inflate -n other --ignore-not-found

  # Wait for Karpenter consolidation to settle and pods to stabilize
  sleep 120
  kubectl wait --for=condition=Ready --timeout=300s pods -l app.kubernetes.io/created-by=eks-workshop -A
}

"$@"
