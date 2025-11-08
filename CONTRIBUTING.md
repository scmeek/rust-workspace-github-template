# Contributing

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct (see `CODE_OF_CONDUCT.md`).

## Getting Started

### Prerequisites

- Rust (latest stable version recommended)
- Git
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

- Follow the official [Rust Style Guide](https://doc.rust-lang.org/nightly/style-guide/)
- Properly format code (`make format`)
- Pass all lints (`make lint`)
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
