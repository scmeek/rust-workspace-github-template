#!/bin/sh

set -eu

SCRIPTS_DIR="${SCRIPTS_DIR:-$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)}"
PROJECT_ROOT="${PROJECT_ROOT:-$(CDPATH='' cd -- "$SCRIPTS_DIR/.." && pwd)}"
cd "$PROJECT_ROOT"

# Diagnostics must not trigger rustup's implicit toolchain installation.
export RUSTUP_AUTO_INSTALL=0
problems=0

problem() {
  printf '%s: %s\n  Fix: %s\n' "$1" "$2" "$3"
  if [ "$1" = REQUIRED ]; then
    problems=$((problems + 1))
  fi
}

check_command() {
  importance=$1
  label=$2
  fix=$3
  expected=$4
  shift 4
  if output=$("$@" 2>&1); then
    first_line=$(printf '%s\n' "$output" | head -n 1)
    # Version commands report the version as their second whitespace-delimited field.
    actual=$(printf '%s\n' "$first_line" | awk '{print $2}')
    if [ -n "$expected" ] && [ "$actual" != "$expected" ]; then
      problem "$importance" "$label: $first_line; expected $expected" "$fix"
    else
      printf 'OK: %s (%s)\n' "$label" "$first_line"
    fi
  else
    problem "$importance" "$label is missing or could not run" "$fix"
    printf '%s\n' "$output" | sed 's/^/  /'
  fi
}

check_cargo_tool() {
  tool=$1
  importance=$2
  purpose=$3
  expected=$(awk -v tool="$tool" '$1 !~ /^#/ && $2 == tool { print $3; exit }' "$SCRIPTS_DIR/tools.txt")
  if [ -z "$expected" ]; then
    printf 'Missing version pin for %s in scripts/tools.txt\n' "$tool" >&2
    exit 1
  fi
  fix="cargo install --locked $tool --version =$expected"
  if [ "$tool" = release-plz ] || [ "$tool" = cargo-workspace-lints ]; then
    # workspace-lints exposes --version on its binary, not its Cargo subcommand.
    check_command "$importance" "$tool ($purpose)" "$fix" "$expected" "$tool" --version
  else
    check_command "$importance" "$tool ($purpose)" "$fix" "$expected" cargo "${tool#cargo-}" --version
  fi
}

pinned=$(sed -n 's/^channel = "\([^"]*\)".*/\1/p' rust-toolchain.toml)
if [ -z "$pinned" ]; then
  printf '%s\n' 'Could not read channel from rust-toolchain.toml.' >&2
  exit 1
fi

printf '%s\n' 'Core development tools'
check_command REQUIRED Git 'Install Git and make it available on PATH.' '' git --version
check_command REQUIRED just 'cargo install --locked just' '' just --version
check_command REQUIRED rustup 'Install rustup: https://rustup.rs/' '' rustup --version
if active=$(rustup show active-toolchain 2>/dev/null); then
  case "$active" in
    "$pinned "*|"$pinned-"*) printf 'OK: active toolchain %s\n' "$active" ;;
    *) problem REQUIRED "Active toolchain is $active; expected $pinned" \
      'Remove RUSTUP_TOOLCHAIN or a rustup directory override so rust-toolchain.toml applies.' ;;
  esac
else
  problem REQUIRED "Pinned toolchain $pinned is unavailable" "rustup toolchain install $pinned --profile minimal --component rustfmt --component clippy --component llvm-tools-preview"
fi
check_command REQUIRED rustc "rustup toolchain install $pinned" "$pinned" rustc --version
check_command REQUIRED Cargo "rustup toolchain install $pinned" '' cargo --version
check_command REQUIRED rustfmt "rustup component add --toolchain $pinned rustfmt" '' cargo fmt --version
check_command REQUIRED Clippy "rustup component add --toolchain $pinned clippy" '' cargo clippy --version
check_cargo_tool cargo-workspace-lints REQUIRED 'just check / just lint'

printf '\n%s\n' 'Optional tools (not required for just check)'
check_cargo_tool cargo-deny OPTIONAL 'just audit / just licenses'
check_cargo_tool cargo-semver-checks OPTIONAL 'just version'
check_cargo_tool cargo-llvm-cov OPTIONAL 'just coverage'
if components=$(rustup component list --installed 2>/dev/null) &&
  printf '%s\n' "$components" | grep -q '^llvm-tools-'; then
  printf '%s\n' 'OK: llvm-tools-preview (just coverage)'
else
  problem OPTIONAL 'llvm-tools-preview (just coverage) is unavailable' "rustup component add --toolchain $pinned llvm-tools-preview"
fi
check_cargo_tool cargo-criterion OPTIONAL 'just bench'
check_cargo_tool cargo-nextest OPTIONAL 'CI test runner'
check_cargo_tool cargo-udeps OPTIONAL 'CI unused dependency check; execution also needs nightly'
check_cargo_tool release-plz OPTIONAL 'release automation'

printf '\n'
if [ "$problems" -gt 0 ]; then
  printf '%s required check(s) failed. Resolve them before running just check.\n' "$problems"
  exit 1
fi
printf '%s\n' 'Core tools are ready. Optional notices only affect their associated commands.'
