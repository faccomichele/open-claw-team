# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — setup details unique to your environment.

## GitHub

- Default org/owner: (set per project — read from the GitHub issue URL you're working on, e.g. `https://github.com/OWNER/REPO/issues/42` → `OWNER/REPO`. Store in `memory/YYYY-MM-DD.md` for the session.)
- Labels in use: `status:todo`, `status:in_progress`, `status:done`, `type:feature`, `type:bug`, `type:research`, `owner:pm`, `owner:copilot-dev-backend`, `owner:copilot-dev-frontend`, `owner:copilot-dev-infra`, `owner:copilot-test-specialist`
- Sprint milestone naming: `Sprint N - YYYY-MM-DD`

## Agent IDs (OpenClaw sessions)

- `biz-research` — Business Research agent
- `cost-controller` — Cost Controller agent
- `tech-lead` — Tech Lead agent

## Copilot Agents (GitHub issue assignment)

Use `gh copilot suggest -p bash` to assign custom agents (AI-powered CLI, non-interactive):

```bash
# Replace ISSUE_NUMBER and OWNER/REPO with actual values; replace dev-backend with the target agent
gh copilot suggest -p bash "assign issue ISSUE_NUMBER in OWNER/REPO to the dev-backend custom GitHub Copilot agent" | bash
```

Available agents (defined in `.github/copilot/agents/` of each target repo):

- `dev-backend` — Node.js/TypeScript backend
- `dev-frontend` — React/UI frontend
- `dev-infra` — CI/CD, IaC, infrastructure
- `test-specialist` — Testing and QA

## Notes

Add any project-specific shortcuts, repo aliases, or environment notes here as they come up.
