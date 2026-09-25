#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

# shellcheck source=scripts/functions.sh
. "${SCRIPTS_DIR}/functions.sh"

if [ -z "${RUST_SCOPE+x}" ]; then
  RUST_SCOPE="--all-targets --all-features"
fi

echo ""

CHECK_CMD="cargo check --locked --workspace $RUST_SCOPE"
info "Checking workspace lint inheritance..."
if ! cargo workspace-lints; then
  fail "Workspace lint inheritance check failed. Ensure each crate has [lints] workspace = true and cargo-workspace-lints is installed (cargo install --locked cargo-workspace-lints)."
fi

info "Checking code compilation with \`$CHECK_CMD\`..."
if ! $CHECK_CMD; then
  fail "Code did not compile. Run \`$CHECK_CMD\` and fix issues."
fi
success "Code compiles."

echo ""

CLIPPY_CMD="cargo clippy --locked --workspace $RUST_SCOPE -- -D warnings"
info "Running clippy linter with \`$CLIPPY_CMD\`..."
if ! $CLIPPY_CMD; then
  fail "Clippy found issues. Run \`$CLIPPY_CMD\` and fix issues."
fi
success "Clippy linter passed."

final_success "Compilation and Clippy checks passed."
