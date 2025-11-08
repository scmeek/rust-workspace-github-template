#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

if [ -z "${RUST_SCOPE+x}" ]; then
  RUST_SCOPE="--all-targets --all-features"
fi

echo ""

CHECK_CMD="cargo workspace-lints" # Also in dependencies.sh
info "Running workspace lints enforcement check..."
if ! $CHECK_CMD; then
  fail "A crate is missing workspace.lints."
fi
success "Workspace lints are properly enforced."

echo ""

CHECK_CMD="cargo check $RUST_SCOPE"
info "Checking code compilation with \`$CHECK_CMD\`..."
if ! $CHECK_CMD; then
  fail "Code did not compile. Run \`$CHECK_CMD\` and fix issues."
fi
success "Code compiles."

echo ""

CLIPPY_CMD="cargo clippy $RUST_SCOPE"
info "Running clippy linter with \`$CLIPPY_CMD\`..."
if ! $CLIPPY_CMD; then
  fail "Clippy found issues. Run \`$CLIPPY_CMD\` and fix issues."
fi
success "Clippy linter passed."
