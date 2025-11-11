#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

if [ -z "${RUST_DOC_SCOPE+x}" ]; then
  RUST_DOC_SCOPE="--all-features"
fi

echo ""

DOC_CMD="cargo doc --no-deps $RUST_DOC_SCOPE"
info "Generating documentation with \`$DOC_CMD\`..."
if ! $DOC_CMD; then
  fail "Documentation generation failed. Run \`$DOC_CMD\` and fix issues."
fi
final_success "Documentation generated successfully."
