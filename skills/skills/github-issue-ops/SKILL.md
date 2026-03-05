---
name: github-issue-ops
version: 1.0.0
description: Manage GitHub issues - create, update, label, assign, and close issues via gh CLI
requires:
  binaries: [gh]
  env: [GITHUB_TOKEN]
tools: [exec, read]
author: startup-team
---

# GitHub Issue Operations

You can manage GitHub issues using the `gh` CLI tool.

## Core Commands

### List issues
gh issue list --repo OWNER/REPO --state open --json number,title,labels,assignees

### View issue details
gh issue view ISSUE_NUMBER --repo OWNER/REPO --json title,body,labels,state,assignees,comments

### Create issue
gh issue create --repo OWNER/REPO --title "TITLE" --body "BODY" --label "label1,label2"

### Update issue labels
gh issue edit ISSUE_NUMBER --repo OWNER/REPO --add-label "owner:pm,type:feature"

### Add comment to issue
gh issue comment ISSUE_NUMBER --repo OWNER/REPO --body "🧭 [PM Agent]\n\nComment text here"

### Close issue
gh issue close ISSUE_NUMBER --repo OWNER/REPO --comment "Completed"

## Best Practices

- **Always prefix comments** with your agent identifier (e.g., `🧭 [PM Agent]`, `👨‍💻 [Dev Backend Agent]`)
- **Use labels consistently**: `owner:<agent>`, `type:<feature|bug|research|cost>`, `status:<todo|in_progress|in_review|blocked>`
- **Include context**: link to related issues, PRs, or files when commenting
- **Never close issues** unless explicitly instructed by the CEO or PM agent

---

