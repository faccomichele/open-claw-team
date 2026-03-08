# GitHub Copilot Instructions — open-claw-team

## Repository Scope

This repository stores the **skills**, **agent workspace definitions**, and **coordination files** for a collaborative team of [OpenClaw](https://openclaw.ai) agents running on the same host.

### What lives here

| Folder / File | Purpose |
|---|---|
| `skills/` | Reusable skill definitions (`SKILL.md`) that can be loaded by any agent |
| `workspace-<name>/` | Per-agent workspace files: `SOUL.md`, `IDENTITY.md`, `AGENTS.md`, `TOOLS.md`, `USER.md`, `HEARTBEAT.md`, `BOOTSTRAP.md` |
| `coordination/` | Shared markdown files used by all agents to stay in sync and coordinate collaborative work |
| `github_copilot_agents/` | Source-of-truth definitions for GitHub Copilot custom agents (deployed to each project repo) |
| `import.sh` | Pulls the latest live state from the local OpenClaw deployment into this repo |
| `export.sh` | Pushes this repo's content back to the local OpenClaw deployment and restarts the gateway |

### What does NOT live here

- Agent memory files (`memory/YYYY-MM-DD.md`, `MEMORY.md`) — these are private and local-only
- Secrets, credentials, API keys
- Generated artefacts or build output

---

## Best Practices

### General

- Keep every file focused on its single responsibility (one skill per `SKILL.md`, one agent per workspace folder).
- Use descriptive, lowercase, hyphen-separated names for skill and workspace folders (e.g. `git-operations`, `workspace-pm`).
- Write skills so they can be loaded by *any* agent — avoid hard-coding agent-specific assumptions inside a skill.

### Skills (`skills/<name>/SKILL.md`)

- Start every `SKILL.md` with valid YAML front-matter: `name`, `version`, `description`, `requires`, `tools`, `author`.
- Bump `version` whenever you make a breaking change.
- Document every tool call with a concrete JSON example.
- List dependencies under `requires.config` so agents know what to configure before loading the skill.

### Agent Workspaces (`workspace-<name>/`)

- `SOUL.md` defines the agent's core values and constraints — change it deliberately and always tell the human.
- `IDENTITY.md` stores the agent's name, creature type, vibe, and emoji.
- `AGENTS.md` is the operating manual — rules, memory strategy, safety guidelines, group-chat behaviour.
- `HEARTBEAT.md` is a short, actionable checklist; keep it small to limit token burn.
- `BOOTSTRAP.md` is a one-time setup file; delete it after first run.
- Never store private or sensitive data in workspace files committed to this repo.

### Coordination (`coordination/`)

- Use this folder for markdown files that multiple agents need to read in order to work in sync (e.g. sprint board, shared backlog, role assignments, escalation protocols).
- Keep files concise — agents load them on every session so size matters.
- Name files clearly: `SPRINT.md`, `ROLES.md`, `ESCALATION.md`, etc.
- All agents should read the relevant coordination files at the start of each session, just like their own workspace files.

### Import / Export workflow

- Run `import.sh` to capture the current live state from your local OpenClaw deployment into the repo before committing.
- Run `export.sh` after pulling the latest version from the repo to apply changes to the live deployment and restart the gateway.
- `import.sh` and `export.sh` only update the `skills` and `tools` fields for each agent in `~/.openclaw/openclaw.json`, leaving all other agent attributes (e.g. `name`, `model`, runtime state) intact.
- Never manually edit files inside `~/.openclaw/` directly when you intend to version-control the change — use the repo as the source of truth and export.

### Security & Privacy

- Do not commit `MEMORY.md` or `memory/` directories — add them to `.gitignore`.
- Do not commit files that contain personal data, authentication tokens, or environment-specific configuration.
- Treat any file under `workspace-*/` as potentially sensitive; review before committing.

---

## Hybrid Architecture

This team runs as a **hybrid multi-agent system**. Understand both layers:

### OpenClaw Agents (run locally)

| Agent | Workspace | Responsibility |
|---|---|---|
| **CEO** | `workspace-ceo` | Vision, strategy, final decisions — communicates via Telegram |
| **PM/Coordinator** | `workspace-pm` | Task breakdown, delegation, sprint tracking |
| **Tech Lead** | `workspace-tech-lead` | Architecture decisions, design reviews |
| **Biz Research** | `workspace-biz-research` | Market research, opportunity analysis |
| **Cost Controller** | `workspace-cost-controller` | Budget monitoring, spend analysis |

### GitHub Copilot Agents (run on GitHub)

Defined in `github_copilot_agents/` and deployed to `.github/copilot/agents/` in each target project repo.

| Agent | File | Responsibility |
|---|---|---|
| **dev-backend** | `dev-backend.md` | Backend implementation (Node.js/TypeScript, APIs, DB) |
| **dev-frontend** | `dev-frontend.md` | Frontend implementation (React, accessibility, UI) |
| **dev-infra** | `dev-infra.md` | CI/CD, infrastructure as code, deployments |
| **test-specialist** | `test-specialist.md` | Testing, QA automation, coverage |

### Delegation Flow

- **Code tasks** → PM creates a GitHub issue and assigns a custom Copilot agent via the GitHub web UI: set the issue assignee to `@copilot`, then select the custom agent from the prompt that appears.
- **Non-code tasks** (research, cost analysis, architecture review) → PM spawns a local OpenClaw session.
- **Never** assign both a Copilot agent and a local agent to the same issue.
- **Max session depth = 2**: CEO → PM → Specialist. Specialists may not spawn further sessions.

### Agent Identification Conventions

Every agent prefixes its GitHub comments with its emoji and name so it is unambiguous which agent is speaking, even when all agents share the same GitHub account.

| Agent | Comment prefix |
|---|---|
| CEO | `🧭 [CEO Agent]` |
| PM/Coordinator | `📋 [PM Agent]` |
| Tech Lead | `🔧 [Tech Lead Agent]` |
| Biz Research | `📈 [Biz Research Agent]` |
| Cost Controller | `📊 [Cost Controller Agent]` |
| dev-backend (Copilot) | `👨‍💻 [dev-backend]` |
| dev-frontend (Copilot) | `🎨 [dev-frontend]` |
| dev-infra (Copilot) | `⚙️ [dev-infra]` |
| test-specialist (Copilot) | `🧪 [test-specialist]` |

For commits, set `GIT_AUTHOR_NAME` to identify the agent while keeping a shared bot email (e.g. `GIT_AUTHOR_NAME="Dev Backend Agent (bot)"`).

### Human-Only Decisions

The following are **non-delegable** — agents surface options and wait for explicit human approval:

- Merging a PR to the main branch
- Changing any budget cap in `ops/budget.yaml`
- Entering a new product line or pivoting strategic direction
- Enabling auto-merge or write access for any agent

---

## GitHub Copilot Agents (`github_copilot_agents/`)

The `github_copilot_agents/` folder is the **source of truth** for all Copilot agent definitions.

### Deployment

Each agent definition is a Markdown file with YAML front-matter (`name`, `description`). To activate an agent in a project repo:

1. Copy the relevant `.md` file to `.github/copilot/agents/` in the target repo.
2. Enable custom agents in that repo's Settings → Copilot.

### Ownership & Maintenance

- **Tech Lead** authors and reviews agent definitions — they encode architectural standards and coding conventions.
- **PM** may request updates when delegation patterns change.
- **Human (CEO)** approves structural changes to agent roles.
- Changes here are **global templates**; repo-specific overrides live in each project repo's `.github/copilot/agents/`.

---

## Per-Repo Work Items

Project planning files (`roadmap`, `backlog`, `sprint-board`, `budget`) are **always scoped to the specific project repo** they belong to. They live inside the target project's repository, not in this team config repo.

| File | Location | Owner |
|---|---|---|
| `docs/vision.md` | Target project repo | CEO Agent |
| `docs/roadmap.md` | Target project repo | PM Agent |
| `ops/backlog.json` | Target project repo | PM Agent |
| `ops/sprint-board.md` | Target project repo | PM Agent |
| `ops/budget.yaml` | Target project repo | CEO (Cost Controller updates actuals) |
| `ops/costs.md` | Target project repo | Cost Controller Agent |

> **Why per-repo?** Budget constraints, sprint goals, and backlog items are tightly coupled to a specific project context. A global sprint board would mix unrelated projects and create confusion for agents.

The `coordination/` folder in this repo is only for **cross-team conventions** (roles, protocols) — not for project-specific planning.

---

## Infrastructure Best Practices

These rules apply to all agents (especially `dev-infra`) when creating or managing cloud resources:

### 1. Always Use Infrastructure as Code (IaC)

- **Never** create cloud resources manually (via console, CLI ad-hoc commands, or scripts that are not committed).
- All resources must be defined in IaC (Terraform, CloudFormation, Bicep, or equivalent).
- IaC files live in the target project repo under `infra/` or `terraform/`.
- The `dev-infra` Copilot agent is responsible for all IaC changes; no other agent may modify infrastructure definitions.

### 2. Tag All Resources

Every cloud resource **must** have the following tags at creation time:

| Tag key | Value | Purpose |
|---|---|---|
| `repo` | `owner/repo-name` | Associates resource with the GitHub repo that owns it |
| `env` | `DEV` or `PROD` | Distinguishes environment; never share resources across envs |
| `managed-by` | `terraform` (or IaC tool name) | Signals IaC ownership; blocks manual deletion |

Example (Terraform):
```hcl
tags = {
  repo       = "faccomichele/my-app"
  env        = var.environment   # "DEV" or "PROD"
  managed-by = "terraform"
}
```

### 3. Regional vs Global Resources

- **Global resources** (e.g., S3 bucket names, IAM roles, CloudFront distributions, DNS records) require **globally unique names**. Include `env` and an abbreviated repo slug in the name to prevent clashes (e.g., `myapp-prod-static-assets`, not `static-assets`).
- **Regional resources** (e.g., EC2, RDS, Lambda) must specify an explicit region; never rely on provider defaults.
- Document the region for every resource in the IaC code.

---

## Copilot Instructions & Skill File Management

| File type | Location | Who creates/updates |
|---|---|---|
| **Copilot instructions** (this file) | `.github/copilot-instructions.md` in each repo | **Tech Lead** drafts; **PM** reviews; **human** approves significant changes |
| **Copilot agent definitions** | `github_copilot_agents/<name>.md` (source of truth) → deployed to `.github/copilot/agents/<name>.md` in each repo | **Tech Lead** (content/constraints) with **PM** input (delegation needs) |
| **OpenClaw skills** | `skills/<name>/SKILL.md` in this repo | Any agent can update; bump `version` on breaking changes; **human** reviews structural changes |

> **Rule:** Copilot instructions and agent definitions encode the team's working agreements. Treat them like documentation in code — reviewed, versioned, and intentional. The Tech Lead holds the pen; the PM holds the requirements.

---

## OpenClaw Concepts Quick Reference

| Term | Meaning |
|---|---|
| **Agent** | An OpenClaw instance with its own workspace, identity, and memory |
| **Skill** | A reusable capability module loaded by an agent (`SKILL.md`) |
| **Session** | A single conversation turn / task execution context |
| **Heartbeat** | A periodic poll that lets an agent do proactive background work |
| **Gateway** | The OpenClaw process that routes messages between agents and external services |
| **Workspace** | The folder containing all persistent files for a single agent |
| **Coordination folder** | Shared repo folder with markdown files all agents read to stay in sync |
