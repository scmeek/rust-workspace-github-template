#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

hook_path=$(git rev-parse --git-path hooks/pre-push)
hook_source="$SCRIPTS_DIR/pre-push-hook"

if [ -e "$hook_path" ] || [ -L "$hook_path" ]; then
  if cmp -s "$hook_source" "$hook_path"; then
    chmod +x "$hook_path"
    final_success "Pre-push hook is already installed."
  fi
  fail "An existing hook was preserved at $hook_path. Integrate scripts/git-pre-push.sh manually."
fi

mkdir -p "$(dirname -- "$hook_path")"
cp "$hook_source" "$hook_path"
chmod +x "$hook_path"
final_success "Installed optional pre-push checks. Use SKIP_PRE_PUSH=true to bypass them."
