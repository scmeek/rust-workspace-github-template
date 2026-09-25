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

# Attach git hooks
hooks:
    "$SCRIPTS_DIR/hooks.sh"

# Install project dependencies
deps:
    "$SCRIPTS_DIR/dependencies.sh"

# Audit dependencies for security vulnerabilities
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

# Run tests (debug build)
test:
    SKIP_RELEASE_TEST=true "$SCRIPTS_DIR/test.sh"

# Run all tests (include release build)
test-all:
    "$SCRIPTS_DIR/test.sh"

# Check dependency licenses
licenses:
    "$SCRIPTS_DIR/licenses-check.sh"

# Check semantic versioning
version:
    "$SCRIPTS_DIR/version-check.sh"

# Show how to build the project
build:
    printf '%s\n' 'Use `cargo` to build project'

# Run benchmarks
bench:
    "$SCRIPTS_DIR/benchmark.sh"
