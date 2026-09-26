# Contributing

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct (see `CODE_OF_CONDUCT.md`).

## Getting Started

### Prerequisites

- Rust 1.98.1 or newer
- Git
- `just` for the local check scripts (see README.md for installation)
- Core check tools (`just deps` installs pinned Cargo tools and missing workflow tools through Homebrew; see README.md for other systems)
- Familiarity with Cargo and Rust workspace projects

## Development Workflow

### Making Changes

1. Write your code following our style guidelines
2. Add tests for new functionality
3. Ensure all tests pass
4. Ensure all lints pass
5. Format your code properly to Rust guidelines
6. Update documentation if needed

### Committing Changes

Write clear, descriptive commit messages using [Conventional Commits](https://www.conventionalcommits.org):

```
<type>[optional scope][! breaking change]: <description> (#[optional issue])

[optional body]

[optional footer(s)]
```

Types: `feat`, `fix`, `build`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf`, `test`

## Code Style Guidelines

### Rust Style

Run `just check` for formatting, workspace lint inheritance, Clippy, debug tests,
doctests, rustdoc, spelling, and unused dependencies.
Run `just workflows` after changing workflows or shell scripts; it needs
actionlint and ShellCheck, included in the default `just deps` setup (see README.md).
Use `just fmt` to apply formatting and `just test-all` to include release tests.
These checks do not require the optional coverage or release tools.

The lint policy in `Cargo.toml` applies through `[lints] workspace = true` in
every crate. `cargo-workspace-lints` checks that inheritance locally and in CI.

| Checks | Purpose |
| --- | --- |
| Rust safety, future compatibility, and idiom lints | Reject unsafe code by default, ignored must-use values, immediately dropped locks, and obsolete idioms |
| Clippy `all` and `pedantic` | Cover correctness, suspicious operations, performance, readability, casts, and API conventions |
| Clippy `cargo` | Check manifest and feature conventions; publication metadata and duplicate transitive versions are exempt |
| Selected restriction lints | Catch discarded futures/errors, accidental process exits, forgotten resources, and undocumented unsafe exceptions |
| Selected nursery lints | Catch suspicious lock lifetimes, mutable pointer casts, unused collections, excessive future sizes, and needless work |
| Rustdoc | Check links, HTML, code-block syntax, and formatting mistakes |

We select individual restriction and nursery lints. The restriction group has
conflicting rules, while nursery rules are still under development; neither is
enabled wholesale. See [Clippy's guidance](https://doc.rust-lang.org/clippy/usage.html).
The lists in `Cargo.toml` document the selected checks and deliberate exceptions.

Keep errors explicit in the library and process I/O in the binary. Ordinary
arithmetic, numeric indexing, division, and loops are allowed; choose checked
operations where input can exceed valid bounds. String slicing is checked more
strictly because byte offsets can split UTF-8 characters. We do not enforce source
item ordering, ban all `as` casts, require every public item to have documentation,
or require every returned value to be consumed.
Prefer a narrowly scoped `#[expect(..., reason = "...")]` for a justified lint
exception. Unfulfilled expectations fail checks so stale exceptions get removed.
Tests may use `expect`/`unwrap` for setup failures, as configured in `clippy.toml`.
Public APIs should include error behavior and executable documentation examples.

- Follow the official [Rust Style Guide](https://doc.rust-lang.org/nightly/style-guide/)
- Check formatting (`just format`); apply formatting with `cargo fmt --all`
- Pass all lints (`just lint`)
- Write idiomatic Rust code

### Documentation

- Document all public APIs with `///` doc comments
- Include examples in documentation where appropriate
- Keep README.md up to date
- Document non-obvious code with inline comments

### Testing

- Write unit tests for all new functionality
- Maintain or improve code coverage
- Include integration tests for major features
- Test edge cases and error conditions

## Workspace Structure

This project uses a Cargo workspace. When adding new crates:

1. Add the crate directory to the workspace in the root `Cargo.toml`
2. Ensure consistent versioning across workspace members
3. Use workspace dependencies where appropriate
4. Inherit workspace lints with `[lints] workspace = true` and package publishing
   policy with `publish.workspace = true` under `[package]`

## Pull Requests

1. Use the following title format: `<type>: (#issue) short description`
2. Complete the PR description template

## Review Process

1. All PRs require at least one approval
2. CI checks must pass
3. Code coverage should not decrease significantly
4. Breaking changes require discussion and documentation

---

Thank you for contributing!
