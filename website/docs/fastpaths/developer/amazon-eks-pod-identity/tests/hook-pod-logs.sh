set -Eeuo pipefail

before() {
  echo "noop"
}

after() {
  if [[ "${TEST_OUTPUT:-}" != *"Unable to load credentials"* ]]; then
    echo "Failed to match expected output"
    echo "${TEST_OUTPUT:-empty}"
    exit 1
  fi
}

"$@"
