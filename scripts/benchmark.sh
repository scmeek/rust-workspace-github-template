#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

if [ -z "${RUST_SCOPE+x}" ]; then
  RUST_SCOPE="--all-targets --all-features"
fi

echo ""

BENCHMARK_CMD="cargo criterion" # Also in dependencies.sh
info "Running benchmarks..."
if ! $BENCHMARK_CMD; then
  fail "Benchmarks failed."
fi
final_success "Benchmarks successfully ran."
