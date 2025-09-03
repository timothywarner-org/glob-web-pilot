#!/bin/bash

################################################################################
# GitHub Advanced Security (GHAS) & GitHub Copilot CLI Showcase Script
# Repository: timothywarner-org/glob-web-pilot
# Purpose: Demonstrate GHAS and Copilot features via GitHub CLI (gh)
# Author: Timothy Warner & Claude
# Date: 2025
################################################################################

# Colors for output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Repository context
OWNER="timothywarner-org"
REPO="glob-web-pilot"

echo -e "${CYAN}================================================================================================${NC}"
echo -e "${GREEN}GitHub Advanced Security (GHAS) & GitHub Copilot CLI Examples${NC}"
echo -e "${CYAN}================================================================================================${NC}"

################################################################################
# SECTION 1: CODE SCANNING (CODEQL)
################################################################################

echo -e "\n${YELLOW}=== SECTION 1: CODE SCANNING WITH CODEQL ===${NC}\n"

# List all code scanning alerts for the repository
echo -e "${BLUE}# List all code scanning alerts (open and closed)${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/alerts --paginate"
# This shows all security vulnerabilities detected by CodeQL analysis

# Get details of a specific code scanning alert
echo -e "\n${BLUE}# Get details of a specific code scanning alert (example: alert #1)${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/alerts/1"
# Shows detailed information about a specific vulnerability

# List only open/active code scanning alerts
echo -e "\n${BLUE}# List only open code scanning alerts${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/alerts --jq '.[] | select(.state==\"open\")'"
# Filters to show only unresolved security issues

# List code scanning alerts by severity
echo -e "\n${BLUE}# List high and critical severity code scanning alerts${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/alerts --jq '.[] | select(.rule.severity==\"high\" or .rule.severity==\"critical\")'"
# Helps prioritize which vulnerabilities to fix first

# Get code scanning alerts introduced in a PR
echo -e "\n${BLUE}# Check for new code scanning alerts in PR #34${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/alerts --jq '.[] | select(.pull_request.number==34)'"
# Useful for PR review process

# List code scanning analyses (scan history)
echo -e "\n${BLUE}# View code scanning analysis history${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/analyses --paginate"
# Shows when scans ran and their status

# Get the latest code scanning analysis
echo -e "\n${BLUE}# Get details of the most recent code scan${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/analyses --jq '.[0]'"
# Check the status of the latest security scan

# List CodeQL databases available
echo -e "\n${BLUE}# List available CodeQL databases for the repo${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/codeql/databases"
# Shows which languages are being analyzed

# Get SARIF upload details (Static Analysis Results Interchange Format)
echo -e "\n${BLUE}# Get SARIF upload information${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/sarifs --paginate"
# SARIF is the standard format for static analysis results

# Dismiss a code scanning alert (requires write access)
echo -e "\n${BLUE}# Dismiss a false positive alert with reason${NC}"
echo "gh api --method PATCH repos/${OWNER}/${REPO}/code-scanning/alerts/1 -f state=dismissed -f dismissed_reason=false_positive -f dismissed_comment='Validated as safe - user input is sanitized'"
# Document why an alert was dismissed

################################################################################
# SECTION 2: SECRET SCANNING
################################################################################

echo -e "\n${YELLOW}=== SECTION 2: SECRET SCANNING ===${NC}\n"

# List all secret scanning alerts
echo -e "${BLUE}# List all secret scanning alerts in the repository${NC}"
echo "gh api repos/${OWNER}/${REPO}/secret-scanning/alerts --paginate"
# Shows all detected secrets (API keys, tokens, passwords)

# Get details of a specific secret scanning alert
echo -e "\n${BLUE}# Get details of a specific secret alert${NC}"
echo "gh api repos/${OWNER}/${REPO}/secret-scanning/alerts/1"
# Detailed info about a detected secret

# List only open secret scanning alerts
echo -e "\n${BLUE}# List only unresolved secret scanning alerts${NC}"
echo "gh api repos/${OWNER}/${REPO}/secret-scanning/alerts --jq '.[] | select(.state==\"open\")'"
# Shows secrets that still need attention

# List secret scanning alerts by secret type
echo -e "\n${BLUE}# Find all AWS access keys detected${NC}"
echo "gh api repos/${OWNER}/${REPO}/secret-scanning/alerts --jq '.[] | select(.secret_type==\"aws_access_key_id\")'"
# Filter by specific secret types

