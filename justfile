set quiet

export PROJECT_ROOT := justfile_directory()
export SCRIPTS_DIR := PROJECT_ROOT / "scripts"

# Display available recipes
help:
    @just --list

alias h := help
alias a := audit
alias d := docs
alias f := format
alias l := lint
alias t := test
alias v := version
alias b := build

# Run routine Rust, spelling, and unused dependency checks
check: format lint test docs spelling unused

# Apply formatting
fmt:
    cargo fmt --all

# Attach git hooks
hooks:
    "$SCRIPTS_DIR/hooks.sh"

# Install development tools: core (default), checks, bench, release, ci, deep, or all
deps group="core":
    "$SCRIPTS_DIR/dependencies.sh" {{quote(group)}}

# Diagnose local tool availability and pinned versions without installing anything
doctor:
    "$SCRIPTS_DIR/doctor.sh"

# Check dependency advisories, licenses, bans, and sources
audit:
    "$SCRIPTS_DIR/audit.sh"

# Generate documentation
docs:
    "$SCRIPTS_DIR/documentation-generate.sh"

# Check formatting
format:
    "$SCRIPTS_DIR/format-check.sh"

# Check lints
lint:
    "$SCRIPTS_DIR/lint-check.sh"

# Run tests and doctests (debug build)
test:
    SKIP_RELEASE_TEST=true "$SCRIPTS_DIR/test.sh"

# Run all tests (include release build)
test-all:
    "$SCRIPTS_DIR/test.sh"

# Check dependency licenses
licenses:
    "$SCRIPTS_DIR/audit.sh" licenses

# Check semantic versioning
version baseline="origin/main":
    "$SCRIPTS_DIR/version-check.sh" {{quote(baseline)}}

# Build all workspace crates
build:
    cargo build --locked --workspace

# Collect coverage (requires cargo-llvm-cov and llvm-tools-preview)
coverage:
    cargo llvm-cov --locked --workspace --all-features --all-targets

# Run benchmarks
bench:
    "$SCRIPTS_DIR/benchmark.sh"

# Check GitHub Actions and shell scripts (requires actionlint and ShellCheck)
workflows:
    sh "$SCRIPTS_DIR/workflow-check.sh"

# Check documentation and source spelling
spelling:
    typos --hidden

# Quickly find unused dependencies without compiling
unused:
    cargo machete

# Compiler-based unused dependency analysis (requires nightly and deps deep)
udeps:
    cargo +nightly udeps --locked --workspace --all-targets --all-features

# Evaluate test effectiveness (requires deps deep; results in mutants.out)
mutants:
    sh "$SCRIPTS_DIR/mutants.sh"

# Interpret library and binary tests for undefined behavior (requires nightly Miri)
miri:
    cargo +nightly miri test --locked --workspace --lib --bins

# Run tests with extra runtime checks (requires deps deep and nightly rust-src)
careful:
    sh "$SCRIPTS_DIR/careful.sh"
