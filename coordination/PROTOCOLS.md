# PROTOCOLS.md — Inter-Agent Collaboration Conventions

## Session Startup

Every agent **must** read the following at the start of each session (in order):

1. `SOUL.md` — core values and constraints
2. `IDENTITY.md` — who you are
3. `coordination/ROLES.md` — who else is on the team
4. `coordination/SPRINT.md` — current goals and blockers
5. `memory/YYYY-MM-DD.md` (today + yesterday) — recent context

## Delegation Rules

- Only the **PM** agent may spawn sub-sessions for other agents.
- Specialists report back via GitHub issue comments or direct session messages — never by editing another agent's workspace files.
- One session per task — do not spawn duplicates for the same issue.

## Communication Conventions

- Use GitHub issues as the canonical task tracker.
- Status updates go in issue comments (not Telegram, not workspace files).
- Telegram is reserved for **human-facing** notifications only.
- All inter-agent messages must include a task reference (e.g. `TASK-42` or issue URL).

## Conflict Resolution

- If two agents receive conflicting instructions, escalate to PM immediately.
- If PM receives conflicting instructions from CEO and human, human wins.
- Document all escalations in the relevant GitHub issue.

## File Ownership

- Each agent owns its own `workspace-<name>/` files — do not edit another agent's workspace.
- `coordination/` files are shared and may be updated by any agent.
- `skills/` files may be updated by any agent; bump the version on breaking changes.
