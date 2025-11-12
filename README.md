# Rust Workspace Github Template

This repository is intended to be a template for Rust projects hosted on GitHub.

## Template Features

- `Make` for project interactions, except for `cargo`-native actions
- Local and CI implementations
  - Pre-push git hooks for fast feedback
  - Fast CI workflows for near-immediate Pull Request validations
  - GitHub Actions static analysis and auditing
    - [zizmor](https://github.com/zizmorcore/zizmor)
- Strict workspace-wide linting configuration
- Dependency auditing
  - Unused dependencies
  - Dependency vulnerability checks
  - Dependency licenses
- Commit (Pull Request) standards and automated Release handling
  - [Conventional Commits](https://www.conventionalcommits.org)
  - [`release-plz`](https://github.com/release-plz/release-plz)
- Modern and fast testing
  - [`nextest`](https://nexte.st)
  - [`cargo-llvm-cov`](https://github.com/taiki-e/cargo-llvm-cov) for coverage
- Benchmarking
  - [`criterion`](https://docs.rs/criterion/latest/criterion/)
- GitHub templates
  - `CODEOWNERS`
  - Dependabot
  - Pull request template
  - Bug report template
  - Feature request template
  - Security policy
  - Code of conduct
  - Contributing guidelines
- Sensible default dependencies
- Project defaults
  - `LICENSE` file

### Assumptions

- macOS used for local development

### Considerations

- The separation between "lib" and "bin" crates is intentional, as this template
  prefers explicit API interfaces rather than shared "core" code. However, this,
  of course, can be easily modified to your liking.

## After Cloning

1. Update and uncomment `PROJECT_NAME` in `Makefile`.

2. If using a different primary git branch than `main`, update
   `scripts/version-check.sh`.

3. Update `.github/CODEOWNERS`.

4. Update `bin` and `lib` crates.
   - Crate names and directories (if desired)
   - Update "`bin`" crate dependency to "`lib`" crate
   - Update `release-plz.toml` to new names
   - Update `.github/workflows/release-plz.yml` to new names

5. Update workspace `Cargo.toml`.
   - `workspace.package` section
   - `workspace.metadata` section

6. Update `benchmark.yml` to enable historical storage and PR comments of
   benchmarks, if desired.

7. Update `LICENSE`.

8. Update or replace this `README.md`.

## Project Getting Started

1. Interact with the repo

   ```sh
   make help
   ```

2. Initialize your development environment

   ```sh
   make hooks
   make deps
   ```
