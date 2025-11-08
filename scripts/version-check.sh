#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

PRIMARY_BRANCH_NAME="main"

echo ""

info "Running semantic versioning check..."

LAST_GIT_HASH=$(git rev-parse "${PRIMARY_BRANCH_NAME}")

SEMVER_CHECK_CMD="cargo semver-checks --all-features --baseline-rev $LAST_GIT_HASH" # Also in dependencies.sh
if ! $SEMVER_CHECK_CMD; then
  fail "Semantic versioning check failed.. Run \`$SEMVER_CHECK_CMD\` and fix issues."
fi
success "Semantic versioning check passed."
