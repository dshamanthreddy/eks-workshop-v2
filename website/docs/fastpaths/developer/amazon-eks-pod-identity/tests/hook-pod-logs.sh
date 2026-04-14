set -Eeuo pipefail

before() {
  echo "noop"
}

after() {
  # The pod may need extra time to crash and have previous logs available
  # Retry up to 120s re-fetching logs until we find the expected error
  LATEST_POD=$(kubectl get pods -n carts -l app.kubernetes.io/component=service --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1:].metadata.name}')

  for i in $(seq 1 12); do
    LOG_OUTPUT=$(kubectl logs -n carts -p "$LATEST_POD" 2>/dev/null || true)
    if [[ "$LOG_OUTPUT" == *"Unable to load credentials"* ]]; then
      echo "Found expected credential error in logs"
      return 0
    fi
    echo "Attempt $i: credential error not found yet, waiting..."
    sleep 10
  done

  echo "Failed to find expected credential error after retries"
  echo "Last log output: ${LOG_OUTPUT:-empty}"
  exit 1
}

"$@"
