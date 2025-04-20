# Globomantics Test Web App

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub Actions Build](https://github.com/timothywarner/glob-web-pilot/workflows/Build/badge.svg)](https://github.com/timothywarner/glob-web-pilot/actions)
[![Dependabot Status](https://img.shields.io/badge/Dependabot-enabled-brightgreen.svg)](https://github.com/timothywarner/glob-web-pilot/network/updates)
[![CodeQL](https://github.com/timothywarner/glob-web-pilot/workflows/CodeQL/badge.svg)](https://github.com/timothywarner/glob-web-pilot/security/code-scanning)
[![Security Policy](https://img.shields.io/badge/Security-Policy-red.svg)](https://github.com/timothywarner/glob-web-pilot/security/policy)

> A Node.js/Express demonstration application for Pluralsight's GitHub Advanced Security (GHAS) course.

## 🔒 Security Features

This repository demonstrates GitHub Advanced Security (GHAS) best practices:

- **Dependabot Alerts & PRs**: Automatically detects vulnerable dependencies and creates pull requests with updates
- **CodeQL Analysis**: Identifies potential security vulnerabilities in code with static analysis
- **Secret Scanning**: Prevents accidental commit of credentials and tokens
- **SARIF Integration**: Standardized security scan results format
- **Branch Protection Rules**: Requires security checks to pass before merging
- **Required Approvals**: Multiple eyes on all code changes
- **Security Policies**: Clear documentation for reporting vulnerabilities

## Running and Testing Locally:

You can use these commands to install, test, and run the app locally. (Not Required)

### Install

```
npm install
```

### Test

```
npm test
```

![alt text](https://user-images.githubusercontent.com/5126491/51065379-c1743280-15c1-11e9-80fd-6a3d7ab4ac1b.jpg "Unit Test")

Navigate to the `/test` folder to review the unit tests for this project. These tests will run as part of your GitHub Actions workflow. See `.github/workflows/` directory for CI/CD configuration.

### Start

```
npm start
```

## 🛡️ Security Configuration Details

### Dependabot Configuration

This project uses an enhanced Dependabot configuration (`.github/dependabot.yml`) that:

- Scans multiple ecosystems (npm, GitHub Actions, Docker)
- Creates automated PRs for vulnerable dependencies
- Labels security-related PRs for easy identification
- Customizes update schedule based on ecosystem needs

### Branch Protection Rules

- Required status checks must pass before merging
- Pull request reviews required before merging
- Dismisses stale pull request approvals when new commits are pushed
- Restricts who can push to matching branches

### SBOM Generation

Software Bill of Materials (SBOM) is automatically generated during the build process, providing transparency into all dependencies.

## 📊 Security Dashboard

Visit the [Security tab](https://github.com/timothywarner/glob-web-pilot/security) in this repository to view:

- Current security alerts
- Dependabot alerts and updates
- CodeQL analysis results
- Secret scanning alerts

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
