#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

ALLOWED_LICENSES="
MIT
Apache-2.0
Apache-2.0 OR MIT
MIT OR Apache-2.0
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

is_license_allowed() {
  local license="$1"
  echo "$ALLOWED_LICENSES" | grep -q "^${license}$"
}

echo ""

info "Running dependency licenses check..."

license_output=$(cargo license 2>/dev/null) # Also in dependencies.sh

echo ""
echo "📋 Dependency Licenses:"
echo "$license_output"
echo ""

violations=0
while IFS= read -r line; do
  test -z "$line" && continue

  # Parse: "crate_name vX.Y.Z (license)"
  name=$(echo "$line" | awk '{print $1}')
  license=$(echo "$line" | sed 's/.*(\(.*\))$/\1/')

  # Skip if no license found
  test "$license" = "$line" && continue

  # Trim whitespace
  license=$(echo "$license" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  if test -z "$license"; then
    error "$name: NO LICENSE SPECIFIED"
    violations=$((violations + 1))
  elif ! is_license_allowed "$license"; then
    error "$name: $license"
    violations=$((violations + 1))
  fi
done <<EOF
$license_output
EOF

if test $violations -ne 0; then
  fail "Found $violations non-open-source or unrecognized license(s)"
fi

final_success "All dependencies use approved open-source licenses"
