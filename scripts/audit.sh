#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

# shellcheck source=scripts/functions.sh
. "${SCRIPTS_DIR}/functions.sh"

echo ""

info "Checking dependency policy..."

if ! cargo deny --locked --workspace check "$@"; then
  fail "Dependency policy check failed. Review the diagnostics and deny.toml."
fi
final_success "Dependencies passed policy checks."
