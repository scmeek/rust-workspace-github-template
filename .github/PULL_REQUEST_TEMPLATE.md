## Description and Motivation

<!-- Closes <#issue>. Please include a summary of the changes and the related issue. Include relevant motivation and context. -->

## Implementation Details

-

## Testing Details

<!-- Please describe the tests that you ran to verify your changes, including steps for others to reproduce. -->

## Checklist

- [ ] My PR title and commits are formatted correctly
  - PR title format follows the format defined in `CONTRIBUTING.md`
  - Commits follow the [Conventional Commits](https://www.conventionalcommits.org/) specification
    - ✨ `feat:` for new features
    - 🪲 `fix:` for bug fixes
    - 📜 `docs:` for documentation changes
    - ⚡️ `perf`: for performance improvement
    - 🧩 `refactor:` for code refactoring
    - 🤖 `ci:` for CI/CD changes
    - 🧺 `chore:` for maintenance tasks
    - 💥 **Add `!` after type in PR title for breaking changes**
      - Fix or feature that would cause existing functionality to not work as
        it previously did
- [ ] I have run `make version` locally to check for appropriate applied type above
  - **I have NOT updated version numbers in `Cargo.toml`**
    - These are managed automatically by `release-plz`
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have made corresponding changes to the documentation
  - I have commented my code, particularly in hard-to-understand areas
- [ ] New and existing unit tests pass locally with my changes
  - New tests have been added that prove the fix is effective or that the
    feature works
  - Unit and integration tests pass
  - All lints pass and code is formatted properly
  - Documentation builds
  - Benchmarks run
  - My changes generate no new warnings
- [ ] Any dependent changes have been merged and published

## Additional Notes & Related Issues

<!-- Related <#issue(s)> -->