# Update secret scanning alert state
echo -e "\n${BLUE}# Mark a secret as revoked after rotating it${NC}"
echo "gh api --method PATCH repos/${OWNER}/${REPO}/secret-scanning/alerts/1 -f state=resolved -f resolution=revoked"
# Document that a leaked secret has been revoked

# List secret scanning alerts for the organization
echo -e "\n${BLUE}# List all secrets across the entire organization${NC}"
echo "gh api orgs/${OWNER}/secret-scanning/alerts --paginate"
# Organization-wide secret scanning view

# Get secret scanning push protection bypasses
echo -e "\n${BLUE}# View push protection bypass events${NC}"
echo "gh api repos/${OWNER}/${REPO}/secret-scanning/push-protection-bypasses"
# See when developers bypassed secret scanning blocks

################################################################################
# SECTION 3: DEPENDENCY SCANNING (DEPENDABOT)
################################################################################

echo -e "\n${YELLOW}=== SECTION 3: DEPENDENCY SCANNING WITH DEPENDABOT ===${NC}\n"

# List Dependabot alerts (security vulnerabilities)
echo -e "${BLUE}# List all Dependabot security alerts${NC}"
echo "gh api repos/${OWNER}/${REPO}/dependabot/alerts --paginate"
# Shows vulnerable dependencies

# Get specific Dependabot alert details
echo -e "\n${BLUE}# Get details of a specific dependency vulnerability${NC}"
echo "gh api repos/${OWNER}/${REPO}/dependabot/alerts/1"
# Detailed vulnerability information

# List only critical severity Dependabot alerts
echo -e "\n${BLUE}# List critical vulnerability alerts${NC}"
echo "gh api repos/${OWNER}/${REPO}/dependabot/alerts --jq '.[] | select(.security_vulnerability.severity==\"critical\")'"
# Focus on most severe vulnerabilities

# List Dependabot alerts affecting package.json
echo -e "\n${BLUE}# Find vulnerabilities in npm dependencies${NC}"
echo "gh api repos/${OWNER}/${REPO}/dependabot/alerts --jq '.[] | select(.dependency.manifest_path==\"/package.json\")'"
# Filter by manifest file

# Create a Dependabot security update PR
echo -e "\n${BLUE}# Trigger Dependabot to create security update PRs${NC}"
echo "gh api --method POST repos/${OWNER}/${REPO}/dependabot/alerts/1/create-pr"
# Automatically create PR to fix vulnerability

# List Dependabot secrets
echo -e "\n${BLUE}# List configured Dependabot secrets${NC}"
echo "gh api repos/${OWNER}/${REPO}/dependabot/secrets"
# View secrets available to Dependabot

# Get repository vulnerability alerts summary
echo -e "\n${BLUE}# Get vulnerability alerts summary${NC}"
echo "gh api repos/${OWNER}/${REPO}/vulnerability-alerts"
# Overall security status

################################################################################
# SECTION 4: SECURITY POLICIES & ADVISORIES
################################################################################

echo -e "\n${YELLOW}=== SECTION 4: SECURITY POLICIES & ADVISORIES ===${NC}\n"

# Get security policy
echo -e "${BLUE}# View repository security policy${NC}"
echo "gh api repos/${OWNER}/${REPO}/security-policy"
# Shows SECURITY.md content

# List security advisories for the repository
echo -e "\n${BLUE}# List published security advisories${NC}"
echo "gh api repos/${OWNER}/${REPO}/security-advisories"
# Shows CVEs and security bulletins

# Create a draft security advisory (maintainer only)
echo -e "\n${BLUE}# Create a draft security advisory for a vulnerability${NC}"
echo "gh api --method POST repos/${OWNER}/${REPO}/security-advisories -f summary='XSS vulnerability in input validation' -f description='Details about the vulnerability' -f severity='high'"
# Start the responsible disclosure process

# Get GitHub Security Lab advisories
echo -e "\n${BLUE}# Search GitHub advisory database for npm vulnerabilities${NC}"
echo "gh api graphql -f query='
{
  securityAdvisories(first: 10, ecosystem: NPM) {
    nodes {
      summary
      severity
      publishedAt
      vulnerabilities(first: 5) {
        nodes {
          package {
            name
          }
          vulnerableVersionRange
        }
      }
    }
  }
}'"
# Query the global security advisory database

################################################################################
# SECTION 5: GITHUB COPILOT CLI FEATURES
################################################################################

echo -e "\n${YELLOW}=== SECTION 5: GITHUB COPILOT CLI FEATURES ===${NC}\n"

# Explain a command
echo -e "${BLUE}# Use Copilot to explain a complex git command${NC}"
echo "gh copilot explain 'git rebase -i HEAD~3'"
# Copilot explains what the command does

