# Rust Workspace Github Template

This repository is intended to be a template for Rust projects hosted on GitHub.

## After Cloning

1. Update and uncomment `PROJECT_NAME` in `Makefile`

2. If using a different primary git branch than `main`, update `scripts/version-check.sh`

3. Update `.github/CODEOWNERS`

4. Update `bin` and `lib` crates
   - Crate names and directories (if desired)
   - Update "`bin`" crate dependency to "`lib`" crate
   - Update `release-plz.toml` to new names
   - Update `.github/workflows/release-plz.yml` to new names

5. Update workspace `Cargo.toml`
   - `authors`

6. Update `LICENSE`

7. Update/replace this `README.md`

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
