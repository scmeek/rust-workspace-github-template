#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

if [ -z "${RUST_SCOPE+x}" ]; then
  RUST_SCOPE="--all-targets --all-features"
fi

echo ""

DOC_TEST_CMD="cargo test --workspace --all-features --doc"
info "Running doc tests with \`$DOC_TEST_CMD\`..."
if ! $DOC_TEST_CMD; then
  fail "Doc tests failed. Run \`$DOC_TEST_CMD\` and fix issues."
fi

TEST_CMD="cargo llvm-cov nextest --workspace $RUST_SCOPE" # Also in dependencies.sh
info "Running tests with \`$TEST_CMD\`..."
if ! $TEST_CMD; then
  fail "Tests failed. Run \`$TEST_CMD\` and fix issues."
fi

if [ "${SKIP_RELEASE_TEST:-false}" != "true" ]; then
  RELEASE_TEST_CMD="cargo llvm-cov nextest --release --workspace $RUST_SCOPE" # Also in dependencies.sh
  info "Running tests (release) with \`$RELEASE_TEST_CMD\`..."
  if ! $RELEASE_TEST_CMD; then
    fail "Tests (release) failed. Run \`$RELEASE_TEST_CMD\` and fix issues."
  fi
else
  note "Skipping running tests (release)."
fi

final_success "All tests passed."
