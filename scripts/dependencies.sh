#!/bin/bash

set -euo pipefail

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

# Install llvm-tools-preview (required for llvm-cov)
rustup component add llvm-tools-preview

cargo install --locked cargo-audit
cargo install --locked cargo-llvm-cov
cargo install --locked cargo-nextest
cargo install --locked cargo-semver-checks
cargo install --locked cargo-udeps
cargo install --locked cargo-workspace-lints
cargo install --locked release-plz