# Suggest a command
echo -e "\n${BLUE}# Ask Copilot how to find large files in the repo${NC}"
echo "gh copilot suggest 'find all files larger than 10MB'"
# Copilot suggests the appropriate command

# Fix an error
echo -e "\n${BLUE}# Get help fixing a Node.js error${NC}"
echo "gh copilot suggest 'fix npm ERR! missing script: start'"
# Copilot helps debug errors

# Generate a git command
echo -e "\n${BLUE}# Ask Copilot for a git command to undo the last commit${NC}"
echo "gh copilot suggest 'undo last git commit keeping changes'"
# Generates: git reset --soft HEAD~1

# Get help with gh CLI commands
echo -e "\n${BLUE}# Ask Copilot how to create a PR with specific reviewers${NC}"
echo "gh copilot suggest 'create PR with reviewers using gh cli'"
# Copilot provides the correct gh pr create syntax

# Shell command suggestions
echo -e "\n${BLUE}# Ask for a command to find JavaScript files with console.log${NC}"
echo "gh copilot suggest 'find all .js files containing console.log'"
# Generates: grep -r "console.log" --include="*.js"

# Docker command help
echo -e "\n${BLUE}# Get Docker command to run Node.js app${NC}"
echo "gh copilot suggest 'docker command to run node app on port 3000'"
# Helps with containerization

# Security-focused suggestions
echo -e "\n${BLUE}# Ask Copilot for secure npm audit commands${NC}"
echo "gh copilot suggest 'audit npm packages and fix vulnerabilities'"
# Generates: npm audit && npm audit fix

################################################################################
# SECTION 6: REPOSITORY-SPECIFIC PRACTICAL EXAMPLES
################################################################################

echo -e "\n${YELLOW}=== SECTION 6: PRACTICAL EXAMPLES FOR THIS REPO ===${NC}\n"

# Check for SQL injection vulnerabilities in this Node.js app
echo -e "${BLUE}# Scan for SQL injection in our Express app${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/alerts --jq '.[] | select(.rule.id | contains(\"sql\"))'"
# Specific to our tedious SQL usage

# Check for XSS vulnerabilities in Handlebars templates
echo -e "\n${BLUE}# Look for XSS issues in our Handlebars templates${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/alerts --jq '.[] | select(.rule.tags[] | contains(\"xss\"))'"
# Relevant for express-handlebars

# Find outdated dependencies in package.json
echo -e "\n${BLUE}# List all npm dependencies with available updates${NC}"
echo "gh api repos/${OWNER}/${REPO}/dependabot/alerts --jq '.[] | {package: .dependency.package.name, current: .dependency.manifest_path, severity: .security_vulnerability.severity}'"
# Shows our actual vulnerable packages

# Check Express framework vulnerabilities
echo -e "\n${BLUE}# Check for Express.js specific vulnerabilities${NC}"
echo "gh api repos/${OWNER}/${REPO}/dependabot/alerts --jq '.[] | select(.dependency.package.name==\"express\")'"
# Our main framework

# Review test file security issues
echo -e "\n${BLUE}# Check for security issues in test files${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/alerts --jq '.[] | select(.location.path | contains(\"/test/\"))'"
# Mocha/Chai test vulnerabilities

# Analyze Azure deployment security
echo -e "\n${BLUE}# Check for Azure-related security issues${NC}"
echo "gh api repos/${OWNER}/${REPO}/code-scanning/alerts --jq '.[] | select(.rule.tags[] | contains(\"azure\") or .rule.tags[] | contains(\"cloud\"))'"
# Azure App Service concerns

################################################################################
# SECTION 7: AUTOMATION & WORKFLOWS
################################################################################

echo -e "\n${YELLOW}=== SECTION 7: SECURITY AUTOMATION WITH WORKFLOWS ===${NC}\n"

# List CodeQL workflow runs
echo -e "${BLUE}# View recent CodeQL analysis workflow runs${NC}"
echo "gh run list --workflow=codeql-analysis.yml --limit 5"
# Monitor security scanning automation

# Get workflow run details
echo -e "\n${BLUE}# Get details of the latest security scan run${NC}"
echo "gh run view --workflow=codeql-analysis.yml"
# Check if scans are passing

# Download SARIF results from workflow
echo -e "\n${BLUE}# Download SARIF security scan results${NC}"
echo "gh run download --name=sarif-results"
# Get detailed scan results

