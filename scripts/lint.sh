#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

if [ -z "${RUST_SCOPE+x}" ]; then
  RUST_SCOPE="--all-targets --all-features"
fi
if [ -z "${RUST_DOC_SCOPE+x}" ]; then
  RUST_DOC_SCOPE="--all-features"
fi

CHECK_CMD="cargo check $RUST_SCOPE"
info "Checking code compilation with \`$CHECK_CMD\`..."
if ! $CHECK_CMD; then
  fail "Code did not compile. Run \`$CHECK_CMD\` and fix issues."
fi
success "Code compiles."

FMT_CMD="cargo fmt -v --check"
info "Checking formatting with \`$FMT_CMD\`..."
if ! $FMT_CMD; then
  fail "Code is not properly formatted. Run \`$FMT_CMD\` and fix issues."
fi
success "Code is properly formatted."

CLIPPY_CMD="cargo clippy $RUST_SCOPE"
info "Running clippy linter with \`$CLIPPY_CMD\`..."
if ! $CLIPPY_CMD; then
  fail "Clippy found issues. Run \`$CLIPPY_CMD\` and fix issues."
fi
success "Clippy linter passed."

if [ "${SKIP_TESTS:-false}" != "true" ]; then
  TEST_CMD="cargo test $RUST_SCOPE"
  info "Running tests with \`$TEST_CMD\`..."
  if ! $TEST_CMD; then
    fail "Tests failed. Run \`$TEST_CMD\` and fix issues."
  fi
  success "All tests passed."
else
  info "Skipping tests as per SKIP_TESTS=true."
fi

DOC_CMD="cargo doc --no-deps $RUST_DOC_SCOPE"
info "Generating documentation with \`$DOC_CMD\`..."
if ! $DOC_CMD; then
  fail "Documentation generation failed. Run \`$DOC_CMD\` and fix issues."
fi
success "Documentation generated successfully."
