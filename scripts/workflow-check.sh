#!/bin/sh
set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"
cd "$PROJECT_ROOT"

# actionlint silently skips embedded-shell analysis when ShellCheck is missing.
for tool in shellcheck actionlint; do
  if ! command -v "$tool" >/dev/null; then
    printf 'Missing %s. Install actionlint and ShellCheck; see README.md.\n' "$tool" >&2
    exit 1
  fi
done
actionlint
shellcheck scripts/*.sh scripts/pre-push-hook
