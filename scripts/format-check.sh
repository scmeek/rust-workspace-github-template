#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

echo ""

FMT_CMD="cargo fmt -v --check"
info "Checking formatting with \`$FMT_CMD\`..."
if ! $FMT_CMD; then
  fail "Code is not properly formatted. Run \`$FMT_CMD\` and fix issues."
fi
final_success "Code is properly formatted."
