#!/bin/bash

set -euo pipefail

SCRIPTS_DIR="${SCRIPTS_DIR:-$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

# Install llvm-tools-preview (required for llvm-cov)
rustup component add llvm-tools-preview

cargo install --locked cargo-deny --version 0.20.2 # Also in .github/workflows/dependency-policy.yml
cargo install --locked cargo-criterion # Also in .github/workflows/benchmark.yml
cargo install --locked cargo-llvm-cov  # Also in .github/workflows/test.yml
cargo install --locked cargo-nextest   # Also in .github/workflows/test.yml
cargo install --locked cargo-semver-checks
cargo install --locked cargo-workspace-lints # Also in lint-check.yml and nightly.yml
cargo install --locked cargo-udeps           # Also in .github/workflows/unused-dependencies-check.yml
cargo install --locked release-plz
