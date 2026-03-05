# GitHub Copilot Instructions — open-claw-team

## Repository Scope

This repository stores the **skills**, **agent workspace definitions**, and **coordination files** for a collaborative team of [OpenClaw](https://openclaw.ai) agents running on the same host.

### What lives here

| Folder / File | Purpose |
|---|---|
| `skills/` | Reusable skill definitions (`SKILL.md`) that can be loaded by any agent |
| `workspace-<name>/` | Per-agent workspace files: `SOUL.md`, `IDENTITY.md`, `AGENTS.md`, `TOOLS.md`, `USER.md`, `HEARTBEAT.md`, `BOOTSTRAP.md` |
| `coordination/` | Shared markdown files used by all agents to stay in sync and coordinate collaborative work |
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

### Skills (`skills/skills/<name>/SKILL.md`)

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
- Never manually edit files inside `~/.openclaw/` directly when you intend to version-control the change — use the repo as the source of truth and export.

### Security & Privacy

- Do not commit `MEMORY.md` or `memory/` directories — add them to `.gitignore`.
- Do not commit files that contain personal data, authentication tokens, or environment-specific configuration.
- Treat any file under `workspace-*/` as potentially sensitive; review before committing.

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
