---
name: github-pr-ops
version: 1.0.0
description: Create, review, and manage GitHub pull requests via gh CLI
requires:
  binaries: [gh, git]
  env: [GITHUB_TOKEN]
tools: [exec, read, write]
author: faccomichele
---

# GitHub Pull Request Operations

Handle pull requests for code review and merging workflows.

## Core Commands

### Create PR
gh pr create --repo OWNER/REPO \
  --title "feat: add feature X [dev-backend]" \
  --body "Implements #123\n\n## Changes\n- Item 1\n- Item 2" \
  --base main \
  --head feature-branch \
  --label "needs-ai-review"

### View PR details
gh pr view PR_NUMBER --repo OWNER/REPO --json title,body,state,labels,commits,reviews

### Get PR diff
gh pr diff PR_NUMBER --repo OWNER/REPO

### Add PR review comment
gh pr comment PR_NUMBER --repo OWNER/REPO --body "🔍 [QA Agent]\n\nReview findings:\n- All tests pass\n- Code coverage: 87%\n- Approved"

### Check PR CI status
gh pr checks PR_NUMBER --repo OWNER/REPO

### List recent PRs
gh pr list --repo OWNER/REPO --state open --json number,title,author,labels

## Best Practices

### For Dev Agents
- Always reference issue number in PR title/body (e.g., "Implements #42")
- Include agent identifier in commit messages: `feat: add auth timeout [dev-backend]`
- Add label `needs-ai-review` when ready for QA
- Include test results in PR description

### For QA/Reviewer Agents
- Fetch diff and analyze changed files
- Run tests if available via CI status check
- Post structured review with sections: Summary, Issues Found, Recommendation
- Update issue status after review

### For all agents
- **Never merge PRs** - only humans merge to main
- Use consistent comment signatures
- Link PRs to issues bidirectionally

---

