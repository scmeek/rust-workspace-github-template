# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Which versions are eligible for receiving such patches depends on the CVSS v3.0 Rating:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security seriously. If you believe you have found a security vulnerability, please report it to us as described below.

### Where to Report

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via the following method:

#### GitHub Security Advisories

- Navigate to the Security tab of this repository
- Click "Report a vulnerability"
- Fill out the advisory form

### What to Include

Please include the following information in your report:

- Type of issue (e.g. buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

This information will help us triage your report more quickly.

## Security Advisories

Security advisories will be published on:

- GitHub Security Advisories for this repository
- The project's release notes

## Bug Bounty Program

Currently, we do not have a bug bounty program. However, we deeply appreciate the security research community's efforts in helping us stay secure.

## Dependencies

We use `cargo audit` in our CI/CD pipeline to check for known vulnerabilities in our dependencies. You can also run it locally:

```bash
make deps
make audit
```

## Security Best Practices for Users

We recommend:

1. Always use the latest stable version
2. Regularly update dependencies using `cargo update`
3. Run `cargo audit` to check for known vulnerabilities in dependencies
4. Follow the principle of least privilege when deploying
5. Keep your Rust toolchain updated
6. Review our security advisories regularly

## Hall of Fame

We would like to thank the following individuals for responsibly disclosing security issues:

- [Name/Handle] - [Brief description of issue] - [Date]

## Comments on This Policy

If you have suggestions on how this policy could be improved, please submit a pull request or open an issue to discuss.
