set -Eeuo pipefail

before() {
  echo "noop"
}

after() {
  # The pod may need extra time to crash and have previous logs available
  # Retry up to 60s checking for the expected credential error
  for i in $(seq 1 6); do
    if [[ "${TEST_OUTPUT:-}" == *"Unable to load credentials"* ]]; then
      echo "Found expected credential error in output"
      return 0
    fi
    sleep 10
  done

  if [[ "${TEST_OUTPUT:-}" != *"Unable to load credentials"* ]]; then
    echo "Failed to match expected output after retries"
    echo "${TEST_OUTPUT:-empty}"
    exit 1
  fi
}

"$@"
