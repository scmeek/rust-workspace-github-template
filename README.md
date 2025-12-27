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
- `main` will be the default git branch

### Considerations

- The separation between "template_lib" and "template_bin" crates is intentional,
  as this template prefers explicit API interfaces rather than shared "core" code.
  However, this, of course, can be easily modified to your liking.

## After Cloning

1. Update and uncomment `PROJECT_NAME` in `Makefile`.

2. Delete `crates/template_lib/CHANGELOG.md` and `crates/template_bin/CHANGELOG.md`.

3. Update `.github/CODEOWNERS`.

4. Update `template_bin` and `template_lib` crates.
   - Crate names and directories (if desired)
     - _Note:_ `release-plz` and `cargo-semver-check` look at `crates.io` so be
       conscious of that when selecting names if you are not planning to publish
   - Update "`bin`" crate dependency to "`lib`" crate
   - Update `release-plz.toml` to new names
   - Update each crate's `README.md`
     - `README.md` are exported in Rust docs for its crate

5. Update workspace `Cargo.toml`.
   - `workspace.package` section
   - `workspace.metadata` section

6. Use GitHub pages for docs and benchmark
   1. Create `gh-pages` branch

      ```sh
      git checkout --orphan gh-pages
      git rm -rf .
      git commit --allow-empty -m "Initial commit"
      git push -u origin gh-pages
      ```

   2. Create ruleset for `gh-pages`
   3. Configure GitHub repo settings for GitHub Pages
      - Deploy from a branch (`gh-pages`)
   4. Enable deploying documentation in `documentation-generate.yml`
   5. Update `benchmark.yml` to enable historical storage and PR comments of benchmarks

7. Update `LICENSE`.

8. Update or replace this `README.md`.

9. Update GitHub repo settings
   - Pull Request settings
     - Disallow merge commits and rebase merging
     - Only allow squash merging
     - Default commit message should be Pull Request title (or some variation)
     - Always suggest updating pull request branches
     - Automatically delete head branches
   - Ruleset
     - Default branch
       - Require linear history
       - Require pull request before merging
       - Require review from code owners
       - Squash as the allowed merge method for Pull Requests
       - Require status checks to pass
         - audit
         - benchmark-compare-pr
         - format-check
         - licenses-check
         - lint-check
         - pr-title-validate
         - unused-dependencies-check
         - zizmor
         - test (macos-latest)
         - test (ubuntu-latest)
         - test (windows-latest)
       - Require branches to be up to date before merging
       - Block for pushes
   - Workflow permissions (Settings → Actions → General)
     - Read and write permissions
       - For `gh-pages` updates
     - Allow GitHub Actions to create and approve pull requests

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
