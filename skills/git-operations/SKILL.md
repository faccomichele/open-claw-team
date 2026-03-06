---
name: git-operations
version: 1.0.0
description: Git commands for committing, branching, and pushing code changes
requires:
  binaries: [git]
tools: [exec, read]
author: faccomichele
---

# Git Operations

Standard git workflows for agent-driven development.

## Setup

Configure git identity for agent commits:

git config user.name "Dev Backend Agent (bot)"
git config user.email "yourname-bot@users.noreply.github.com"

## Core Workflows

### Create feature branch

git checkout -b feat/dev-backend/issue-42-github-sync

**Branch naming convention:**
- `feat/<agent>/<short-description>`
- `fix/<agent>/<short-description>`
- `chore/<agent>/<short-description>`

### Stage and commit

git add src/github-sync.js tests/github-sync.test.js
git commit -m "feat: implement GitHub issue sync [dev-backend]

Implements #42

- Add GitHub API client
- Create sync module with rate limiting
- Add comprehensive tests
- Handle pagination and errors"

**Commit message format:**
- First line: `type: description [agent-name]`
- Blank line
- Body: `Implements #ISSUE_NUMBER` + details
- Types: `feat`, `fix`, `chore`, `docs`, `test`, `refactor`

### Push branch

git push origin feat/dev-backend/issue-42-github-sync

### Create PR (after push)

gh pr create --title "feat: implement GitHub issue sync [dev-backend]" \
  --body "Implements #42" \
  --label "needs-ai-review"

## Best Practices

- **Always work on feature branches** - never commit directly to main
- **Reference issue numbers** - use `Implements #N` or `Fixes #N`
- **Atomic commits** - one logical change per commit
- **Sign commits with agent name** - include `[agent-name]` in first line
- **Push frequently** - don't let branches diverge too much
- **Never force-push** - unless explicitly instructed by human

---

