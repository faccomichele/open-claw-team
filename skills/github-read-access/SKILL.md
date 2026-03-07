---
name: github-read-access
version: 1.0.0
description: Read-only GitHub access via gh CLI — browse repos, issues, PRs, releases, and clone repositories for inspection
requires:
  binaries: [gh, git]
  env: [GITHUB_TOKEN]
tools: [exec, read]
author: faccomichele
---

# GitHub Read Access

Read-only operations against any GitHub repository using the `gh` CLI.  
Use this skill to inspect current configurations, review project state, and clone repos locally without making any changes.

## Core Commands

### Clone a repository (read/inspect only)

```
gh repo clone OWNER/REPO [/local/destination/path]
```

> Always clone to a temporary directory for inspection only. Never commit or push from a cloned copy — use the `git-operations` or `github-pr-ops` skills for write operations.

### View repository details

```
gh repo view OWNER/REPO --json name,description,defaultBranchRef,isPrivate,url,homepageUrl
```

### List repositories for an owner

```
gh repo list OWNER --limit 50 --json name,description,isPrivate,url
```

### View repository file contents (without cloning)

```
gh api repos/OWNER/REPO/contents/PATH --jq '.content' | base64 --decode
```

### List and view issues (read-only)

```
gh issue list --repo OWNER/REPO --state open --json number,title,labels,assignees,state
gh issue view ISSUE_NUMBER --repo OWNER/REPO --json title,body,labels,state,assignees,comments
```

### List and view pull requests (read-only)

```
gh pr list --repo OWNER/REPO --state open --json number,title,author,labels,headRefName
gh pr view PR_NUMBER --repo OWNER/REPO --json title,body,state,labels,commits,reviews
gh pr diff PR_NUMBER --repo OWNER/REPO
```

### List and view releases

```
gh release list --repo OWNER/REPO
gh release view TAG --repo OWNER/REPO --json name,body,publishedAt,assets
```

### List and view workflow runs (CI status)

```
gh run list --repo OWNER/REPO --limit 20 --json databaseId,status,conclusion,workflowName,createdAt
gh run view RUN_ID --repo OWNER/REPO --json status,conclusion,jobs
```

### View repository secrets and variables (names only, values are masked)

```
gh secret list --repo OWNER/REPO
gh variable list --repo OWNER/REPO
```

### Search code in a repository

```
gh search code QUERY --repo OWNER/REPO --json path,textMatches
```

## Best Practices

- **Never write, push, or merge** — this skill grants read access only; always clone to a dedicated temporary workspace directory (e.g. the agent's designated scratch folder) rather than a production working directory
- **Always use `--json`** when parsing output programmatically to avoid brittle text parsing
- **Respect rate limits** — batch related reads into a single `gh api` call with GraphQL where possible
- **Announce intent** — prefix any comment or message that results from a read operation with your agent identifier (e.g., `🧭 [CEO Agent]`)

---
