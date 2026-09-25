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
  - Dependency bans and allowed sources, configured with the other policies in `deny.toml`
- Commit (Pull Request) standards and automated release handling
  - [Conventional Commits](https://www.conventionalcommits.org)
  - [`release-plz`](https://github.com/release-plz/release-plz)
- Modern and fast testing
  - [`nextest`](https://nexte.st)
  - [`cargo-llvm-cov`](https://github.com/taiki-e/cargo-llvm-cov) for coverage
- Optional benchmarking
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
- No external runtime dependencies; Criterion is a development dependency
- Project defaults
  - `LICENSE` file

### Assumptions

- macOS used for local development
- `main` will be the default git branch

### Workspace organization

| Location | Responsibility |
| --- | --- |
| `crates/template_lib/src/` | Reusable behavior, with unit tests beside the code |
| `crates/template_lib/benches/` | Benchmarks of the public library API |
| `crates/template_bin/src/` | Thin executable: call the library and handle process output/errors |
| `scripts/` | Shared local and CI checks; scripts resolve the workspace root themselves |
| `deny.toml` | Dependency advisory, license, ban, and source policy |
| `justfile` | Discoverable local commands delegating to Cargo or the scripts |
| `.github/workflows/` | CI orchestration and deployment/release infrastructure to configure for your project |

Keep the two crates when the application has reusable behavior. A library-only
project can remove the binary and its entries in the workspace and release
configuration. Add dependencies only to the crates that use them; share version
requirements through `[workspace.dependencies]` when useful.

The Rust 2024 workspace uses resolver 3 for Rust-version-aware dependency
selection. `Cargo.lock` is committed and routine checks use `--locked`.
The repository's `rust-toolchain.toml` pins the development toolchain and
installs rustfmt, Clippy, and `llvm-tools-preview` automatically. The
`rust-version` in `Cargo.toml` remains the compatibility floor; test that
minimum version separately when supporting older Rust releases.

## After Cloning

Use GitHub's **Use this template** button, clone your new repository, and follow
this manual setup checklist from the repository root. Project initialization
requires no helper script or Python dependency.

1. Install Rustup and `just`. Rustup will
   install the pinned toolchain and components from `rust-toolchain.toml` when
   you run commands in the repository. Install `just` with
   `cargo install --locked just`, or on macOS use `brew install just`.

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
   - Update `description` and `repository` in
     `[workspace.package]`. Set `repository` to your new GitHub repository URL
     and add publication metadata such as authors, categories, keywords, and a
     documentation URL when applicable. Each crate must opt into any new shared
     fields with `<field>.workspace = true`.
   - Keep `license` consistent with `LICENSE`.
   - Publishing is disabled in both `[workspace.package]` and `release-plz.toml`.
     Leave both `publish = false` settings for an unpublished project. To publish,
     enable both settings, verify crate-name availability, and configure registry
     authentication in the release workflow. The existing workflow only supplies
     `GITHUB_TOKEN`.
   - Run `cargo check --workspace --all-targets` to update `Cargo.lock` for the new
     package names, then review and commit the lockfile with the manifest changes.

6. Choose whether to publish docs and benchmarks with GitHub Pages (optional)
   Keep these workflows only if the project needs published documentation or
   benchmark history. Otherwise delete `documentation-generate.yml`,
   `benchmark.yml`, the benchmark configuration and dependencies, and the
   corresponding `just bench` and script entries.

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
   4. Review `documentation-generate.yml` and `benchmark.yml`: deployment is
      enabled on `main`, and both workflows share the `gh-pages` branch.

7. Configure the release automation
   Keep `release-plz.toml`, `.github/workflows/release-plz.yml`, and the
   release-specific changelog files as part of the template's release process.
   Update the package names, changelog paths, repository metadata, and
   publishing settings for the new project. Publishing remains disabled until
   the project explicitly enables it and configures registry authentication.
   Semver checking remains an independent pull request safeguard for library
   APIs.

8. Update `LICENSE`.

9. Update or replace this `README.md`. Review `CONTRIBUTING.md`,
   `CODE_OF_CONDUCT.md`, `SECURITY.md`, and `.github/ISSUE_TEMPLATE/` for project
   policies, contacts, and links. Enable the repository features those documents
   reference, such as Discussions and private vulnerability reporting, or adjust
   the documents. The template's [TODO.md](TODO.md) roadmap can be removed from
   your new project.

10. Update GitHub repo settings
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
         - CI / Required checks
       - Require branches to be up to date before merging
       - Block for pushes
   - Workflow permissions (Settings → Actions → General)
     - Keep the default token read-only; workflows request their required permissions.
     - Allow GitHub Actions to create and approve pull requests

11. Verify the customized workspace before committing.

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

2. Install the workspace lint checker, then run routine checks with Rust's
   rustfmt and Clippy components and `just`

   ```sh
   cargo install --locked cargo-workspace-lints
   just check
   ```

3. Apply formatting or run individual checks

   ```sh
   just fmt
   just build test
   ```

`just test` runs debug tests and doctests; `just test-all` also runs release tests.
`just coverage` collects coverage separately and requires `cargo-llvm-cov`; the
repository toolchain file supplies `llvm-tools-preview`. CI also exercises
tests through nextest.
`just deps` installs the broader audit, coverage, benchmark, and release tools;
it is optional for routine development. To install only the dependency policy
checker, run `cargo install --locked cargo-deny --version 0.20.2`. `just audit`
runs all four checks; `just licenses` runs only the license check. CI runs the
same policy check for pull requests and pushes to `main`.

Workflow security findings fail CI directly, without requiring GitHub Advanced
Security or a separate code-scanning ruleset.

Install the optional pre-push hook with `just hooks`. It runs formatting, lint,
and debug test checks and preserves any existing hook. Git worktrees and custom
hook paths are supported. Use `SKIP_PRE_PUSH=true git push` to bypass local checks
when needed; CI still runs. The hook checks the working tree, so it normally
requires a clean tree (`SKIP_UNCOMMITTED_CHECK=true` bypasses that guard).

Dependency policy lives in `deny.toml` and covers all workspace crates, features,
platforms, and development dependencies. The initial license allowlist is MIT,
Apache-2.0, and Unicode-3.0; review additions for your project's needs. `cargo-deny`
evaluates SPDX expressions and can identify licenses from license files. Unknown
or unapproved licenses fail the check. Private workspace crates are checked too.
Sources are restricted to crates.io unless explicitly approved. Wildcard version
requirements fail, with an exception for path or approved Git dependencies in
unpublished crates and development dependencies; duplicate versions produce
warnings. Yanked crates and unmaintained or unsound advisories fail the check.
No crate-specific bans or advisory exceptions are configured initially. Document reasons when adding
exceptions. Advisory checks fetch the RustSec database and require network access.
