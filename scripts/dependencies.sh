#!/bin/bash

set -euo pipefail

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

cargo install cargo-audit --locked
cargo install release-plz --locked
cargo install cargo-semver-checks --locked
cargo install cargo-tarpaulin --locked
cargo install cargo-udeps --locked
cargo install cargo-workspace-lints --locked
