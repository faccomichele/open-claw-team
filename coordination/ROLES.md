# ROLES.md — Agent Roles & Responsibilities

## Active Agents

| Agent | Workspace | Role | Escalation |
|---|---|---|---|
| CEO | `workspace-ceo` | Strategic advisor, orchestrator | Human (direct chat) |

> Add a row here whenever you deploy a new agent to the team.

## Escalation Path

```
Specialist → PM → CEO → Human
```

- **Specialists** (dev, biz, infra) handle task execution.
- **PM** coordinates sprints, delegates work, tracks progress.
- **CEO** handles strategic decisions, unblocks PM, reports to the human.
- **Human** has final authority on all decisions.

## Adding a New Agent

1. Create a `workspace-<name>/` folder with the standard files (`SOUL.md`, `IDENTITY.md`, `AGENTS.md`, `TOOLS.md`, `USER.md`, `HEARTBEAT.md`).
2. Add the agent to the table above.
3. Run `export.sh` to deploy the workspace to the local OpenClaw instance.
