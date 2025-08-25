# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a demonstration repository for GitHub Advanced Security (GHAS) and GitHub Copilot training. It's a Node.js/Express web application designed to showcase security features, vulnerabilities, and best practices for teaching purposes.

## Development Commands

### Core Commands
```bash
# Install dependencies
npm install

# Run tests (uses Mocha with Chai)
npm test

# Start the application (runs on port configured in config.js)
npm start

# Build (essentially npm install)
npm run build
```

### Testing Details
- Test framework: Mocha with Chai
- Test files location: `/test/` directory
- Test files: `contact_test.js`, `index_test.js`, `who_test.js`
- Run single test: `npx mocha test/[filename]`

## Architecture Overview

### Application Structure
This is a simple Express.js application with Handlebars templating:

- **Entry Point**: `app.js` - Sets up Express server with Handlebars view engine
- **Configuration**: `config.js` - Contains application configuration (port, etc.)
- **Routes**: `/routes/` directory
  - `index.js` - Home page route
  - `who.js` - About/who page route  
  - `contact.js` - Contact page route
- **Views**: `/views/` directory with Handlebars templates
  - Main layout: `layouts/main.handlebars`
  - Page templates: `index.handlebars`, `who.handlebars`, `contact.handlebars`
- **Static Assets**: `/public/` directory
  - Sass source files in `/public/assets/sass/`
  - Compiled CSS in `/public/assets/css/`
  - JavaScript in `/public/assets/js/`

### Security Demonstration Features

This repository is specifically designed for GHAS demonstrations:

1. **Intentional Vulnerabilities**: The codebase may contain intentional security issues for demonstration purposes (e.g., `sqltest.js` for SQL injection demos)

2. **GHAS Features to Demonstrate**:
   - Dependabot alerts and automated PRs
   - CodeQL scanning (directory exists at `.github/codeql/` for custom queries)
   - Secret scanning
   - Security policies (`SECURITY.md`)
   - Branch protection rules
   - SARIF integration

3. **CI/CD Pipelines**:
   - Azure DevOps pipelines (`azure-pipelines.yml`, `azure-pipelines-2.yml`)
   - GitHub Actions workflows (`.github/workflows/` - currently empty, ready for demonstrations)

## GHAS Configuration Tasks

When setting up GHAS demonstrations:

1. **Create Dependabot configuration** at `.github/dependabot.yml`
2. **Add CodeQL workflow** to `.github/workflows/`
3. **Configure secret scanning** through repository settings
4. **Set up branch protection rules** via GitHub UI
5. **Create custom CodeQL queries** in `.github/codeql/` if needed

## Security Resources

- `SECURITY.md` - Security policy with vulnerability reporting guidelines
- `GHAS-RESOURCES.md` - Comprehensive list of GHAS documentation and training materials

## Important Notes for Development

1. This is a **training repository** - vulnerabilities may be intentional for demonstration
2. The repository uses older dependency versions to demonstrate Dependabot updates
3. No linting configuration exists - consider adding ESLint for code quality demos
4. The `sqltest.js` file appears to be for SQL injection demonstration purposes
5. Azure DevOps pipeline configurations exist alongside GitHub Actions for multi-platform CI/CD demos

## Common Demonstration Scenarios

1. **Dependabot Demo**: Show how outdated dependencies trigger alerts and automated PRs
2. **CodeQL Demo**: Run code scanning to identify security vulnerabilities
3. **Secret Scanning Demo**: Attempt to commit test credentials to trigger alerts
4. **GitHub Copilot Demo**: Use for debugging and code suggestions
5. **SARIF Upload Demo**: Integrate third-party security tools via SARIF format

## Dependencies

Key dependencies (intentionally using older versions for demo purposes):
- Express: 4.16.0 (outdated for Dependabot demos)
- Express-handlebars: 7.1.3
- Tedious: 18.2.4 (SQL Server driver)
- Mocha: 10.7.0 (test framework)
- Chai: 4.2.0 (assertion library)