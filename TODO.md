# Template improvement roadmap

Work through these in order, keeping independent improvements reviewable. This
is a temporary development roadmap; delete it after completion (see item 9).

## 1. Manual project initialization

- [x] Document manual setup after GitHub's “Use this template”, with no initializer or Python dependency.
- [x] Cover crate names and paths, Rust imports, manifests, lockfile, release configuration, ownership, and documentation.
- [x] Explain publishing defaults and remaining GitHub repository setup.
- [x] Include commands to validate the customized workspace and find leftover template identifiers.

## 2. Toolchain configuration

- [x] Add `rust-toolchain.toml` and centralize the development toolchain and components.
- [x] Keep minimum-supported-Rust testing separate from the development toolchain.
- [x] Adopt resolver 3 for Rust-version-aware dependency selection.

## 3. CI scope and maintenance

- [x] Keep PR checks focused: formatting, Clippy, three-OS tests, Linux coverage, dependency policy, semver compatibility, and workflow validation.
- [x] Move broader toolchain/feature matrices and release tests to scheduled runs.
- [x] Make benchmarking and Pages explicit setup choices while keeping release automation as a core template opinion.
- [x] Cancel superseded PR runs and provide a stable aggregate required check.
- [x] Run formatting on one pinned toolchain.

## 4. Dependency policy

- [x] Replace the custom license checker with `cargo-deny` and an explicitly reviewed policy.
- [x] Consolidate overlapping advisory, license, dependency-ban, and source checks.

## 5. Lint policy

- [x] Remove redundant lint groups and document the pedantic policy and exceptions.
- [x] Use `deny` rather than `forbid` for unwrap/expect to permit justified local exceptions.
- [x] Review blanket arithmetic, indexing, division, and loop restrictions.
- [x] Prefer reasoned `#[expect]` exceptions and check unfulfilled expectations.
- [x] Enable strict rustdoc checks.

## 6. Developer experience

- [x] Make scripts independent of the caller's working directory and handle paths containing spaces.
- [x] Replace Make with `just`, preserving recipes and aliases.
- [x] Add formatting application and aggregate checks.
- [ ] Add tool diagnostics.
- [x] Support Git worktrees and preserve existing hooks during installation.
- [x] Make pre-push checks lightweight and optional; separate coverage from routine tests.
- [ ] Separate core development tooling from benchmark/release tooling and pin tool versions.

## 7. Example organization

Keep the example minimal; expanding its behavior and test coverage is out of scope.

- [x] Keep the two-crate layout with a thin binary and reusable library behavior.
- [x] Remove unused dependency suggestions and placeholder metadata from the baseline.

## 8. Additional tooling

- [ ] Add `actionlint` and ShellCheck alongside zizmor.
- [ ] Evaluate `cargo-machete` for fast checks and keep `udeps` optional.
- [ ] Add `typos` for documentation and source spelling.
- [ ] Investigate `cargo-careful`, `cargo-mutants`, `hydro`, and Miri; add the tools that are appropriate for this template.

## 9. Roadmap cleanup

- [ ] Delete this `TODO.md` once all roadmap items are complete and committed.