# Trigger a manual security scan
echo -e "\n${BLUE}# Manually trigger CodeQL analysis${NC}"
echo "gh workflow run codeql-analysis.yml"
# Run security scan on-demand

# View Dependabot PR status
echo -e "\n${BLUE}# List open Dependabot PRs${NC}"
echo "gh pr list --author='app/dependabot' --state=open"
# Track security updates

################################################################################
# SECTION 8: SECURITY INSIGHTS & METRICS
################################################################################

echo -e "\n${YELLOW}=== SECTION 8: SECURITY INSIGHTS & METRICS ===${NC}\n"

# Get security overview using GraphQL
echo -e "${BLUE}# Get comprehensive security metrics${NC}"
echo "gh api graphql -f query='
{
  repository(owner: \"${OWNER}\", name: \"${REPO}\") {
    vulnerabilityAlerts {
      totalCount
    }
    securityPolicyUrl
    codeOfConduct {
      name
    }
  }
}'"
# Overall security posture

# Count alerts by severity
echo -e "\n${BLUE}# Count security alerts by severity level${NC}"
echo "echo 'Critical:' && gh api repos/${OWNER}/${REPO}/dependabot/alerts --jq '[.[] | select(.security_vulnerability.severity==\"critical\")] | length'"
echo "echo 'High:' && gh api repos/${OWNER}/${REPO}/dependabot/alerts --jq '[.[] | select(.security_vulnerability.severity==\"high\")] | length'"
echo "echo 'Medium:' && gh api repos/${OWNER}/${REPO}/dependabot/alerts --jq '[.[] | select(.security_vulnerability.severity==\"medium\")] | length'"
echo "echo 'Low:' && gh api repos/${OWNER}/${REPO}/dependabot/alerts --jq '[.[] | select(.security_vulnerability.severity==\"low\")] | length'"
# Severity distribution

# Mean time to remediation calculation
echo -e "\n${BLUE}# Calculate average time to fix vulnerabilities${NC}"
echo "gh api repos/${OWNER}/${REPO}/dependabot/alerts --jq '.[] | select(.state==\"fixed\") | {package: .dependency.package.name, days_to_fix: ((.fixed_at | fromdateiso8601) - (.created_at | fromdateiso8601)) / 86400}'"
# Security response metrics

################################################################################
# SECTION 9: INTEGRATION WITH CI/CD
################################################################################

echo -e "\n${YELLOW}=== SECTION 9: CI/CD SECURITY INTEGRATION ===${NC}\n"

# Check if PR has security issues before merge
echo -e "${BLUE}# Pre-merge security check for PR #34${NC}"
echo "gh pr checks 34 --watch"
# Wait for security checks to pass

# Get security check status for a commit
echo -e "\n${BLUE}# Check security scan status for latest commit${NC}"
echo "gh api repos/${OWNER}/${REPO}/commits/HEAD/check-runs --jq '.check_runs[] | select(.name | contains(\"CodeQL\")) | {name: .name, status: .status, conclusion: .conclusion}'"
# Verify security scans passed

# Create branch protection rule requiring security checks
echo -e "\n${BLUE}# Configure branch protection with security requirements${NC}"
echo "gh api --method PUT repos/${OWNER}/${REPO}/branches/main/protection --field required_status_checks[contexts][]='CodeQL' --field required_status_checks[strict]=true --field enforce_admins=true"
# Enforce security scanning

################################################################################
# SECTION 10: ADVANCED COPILOT USAGE
################################################################################

echo -e "\n${YELLOW}=== SECTION 10: ADVANCED COPILOT CLI USAGE ===${NC}\n"

# Complex multi-step operations
echo -e "${BLUE}# Ask Copilot for complex git operations${NC}"
echo "gh copilot suggest 'cherry-pick commits from feature branch excluding merge commits'"
# Advanced git workflows

# Security-focused code review
echo -e "\n${BLUE}# Get Copilot's help with security review${NC}"
echo "gh copilot suggest 'find potential security issues in JavaScript files'"
# Security-aware suggestions

# Performance optimization suggestions
echo -e "\n${BLUE}# Ask for performance improvement commands${NC}"
echo "gh copilot suggest 'analyze Node.js app performance and find bottlenecks'"
# Performance analysis

# Database query help
echo -e "\n${BLUE}# Get help with SQL queries for tedious${NC}"
echo "gh copilot suggest 'create parameterized SQL query to prevent injection'"
# Secure coding practices

# Docker security scanning
echo -e "\n${BLUE}# Ask for Docker security scanning commands${NC}"
echo "gh copilot suggest 'scan docker image for vulnerabilities'"
# Container security

