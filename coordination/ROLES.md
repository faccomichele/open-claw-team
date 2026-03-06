# ROLES.md — Agent Roles & Responsibilities

## OpenClaw Agents (run locally)

| Agent | Workspace | Role | Escalation |
|---|---|---|---|
| CEO | `workspace-ceo` | Strategic advisor, orchestrator; communicates via Telegram | Human (direct chat) |
| PM/Coordinator | `workspace-pm` _(planned)_ | Task breakdown, delegation to Copilot/OpenClaw agents, sprint tracking | CEO |
| Tech Lead | `workspace-tech-lead` _(planned)_ | Architecture decisions, design reviews, owns Copilot instructions & skill files | PM → CEO |
| Biz Research | `workspace-biz-research` _(planned)_ | Market research, opportunity analysis | PM |
| Cost Controller | `workspace-cost-controller` _(planned)_ | Budget monitoring, spend analysis per project repo | PM |

> Add a row here whenever you deploy a new agent to the team. Run `export.sh` after.

## GitHub Copilot Agents (run on GitHub, per project repo)

These agents are defined in `github_copilot_agents/` and deployed to `.github/copilot/agents/` in each target project repo. They handle all code tasks.

| Agent | File | Role |
|---|---|---|
| dev-backend | `dev-backend.md` | Backend implementation (APIs, DB, services) |
| dev-frontend | `dev-frontend.md` | Frontend implementation (React, UI, accessibility) |
| dev-infra | `dev-infra.md` | CI/CD, IaC, deployments, infrastructure |
| test-specialist | `test-specialist.md` | Testing, QA automation, coverage |

> Copilot agents are assigned via GitHub issues (`@copilot:agent-name`). They do not have OpenClaw workspaces.

## Escalation Path

```
Copilot Agent (PR) → PM review → Human merge
Local Specialist    → PM        → CEO → Human
```

- **Copilot agents** execute code tasks; report via PR commits and comments.
- **PM** coordinates sprints, delegates work, tracks all agent progress.
- **CEO** handles strategic decisions, unblocks PM, reports to the human.
- **Human** has final authority on all decisions.

## Adding a New OpenClaw Agent

1. Create a `workspace-<name>/` folder with the standard files (`SOUL.md`, `IDENTITY.md`, `AGENTS.md`, `TOOLS.md`, `USER.md`, `HEARTBEAT.md`).
2. Add the agent to the OpenClaw table above.
3. Run `export.sh` to deploy the workspace to the local OpenClaw instance.

## Adding a New Copilot Agent

1. Create `github_copilot_agents/<name>.md` with YAML front-matter (`name`, `description`) and role instructions.
2. Add the agent to the Copilot table above.
3. Copy to `.github/copilot/agents/<name>.md` in each target project repo where it is needed.
