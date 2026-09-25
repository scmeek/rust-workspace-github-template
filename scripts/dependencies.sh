#!/bin/bash

set -euo pipefail

SCRIPTS_DIR="${SCRIPTS_DIR:-$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

# shellcheck source=scripts/functions.sh
. "${SCRIPTS_DIR}/functions.sh"

group=${1:-core}
if [ "$#" -gt 1 ]; then
  fail 'Usage: dependencies.sh [core|checks|bench|release|ci|deep|all]'
fi
case "$group" in
  core|checks|bench|release|ci|deep|all) ;;
  *) fail "Unknown tool group: $group. Choose core, checks, bench, release, ci, deep, or all." ;;
esac

# Rust components come from rust-toolchain.toml. Extra groups install only their
# own tools; use all to install every group. Cargo skips an exact version that
# is already installed, and propagates installation failures via set -e.
while read -r tool_group package version; do
  case "$tool_group" in ''|\#*) continue ;; esac
  if [ "$group" = all ] || [ "$group" = "$tool_group" ]; then
    info "Installing $package $version ($tool_group)"
    cargo install --locked "$package" --version "=$version"
  fi
done < "$SCRIPTS_DIR/tools.txt"
