set -Eeuo pipefail

before() {
  echo "noop"
}

after() {
  # Wait for the carts pod to crash and restart at least once
  # then check previous container logs for the expected credential error
  echo "Waiting for carts pod to crash and restart..."

  for i in $(seq 1 36); do
    RESTARTS=$(kubectl get pods -n carts -l app.kubernetes.io/component=service --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1:].status.containerStatuses[0].restartCount}' 2>/dev/null || echo "0")
    if [ "$RESTARTS" -gt 0 ] 2>/dev/null; then
      LATEST_POD=$(kubectl get pods -n carts -l app.kubernetes.io/component=service --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1:].metadata.name}')
      LOG_OUTPUT=$(kubectl logs -n carts -p "$LATEST_POD" 2>/dev/null || true)
      if [[ "$LOG_OUTPUT" == *"Unable to load credentials"* ]]; then
        echo "Found expected credential error after $i attempts (restarts=$RESTARTS)"
        return 0
      fi
    fi
    echo "Attempt $i: restarts=$RESTARTS, waiting..."
    sleep 10
  done

  echo "Failed to find expected credential error after 360s"
  exit 1
}

"$@"
