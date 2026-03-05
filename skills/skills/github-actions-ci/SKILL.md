---
name: github-actions-ci
version: 1.0.0
description: Monitor and interact with GitHub Actions workflows and CI runs
requires:
  binaries: [gh]
  env: [GITHUB_TOKEN]
tools: [exec, read]
author: startup-team
---

# GitHub Actions CI Integration

Monitor CI/CD pipelines and get workflow run details.

## Core Commands

### List recent workflow runs
gh run list --repo OWNER/REPO --limit 20 --json databaseId,conclusion,status,workflowName,headBranch

### View specific run details
gh run view RUN_ID --repo OWNER/REPO --json conclusion,jobs,steps

### Get run logs
gh run view RUN_ID --repo OWNER/REPO --log

### Watch a running workflow
gh run watch RUN_ID --repo OWNER/REPO

### Trigger a workflow
gh workflow run WORKFLOW_NAME --repo OWNER/REPO --ref main

## Integration Patterns

### QA Agent Usage
When reviewing a PR:
1. Get PR number from context
2. Check CI status: `gh pr checks PR_NUMBER`
3. If failures, fetch logs: `gh run view RUN_ID --log`
4. Analyze failure patterns and post summary to PR

### Cost Controller Usage
Monitor Actions usage:
gh api /repos/OWNER/REPO/actions/billing/usage --jq '.total_minutes_used'

Include in monthly cost reports.

### Dev Agent Usage
Before creating PR:
- Ensure local tests pass
- Reference CI requirements in PR description
- Monitor CI run after PR creation

---

