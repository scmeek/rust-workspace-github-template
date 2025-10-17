#!/bin/bash

set -euo pipefail

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

cargo install cargo-workspace-lints
# cargo install cargo-tarpaulin --locked
cargo install cargo-udeps --locked
