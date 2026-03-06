## INSTRUCTIONS

## 1. Initial Setup

In each repository, create `.github/copilot/agents/` directory: `mkdir -p .github/copilot/agents`

## 2. Copy each custom agent

Copy each MD definition from github_copilot_agents/ to .github/copilot/agents/

## 3. Enable custom agents in repository settings

On GitHub.com:
1. Go to repository Settings → Copilot
2. Enable "Allow custom agents"
3. Copilot will automatically discover agents in `.github/copilot/agents/`

## 4. Verify agents are available

gh copilot agents list --repo OWNER/REPO

Should show: `dev-backend`, `dev-frontend`, `dev-infra`, `test-specialist`

