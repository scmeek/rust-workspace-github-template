#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname -- "$(readlink -f -- "$0")")}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"

. "${SCRIPTS_DIR}/functions.sh"

if [ -z "${RUST_SCOPE+x}" ]; then
  RUST_SCOPE="--all-targets --all-features"
fi

echo ""

BENCHMARK_WALLTIME_CMD="cargo criterion" # Also in dependencies.sh
info "Running wall-time benchmarks..."
if ! $BENCHMARK_WALLTIME_CMD; then
  fail "Wall-time benchmarks failed."
fi
success "Wall-time benchmarks successfully ran."
