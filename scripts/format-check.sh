#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

# shellcheck source=scripts/functions.sh
. "${SCRIPTS_DIR}/functions.sh"

echo ""

FMT_CMD="cargo fmt --all --check"
info "Checking formatting with \`$FMT_CMD\`..."
if ! $FMT_CMD; then
  fail "Code is not properly formatted. Run \`cargo fmt --all\` to apply formatting."
fi
final_success "Code is properly formatted."
