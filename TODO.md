# Template improvement roadmap

Work through these in order, keeping independent improvements reviewable. This
roadmap belongs to the template; generated projects can remove it.

## 1. Manual project initialization

- [x] Document manual setup after GitHub's “Use this template”, with no initializer or Python dependency.
- [x] Cover crate names and paths, Rust imports, manifests, lockfile, release configuration, ownership, and documentation.
- [x] Explain publishing defaults and remaining GitHub repository setup.
- [x] Include commands to validate the customized workspace and find leftover template identifiers.

## 2. Toolchain configuration

- [ ] Add `rust-toolchain.toml` and centralize the development toolchain and components.
- [ ] Keep minimum-supported-Rust testing separate from the development toolchain.
- [ ] Adopt resolver 3 for Rust-version-aware dependency selection.

## 3. CI scope and maintenance

- [ ] Keep PR checks focused: formatting, Clippy, three-OS tests, Linux coverage, dependency policy, and workflow validation.
- [ ] Move broader toolchain/feature matrices and release tests to scheduled runs.
- [ ] Make benchmarking, Pages, and release automation explicit setup choices.
- [ ] Cancel superseded PR runs and provide a stable aggregate required check.
- [ ] Run formatting on one pinned toolchain.

## 4. Dependency policy

- [ ] Replace the custom license checker with `cargo-deny` and an explicitly reviewed policy.
- [ ] Consolidate overlapping advisory, license, dependency-ban, and source checks.

## 5. Lint policy

- [ ] Remove redundant lint groups and document the pedantic policy and exceptions.
- [ ] Use `deny` rather than `forbid` for unwrap/expect to permit justified local exceptions.
- [ ] Review blanket arithmetic, indexing, division, and loop restrictions.
- [ ] Permit intentional binary output with a specific justification.
- [ ] Prefer reasoned `#[expect]` exceptions and check unfulfilled expectations.
- [ ] Enable strict rustdoc checks.
- [ ] Replace silent overflow fallback in the example with explicit failure and boundary tests.

## 6. Developer experience

- [ ] Make scripts independent of the caller's working directory and handle paths containing spaces.
- [x] Replace Make with `just`, preserving recipes and aliases.
- [ ] Add formatting application, aggregate checks, and tool diagnostics.
- [ ] Support Git worktrees and preserve existing hooks during installation.
- [ ] Make pre-push checks lightweight and optional; separate coverage from routine tests.
- [ ] Separate core development tooling from benchmark/release tooling and pin tool versions.

## 7. Example organization

- [ ] Keep the two-crate layout with a thin binary and reusable library behavior.
- [ ] Demonstrate a documented public API, typed failure, a doctest, and a process-level CLI test.
- [ ] Remove unused dependency suggestions and placeholder metadata from the baseline.

## 8. Additional tooling

- [ ] Add `actionlint` and ShellCheck alongside zizmor.
- [ ] Evaluate `cargo-machete` for fast checks and keep `udeps` optional.
- [ ] Add `typos` for documentation and source spelling.
- [ ] Add `assert_cmd` with the CLI integration-test example.
- Optional follow-up: use `proptest` when the example has useful invariants; avoid speculative dependencies.
