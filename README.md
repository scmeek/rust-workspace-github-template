# Rust Workspace Github Template

This repository is intended to be a template for Rust projects hosted on GitHub.

## Template Features

- `just` for project interactions, except for `cargo`-native actions
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

Use GitHub's **Use this template** button, clone your new repository, and follow
this manual setup checklist from the repository root. Project initialization
requires no helper script or Python dependency.

1. Install Rust 1.96 or newer, `just`, and `jq` (used by the license checker).
   Install `just` with `cargo install --locked just`, or on macOS install both
   tools with `brew install just jq`.

2. Delete `crates/template_lib/CHANGELOG.md` and `crates/template_bin/CHANGELOG.md`.

3. Replace `@scmeek` in `.github/CODEOWNERS` with your GitHub username or a team
   with access to the repository.

4. Rename the crates consistently. For example, for a project named
   `weather-station`, use `weather-station-lib` and `weather-station-bin`.
   - Set `[package].name` in both `crates/*/Cargo.toml` files.
   - Rename the `template_lib` dependency key in both `[workspace.dependencies]`
     in the root `Cargo.toml` and `[dependencies]` in the binary's manifest to
     `weather-station-lib`, retaining `.workspace = true` in the binary.
   - Update imports in `crates/template_bin/src/main.rs` and
     `crates/template_lib/benches/criterion_benches.rs` to
     `use weather_station_lib::add;`. Rust imports use underscores for hyphens
     in package names.
   - Directories may retain their existing names. If you rename them, also update
     `[workspace].members`, the library's dependency `path`, and both
     `changelog_path` values in `release-plz.toml`.
   - Update both package names in `release-plz.toml` and the `package` input and
     step label in `.github/workflows/semver-check.yml`.
   - Update each crate's `README.md`; these files are included in crate rustdocs.

5. Update workspace `Cargo.toml`.
   - Replace `description`, `authors`, `repository`, categories, and keywords in
     `[workspace.package]`. Set `repository` to your new GitHub repository URL
     and set `documentation` to your documentation URL, or remove it until ready.
   - Keep `license` consistent with `LICENSE`.
   - Replace or remove the placeholder maintainers, resources, tags, and notes
     in `[workspace.metadata]`.
   - Publishing is disabled in both `[workspace.package]` and `release-plz.toml`.
     Leave both `publish = false` settings for an unpublished project. To publish,
     enable both settings, verify crate-name availability, and configure registry
     authentication in the release workflow. The existing workflow only supplies
     `GITHUB_TOKEN`.
   - Run `cargo check --workspace --all-targets` to update `Cargo.lock` for the new
     package names, then review and commit the lockfile with the manifest changes.

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
   4. Review `documentation-generate.yml` and `benchmark.yml`: deployment is enabled
      on `main`, and both workflows share the `gh-pages` branch.

7. Update `LICENSE`.

8. Update or replace this `README.md`. Review `CONTRIBUTING.md`,
   `CODE_OF_CONDUCT.md`, `SECURITY.md`, and `.github/ISSUE_TEMPLATE/` for project
   policies, contacts, and links. Enable the repository features those documents
   reference, such as Discussions and private vulnerability reporting, or adjust
   the documents. The template's [TODO.md](TODO.md) roadmap can be removed from
   your new project.

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
         - semver-check
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

10. Verify the customized workspace before committing.

    ```sh
    cargo fmt --all --check
    cargo check --workspace --all-targets --locked
    cargo test --workspace --locked
    cargo clippy --workspace --all-targets --locked -- -D warnings
    git grep -n -E 'template_lib|template_bin|rust-workspace-github-template|scmeek'
    git diff --check
    git diff
    ```

    Review any remaining template references; directory paths are expected if
    you kept the original directory names. `git grep` exits with status 1 when
    no matches remain. Run the local checks below after installing their tools.

## Project Getting Started

1. Interact with the repo

   ```sh
   just
   ```

2. Initialize your development environment

   ```sh
   just hooks
   just deps
   ```

3. Run local checks

   ```sh
   just format lint test licenses
   sh scripts/tests/licenses-check.sh
   ```

The license checker compares complete SPDX expressions against the explicit list
in `scripts/licenses-check.sh`. Missing licenses and new expressions fail the
check and require review, including dependencies that only specify a custom
license file.
