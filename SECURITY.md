# Security Policy for Globomantics Web App

## Supported Versions

This project is currently in active development. We provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 2.x     | :white_check_mark: |
| 1.x     | :x:                |

## Reporting a Vulnerability

The Globomantics team takes security vulnerabilities seriously. We appreciate your efforts to responsibly disclose your findings.

### How to Report a Vulnerability

1. **GitHub Security Advisory**: We prefer that security vulnerabilities be reported through GitHub's private vulnerability reporting feature. To report a vulnerability:
   - Go to the repository on GitHub
   - Navigate to "Security" tab
   - Select "Report a vulnerability"
   - Provide a detailed description of the vulnerability

2. **Email**: If you cannot use GitHub's private vulnerability reporting, please email security@example.com with details of the vulnerability.

### What to Include in Your Report

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if available)

### What to Expect

- We will acknowledge receipt of your vulnerability report within 48 hours
- We will provide a detailed response within 7 days
- We will prioritize based on severity and impact
- We will keep you informed about our progress

## Security Measures in This Repository

This repository implements several GitHub Advanced Security (GHAS) features:

### Dependabot Security Updates
- Automated security scans for dependencies
- Automatic pull requests for vulnerable dependencies
- Configuration in `.github/dependabot.yml`

### Code Scanning with CodeQL
- Automated code scanning to find security vulnerabilities
- Custom queries to identify application-specific issues
- Scan results available in the Security tab

### Secret Scanning
- Automatic detection of leaked credentials and secrets
- Notification system for detected secrets
- Prevention of secret leakage through commit validation

### Security Policies
- Clear reporting guidelines (this document)
- Defined responsible disclosure process
- Transparent vulnerability management

## Manually Triggering Security Scans

To manually trigger a Dependabot scan:

1. Go to the Actions tab in this repository
2. Select the "Manual Dependabot Scan" workflow
3. Click "Run workflow"
4. Select the branch to scan
5. Click "Run workflow" button

## Security Best Practices for Contributors

- Never commit credentials or secrets to the repository
- Keep dependencies updated
- Follow secure coding guidelines
- Run security tests locally before submitting PRs
- Review security warnings and address them promptly 