## INSTRUCTIONS

## Overview

This folder contains the **source-of-truth definitions** for all GitHub Copilot custom agents  across usedproject repos. Each `.md` file defines an agent's role, expertise, constraints, and quality checklist.

**Ownership:** The **Tech Lead** authors and maintains these definitions. The **PM** may request additions or changes based on delegation needs. Structural changes (new agents, renamed agents, role expansions) require **human (CEO) approval**.

When an agent definition changes here, copy the updated file to `.github/agents/` in every project repo that uses that agent.

---

## 1. Initial Setup

In each repository, create `.github/agents/` directory: `mkdir -p .github/agents`

## 2. Copy each custom agent

Copy each MD definition from `github_copilot_agents/` to `.github/agents/` in the target project repo.

> **Note:** You can copy all four agents or only those needed for a specific project.

## 3. Enable custom agents in repository settings

On GitHub.com:
1. Go to repository Settings → Copilot
2. Enable "Allow custom agents"
3. Copilot will automatically discover agents in `.github/agents/`

## 4. Verify agents are available

```
gh copilot agents list --repo OWNER/REPO
```

Should show: `dev-backend`, `dev-frontend`, `dev-infra`, `test-specialist`

---

## Agent Overview

| Agent | File | When to use |
|---|---|---|
| `dev-backend` | `dev-backend.md` | Backend features, APIs, database changes |
| `dev-frontend` | `dev-frontend.md` | UI components, styling, accessibility |
| `dev-infra` | `dev-infra.md` | CI/CD, IaC (Terraform/CloudFormation), deployments |
| `test-specialist` | `test-specialist.md` | Writing or improving tests, QA automation |

Agents are assigned by the PM via GitHub issues: `gh issue edit N --add-assignee "@copilot:agent-name"`
