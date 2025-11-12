#!/bin/sh

set -eu

# A Rust hook script to verify what is about to be pushed. Called by "git
# push" after it has checked the remote status, but before anything has been
# pushed. If this script exits with a non-zero status nothing will be pushed.
#
# This hook is called with the following parameters:
#
# $1 -- Name of the remote to which the push is being done
# $2 -- URL to which the push is being done
#
# If pushing without using a named remote those arguments will be equal.
#
# Information about the commits which are being pushed is supplied as lines to
# the standard input in the form:
#
#   <local ref> <local sha1> <remote ref> <remote sha1>
#
# This file is intended to closely follow a format/lint/test CI/CD step.

_REMOTE="${1:-}"
_URL="${2:-}"

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

if [ "${SKIP_UNCOMMITTED_CHECK:-false}" != "true" ] && [ -n "$(git status --porcelain)" ]; then
  text="Uncommitted changes detected in your working directory. Stash or commit
   them or silence this warning set:
    SKIP_UNCOMMITTED_CHECK=true"
  fail "${text}"
fi

"${SCRIPTS_DIR}/format-check.sh"
"${SCRIPTS_DIR}/lint-check.sh"
SKIP_RELEASE_TEST=true "${SCRIPTS_DIR}/test.sh"

echo ""
final_success "Pre-push checks passed. Proceeding with push."
