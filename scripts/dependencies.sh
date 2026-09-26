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

# Workflow checks are part of the default development toolset, but these tools
# are native packages rather than Cargo crates. Preserve existing installations.
if [ "$group" = core ] || [ "$group" = all ]; then
  missing=()
  for tool in actionlint shellcheck; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      missing+=("$tool")
    fi
  done
  if [ "${#missing[@]}" -gt 0 ]; then
    if command -v brew >/dev/null 2>&1; then
      info "Installing workflow tools: ${missing[*]}"
      brew install "${missing[@]}"
    else
      fail "Missing workflow tools: ${missing[*]}. Install them with your system package manager or the upstream releases linked in README.md, then rerun just deps. Homebrew installations are handled automatically."
    fi
  fi
fi

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
