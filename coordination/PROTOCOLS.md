# PROTOCOLS.md — Inter-Agent Collaboration Conventions

## Session Startup

Every agent **must** read the following at the start of each session (in order):

1. `SOUL.md` — core values and constraints
2. `IDENTITY.md` — who you are
3. `coordination/ROLES.md` — who else is on the team
4. `coordination/SPRINT.md` — current goals and blockers (if a sprint is active; note: this file tracks cross-team status only — per-project sprints live in each project repo)
5. `memory/YYYY-MM-DD.md` (today + yesterday) — recent context

## Delegation Rules

- Only the **PM** agent may delegate tasks — either by assigning a GitHub issue to a Copilot agent, or by spawning a local OpenClaw session.
- **Code tasks** → assign to `@copilot:<agent-name>` on a GitHub issue in the target project repo. Do NOT also spawn a local dev session for the same task.
- **Non-code tasks** (research, cost analysis, architecture) → spawn the appropriate local OpenClaw specialist.
- Specialists report back via GitHub issue comments or direct session messages — never by editing another agent's workspace files.
- One delegation per task — do not assign Copilot AND spawn local for the same issue.

## Communication Conventions

- Use GitHub issues as the canonical task tracker.
- Status updates go in issue comments (not Telegram, not workspace files).
- Telegram is reserved for **human-facing** notifications only.
- All inter-agent messages must include a task reference (e.g. `TASK-42` or issue URL).

## Per-Repo Work Items

Project planning files are **always stored in the target project repo**, not in this team config repo. Paths like `docs/roadmap.md`, `ops/backlog.json`, `ops/sprint-board.md`, and `ops/budget.yaml` are relative to **each project repo**. The `coordination/` folder here is for cross-team conventions only.

## Conflict Resolution

- If two agents receive conflicting instructions, escalate to PM immediately.
- If PM receives conflicting instructions from CEO and human, human wins.
- Document all escalations in the relevant GitHub issue.

## File Ownership

- Each agent owns its own `workspace-<name>/` files — do not edit another agent's workspace.
- `coordination/` files are shared and may be updated by any agent.
- `skills/` files may be updated by any agent; bump the version on breaking changes.
- `github_copilot_agents/` files are owned by the **Tech Lead**; the PM may request changes.
