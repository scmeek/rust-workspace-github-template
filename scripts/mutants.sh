#!/bin/sh
set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"
cd "$PROJECT_ROOT"

cargo mutants --workspace --cargo-arg=--locked