# Environment-specific commands
echo -e "\n${BLUE}# Get Azure-specific deployment commands${NC}"
echo "gh copilot suggest 'deploy Node.js app to Azure App Service with GitHub Actions'"
# Cloud deployment

################################################################################
# SECTION 11: REPORTING AND DOCUMENTATION
################################################################################

echo -e "\n${YELLOW}=== SECTION 11: SECURITY REPORTING ===${NC}\n"

# Generate security report in JSON
echo -e "${BLUE}# Export security alerts to JSON file${NC}"
echo "gh api repos/${OWNER}/${REPO}/dependabot/alerts --paginate > security-report.json"
# Create audit report

# Generate CSV report of vulnerabilities
echo -e "\n${BLUE}# Create CSV report of all vulnerabilities${NC}"
echo "gh api repos/${OWNER}/${REPO}/dependabot/alerts --jq '.[] | [.number, .state, .security_vulnerability.severity, .dependency.package.name, .created_at] | @csv' > vulnerabilities.csv"
# Spreadsheet-compatible format

# Create markdown summary
echo -e "\n${BLUE}# Generate markdown security summary${NC}"
echo "echo '# Security Report' > SECURITY-REPORT.md"
echo "echo '## Summary' >> SECURITY-REPORT.md"
echo "gh api repos/${OWNER}/${REPO}/dependabot/alerts --jq '[.[] | select(.state==\"open\")] | \"Open Alerts: \\(length)\"' >> SECURITY-REPORT.md"
# Documentation generation

################################################################################
# SECTION 12: USEFUL ALIASES AND FUNCTIONS
################################################################################

echo -e "\n${YELLOW}=== SECTION 12: USEFUL GH CLI ALIASES ===${NC}\n"

# Create useful aliases
echo -e "${BLUE}# Set up helpful gh CLI aliases for GHAS${NC}"
echo "gh alias set security-alerts 'api repos/${OWNER}/${REPO}/code-scanning/alerts --jq \".[].rule.description\"'"
echo "gh alias set vulnerable-deps 'api repos/${OWNER}/${REPO}/dependabot/alerts --jq \".[] | select(.state==\\\"open\\\")\"'"
echo "gh alias set secret-scan 'api repos/${OWNER}/${REPO}/secret-scanning/alerts'"
echo "gh alias set sec-summary 'api repos/${OWNER}/${REPO}/vulnerability-alerts'"
# Quick access commands

# Create a security check function
echo -e "\n${BLUE}# Bash function for comprehensive security check${NC}"
echo 'security_check() {
  echo "=== Code Scanning Alerts ==="
  gh api repos/${OWNER}/${REPO}/code-scanning/alerts --jq ".[].rule.description" | head -5
  echo "=== Dependency Vulnerabilities ==="
  gh api repos/${OWNER}/${REPO}/dependabot/alerts --jq ".[] | select(.state==\"open\") | .dependency.package.name" | head -5
  echo "=== Secret Scanning ==="
  gh api repos/${OWNER}/${REPO}/secret-scanning/alerts --jq ".[].secret_type" | head -5
}'
# All-in-one security status

################################################################################
# FOOTER
################################################################################

echo -e "\n${CYAN}================================================================================================${NC}"
echo -e "${GREEN}End of GHAS & Copilot CLI Showcase${NC}"
echo -e "${YELLOW}Note: These commands require:${NC}"
echo -e "  - GitHub CLI (gh) authenticated with appropriate permissions"
echo -e "  - GHAS features enabled on the repository"
echo -e "  - GitHub Copilot CLI extension installed: ${CYAN}gh extension install github/gh-copilot${NC}"
echo -e "${CYAN}================================================================================================${NC}"

# Tips for students
echo -e "\n${MAGENTA}=== TIPS FOR STUDENTS ===${NC}"
echo -e "1. Always use ${CYAN}--help${NC} flag to explore command options"
echo -e "2. Use ${CYAN}--json${NC} flag for machine-readable output"
echo -e "3. Combine with ${CYAN}jq${NC} for powerful JSON filtering"
echo -e "4. Set up aliases for frequently used commands"
echo -e "5. Use ${CYAN}gh auth status${NC} to verify authentication"
echo -e "6. Enable GHAS features in Settings > Security & analysis"
echo -e "7. Practice in a test repository before production use"
echo -e "8. Check API rate limits with: ${CYAN}gh api rate_limit${NC}"
echo -e "9. Use ${CYAN}--web${NC} flag to open results in browser"
echo -e "10. Remember: Security scanning requires GHAS license or public repo"
