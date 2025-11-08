#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

if [ -z "${RUST_SCOPE+x}" ]; then
  RUST_SCOPE="--all-targets --all-features"
fi

echo ""

TEST_CMD="cargo llvm-cov nextest --workspace $RUST_SCOPE" # Also in dependencies.sh
info "Running tests with \`$TEST_CMD\`..."
if ! $TEST_CMD; then
  fail "Tests failed. Run \`$TEST_CMD\` and fix issues."
fi
success "All tests passed."
