# open-claw-team

Rules, Skills and Identities for a cooperative team of [OpenClaw](https://openclaw.ai) agents running on the same host, paired with a set of [GitHub Copilot](https://github.com/features/copilot) custom agents for code tasks.

## What is this repo?

This repository is the **single source of truth** for a hybrid multi-agent team:

- **OpenClaw agents** (run locally) handle strategy, planning, research, cost monitoring, and architecture.
- **GitHub Copilot agents** (run on GitHub) handle all code tasks (backend, frontend, infra, testing).

The repo stores their identities, skills, configuration, and coordination files. It does **not** store memory, secrets, or project-specific planning (those live in each project repo).

## Repository Layout

| Path | Purpose |
|---|---|
| `workspace-<name>/` | Per-agent workspace files (`SOUL.md`, `IDENTITY.md`, `AGENTS.md`, `TOOLS.md`, `USER.md`, `HEARTBEAT.md`, `BOOTSTRAP.md`, `openclaw.json`) |
| `skills/` | Reusable skill modules (`SKILL.md`) loadable by any OpenClaw agent |
| `coordination/` | Shared markdown files: roles, protocols, sprint board, config reference |
| `github_copilot_agents/` | Source-of-truth definitions for GitHub Copilot custom agents |
| `import.sh` | Pull live state from `~/.openclaw/` into this repo |
| `export.sh` | Push this repo's content to `~/.openclaw/` and restart the gateway |

## Agent Team

### OpenClaw Agents

| Agent | Workspace | Role |
|---|---|---|
| **CEO** | `workspace-ceo` | Strategy, orchestration, human communication via Telegram |
| **PM/Coordinator** | `workspace-pm` | Task breakdown, delegation, sprint tracking |
| **Tech Lead** | `workspace-tech-lead` | Architecture reviews, PR reviews, Copilot agent definitions |
| **Biz Research** | `workspace-biz-research` | Market research, opportunity analysis |
| **Cost Controller** | `workspace-cost-controller` | Budget monitoring, spend analysis |

### GitHub Copilot Agents

| Agent | File | Role |
|---|---|---|
| **dev-backend** | `github_copilot_agents/dev-backend.md` | Backend implementation (Node.js/TypeScript, APIs, DB) |
| **dev-frontend** | `github_copilot_agents/dev-frontend.md` | Frontend (React, accessibility, UI) |
| **dev-infra** | `github_copilot_agents/dev-infra.md` | CI/CD, IaC, deployments |
| **test-specialist** | `github_copilot_agents/test-specialist.md` | Testing, QA automation, coverage |

## Import / Export

```bash
# Capture live agent state into this repo (before committing)
./import.sh

# Apply this repo's content to the live deployment (after pulling)
./export.sh
```

`import.sh` and `export.sh` only update `skills` and `tools` for each agent in `~/.openclaw/openclaw.json`, preserving all other live attributes (e.g. `name`, `model`, conversation history references).

## Agent Configuration (`openclaw.json`)

Each workspace contains an `openclaw.json` that declares the agent's `id`, `skills`, and `tools`:

```json
{
  "id": "pm",
  "skills": ["agent-coordination", "github-issue-ops", "project-planning"],
  "tools": {
    "allow": ["sessions_spawn", "sessions_send", "exec", "read", "write", "message"],
    "deny": ["delete_file", "rm"]
  }
}
```

The main `~/.openclaw/openclaw.json` aggregates all agents under `agents.list[]`. See `coordination/OPENCLAW_CONFIG.md` for the full format reference.

## Key Conventions

- **Comment signing**: every agent prefixes its GitHub comments with its emoji+name (e.g. `📋 [PM Agent]`). See `coordination/PROTOCOLS.md`.
- **Label ownership**: issues are tagged `owner:<agent>` and `type:<feature|bug|research|cost>`. PM keeps these accurate.
- **Human-only decisions**: merges to main, budget cap changes, and new product lines always require explicit human approval.
- **Delegation depth**: CEO → PM → Specialist (max 2 hops). Specialists cannot spawn further sessions.
- **Per-repo work items**: backlog, sprint board, budget, and costs live in each **project repo**, not here.

## Deploying a Copilot Agent to a Project Repo

1. Copy the relevant file from `github_copilot_agents/` to `.github/copilot/agents/` in the target repo.
2. Enable custom agents in that repo's Settings → Copilot.
3. Update `coordination/ROLES.md` if you are adding a new agent type.

## Further Reading

- `coordination/ROLES.md` — full role & escalation reference
- `coordination/PROTOCOLS.md` — delegation rules, communication conventions, guardrails
- `coordination/OPENCLAW_CONFIG.md` — `openclaw.json` format and available tools
- `CONSIDERATIONS.md` — design considerations and best practices for running the team
- `ARCHITECTURE_SUMMARY.md` — high-level system architecture overview
