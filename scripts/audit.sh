#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

echo ""

info "Running dependencies audit..."

AUDIT_CMD="cargo audit" # Also in dependencies.sh
if ! $AUDIT_CMD; then
  fail "Dependencies audit failed.. Run \`$AUDIT_CMD\` and fix issues."
fi
final_success "Dependencies passed audit."
