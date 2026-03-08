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
- **Code tasks** → assign to a custom Copilot agent on a GitHub issue via the GitHub web UI (set assignee to `@copilot`, then select the custom agent in the prompt). Do NOT also spawn a local dev session for the same task.
- **Non-code tasks** (research, cost analysis, architecture) → spawn the appropriate local OpenClaw specialist.
- Specialists report back via GitHub issue comments or direct session messages — never by editing another agent's workspace files.
- One delegation per task — do not assign Copilot AND spawn local for the same issue.

### Delegation guardrails

- **No ping-pong**: delegate a task at most once. If the assignee cannot complete it, escalate to PM — do not re-delegate.
- **Every new task must reference a business goal** from `docs/vision.md` or `docs/roadmap.md` in the target project repo. No tasks spawned for their own sake.
- **Max session depth = 2**: CEO → PM → Specialist. Specialists may not spawn further sessions.
- `sessions_spawn` is **disabled** for specialist agents (`biz-research`, `cost-controller`, `tech-lead`) — they receive work, they do not sub-delegate.

## Communication Conventions

- Use GitHub issues as the canonical task tracker.
- Status updates go in issue comments (not Telegram, not workspace files).
- Telegram is reserved for **human-facing** notifications only.
- All inter-agent messages must include a task reference (e.g. `TASK-42` or issue URL).

### Comment signing

Every agent **must** prefix its GitHub issue and PR comments with its identifier emoji and name. This makes it clear which agent wrote what, even when all agents share the same GitHub account.

| Agent | Prefix |
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

### Commit author naming

When an agent writes commits, set the git author name to identify the agent (while keeping the shared bot email):

```bash
GIT_AUTHOR_NAME="<Agent Name> (bot)"
GIT_AUTHOR_EMAIL="yourname-bot@users.noreply.github.com"
```

Example: `GIT_AUTHOR_NAME="Dev Backend Agent (bot)"`. This makes `git log --author="Dev Backend Agent"` work as an agent filter.

### Label & ownership conventions

Use these GitHub labels consistently across all project repos:

| Label | Meaning |
|---|---|
| `owner:pm` | PM is responsible for driving this issue |
| `owner:dev-backend` | dev-backend Copilot agent is assigned |
| `owner:dev-frontend` | dev-frontend Copilot agent is assigned |
| `owner:dev-infra` | dev-infra Copilot agent is assigned |
| `owner:test-specialist` | test-specialist Copilot agent is assigned |
| `owner:biz-research` | Biz Research local agent is assigned |
| `owner:cost-controller` | Cost Controller local agent is assigned |
| `owner:tech-lead` | Tech Lead local agent is assigned |
| `type:feature` | New feature work |
| `type:bug` | Bug fix |
| `type:research` | Market / technical research |
| `type:cost` | Cost / budget analysis |

PM is responsible for keeping `owner:*` labels accurate at all times.

### CI check naming

When agents are wired into CI workflows, use these check names so the Checks tab is unambiguous:

| Check name | Owner |
|---|---|
| `PM Agent – planning check` | PM |
| `Tech Lead – architecture review` | Tech Lead |
| `QA Agent – test summary` | test-specialist |
| `Cost Controller – budget check` | Cost Controller |

## Human-Only Decisions

The following decisions are **non-delegable** — agents must surface options and wait for explicit human approval:

- Merging a PR to the main branch
- Changing any budget cap in `ops/budget.yaml`
- Entering a new product line or pivoting strategic direction
- Enabling auto-merge or write access for any agent

Agents **propose**; the human **approves** via GitHub (merges) or Telegram command.

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
