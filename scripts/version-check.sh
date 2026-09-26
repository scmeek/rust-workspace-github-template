#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

# shellcheck source=scripts/functions.sh
. "${SCRIPTS_DIR}/functions.sh"

baseline="${1:-origin/main}"

echo ""

info "Running semantic versioning check..."

if ! baseline_sha=$(git rev-parse --verify --end-of-options "${baseline}^{commit}"); then
  fail "Cannot resolve baseline '$baseline'. Fetch origin or pass a local revision: just version <revision>."
fi

# Explicit selection includes the library even when publish = false.
if ! cargo semver-checks --package template_lib --all-features --baseline-rev "$baseline_sha"; then
  fail "Semantic versioning check failed against $baseline. Review the diagnostics above."
fi
final_success "Semantic versioning check passed."
