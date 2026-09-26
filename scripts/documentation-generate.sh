#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

# shellcheck source=scripts/functions.sh
. "${SCRIPTS_DIR}/functions.sh"

if [ -z "${RUST_DOC_SCOPE+x}" ]; then
  RUST_DOC_SCOPE="--all-features"
fi

echo ""

RUSTDOCFLAGS="${RUSTDOCFLAGS:-} -D warnings"
export RUSTDOCFLAGS
DOC_CMD="cargo doc --locked --workspace --no-deps $RUST_DOC_SCOPE"
info "Generating documentation with \`$DOC_CMD\`..."
if ! $DOC_CMD; then
  fail "Documentation generation failed. Run \`$DOC_CMD\` and fix issues."
fi
final_success "Documentation generated successfully."
