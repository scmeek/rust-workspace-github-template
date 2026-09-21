#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

cd "$PROJECT_ROOT"

command -v jq >/dev/null 2>&1 || fail "Install jq to check dependency licenses."

# Exact SPDX expressions approved by this template. Review new expressions before
# adding them; deliberately do not treat these strings as regular expressions.
ALLOWED_LICENSES="
MIT
Apache-2.0
Apache-2.0 OR MIT
MIT OR Apache-2.0
MIT OR Unlicense
Apache-2.0 OR BSD-2-Clause OR MIT
Apache-2.0 OR BSL-1.0
(Apache-2.0 OR MIT) AND Unicode-3.0
BSD-2-Clause
BSD-3-Clause
ISC
GPL-2.0
GPL-2.0+
GPL-2.0-only
GPL-2.0-or-later
GPL-3.0
GPL-3.0+
GPL-3.0-only
GPL-3.0-or-later
LGPL-2.0
LGPL-2.0+
LGPL-2.0-only
LGPL-2.0-or-later
LGPL-2.1
LGPL-2.1+
LGPL-2.1-only
LGPL-2.1-or-later
LGPL-3.0
LGPL-3.0+
LGPL-3.0-only
LGPL-3.0-or-later
AGPL-3.0
AGPL-3.0+
AGPL-3.0-only
AGPL-3.0-or-later
MPL-2.0
CDDL-1.0
EPL-1.0
EPL-2.0
EUPL-1.2
WTFPL
Unlicense
0BSD
CC0-1.0
Zlib
BSL-1.0
NCSA
"

echo ""

info "Running dependency licenses check..."

if ! license_output=$(cargo license --json --all-features); then
  fail "Could not read dependency licenses."
fi

# Reject malformed or empty reports instead of silently checking no dependencies.
if ! printf '%s\n' "$license_output" | jq -e '
  type == "array" and length > 0 and all(.[];
    (.name | type == "string") and
    (.version | type == "string") and
    (.license == null or (.license | type == "string")))
' >/dev/null; then
  fail "Invalid dependency license report."
fi

echo ""
echo "📋 Dependency Licenses:"
printf '%s\n' "$license_output" | jq -r '.[] | "\(.name) v\(.version): \(.license // "NO LICENSE SPECIFIED")"'
echo ""

violations=$(printf '%s\n' "$license_output" | jq -r --arg allowed "$ALLOWED_LICENSES" '
  ($allowed | split("\n") | map(select(length > 0))) as $approved |
  .[] | .license as $license |
  select($license == null or ($approved | index($license)) == null) |
  "\(.name) v\(.version): \(.license // "NO LICENSE SPECIFIED")"
')

if test -n "$violations"; then
  error "$violations"
  fail "Found missing or unapproved license expressions. Review scripts/licenses-check.sh."
fi

final_success "All dependencies use approved open-source licenses"
