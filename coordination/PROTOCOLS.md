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
- **Code tasks** → assign a custom Copilot agent on a GitHub issue via `gh copilot suggest -p bash` (see `skills/agent-coordination/SKILL.md` for the exact command). Do NOT also spawn a local dev session for the same task.
- **Non-code tasks** (research, cost analysis, architecture) → spawn the appropriate local OpenClaw specialist.
- Specialists report back via GitHub issue comments or direct session messages — never by editing another agent's workspace files.
- One delegation per task — do not assign Copilot AND spawn local for the same issue.

### Delegation guardrails

- **No ping-pong**: delegate a task at most once. If the assignee cannot complete it, escalate to PM — do not re-delegate.
- **Every new task must reference a business goal** from `docs/vision.md` or `docs/roadmap.md` in the target project repo. No tasks spawned for their own sake.
- **Max session depth = 2**: CEO → PM → Specialist. Specialists may not spawn further sessions.
- `sessions_spawn` is **disabled** for specialist agents (`biz-research`, `cost-controller`, `tech-lead`) — they receive work, they do not sub-delegate.

## Sprint Kickoff Workflow

When starting a sprint:

1. CEO updates `coordination/SPRINT.md` with the sprint goal and top-priority issues.
2. CEO spawns PM as a **persistent session** (`mode="session"`) — PM runs indefinitely, does not exit between tasks:
   ```json
   {
     "agentId": "pm",
     "mode": "session",
     "label": "PM",
     "message": "Sprint goal: <X>. Priority: <Y>. Current backlog: issues #A-#B. Triage and assign."
   }
   ```
3. PM reads `coordination/SPRINT.md`, triages the backlog, and delegates tasks immediately.
4. PM enters its heartbeat loop (~ 30 minutes), autonomously checking PRs, stuck issues, and stale sessions.
5. PM escalates blockers to CEO (via `sessions_send`) and notifies the human directly via Telegram for merge-ready PRs and sprint completions.
6. CEO sends follow-ups with `sessions_send` — **does not re-spawn PM**. If PM session has died unexpectedly, CEO re-spawns it with current `coordination/SPRINT.md` context.

## Communication Conventions

- Use GitHub issues as the canonical task tracker.
- Status updates go in issue comments (not Telegram, not workspace files).
- Telegram is used for **human-facing notifications** — both CEO and PM may send Telegram messages directly to the human.
- All inter-agent messages must include a task reference (e.g. `TASK-42` or issue URL).

### Telegram usage by agent

| Agent | When to use Telegram |
|---|---|
| CEO | Strategic updates, decisions, sprint kickoff instructions |
| PM | PR ready for merge, sprint complete, critical blocker >24h, periodic summaries |
| All others | Not permitted — route through PM or CEO |

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
| `type:backend` | Backend-specific work (API, DB, services) |
| `type:frontend` | Frontend-specific work (React, UI) |
| `type:infra` | Infrastructure / CI/CD work |
| `type:test` | Testing / QA work |

PM is responsible for keeping `owner:*` labels accurate at all times.

### Issue Assignment Strategy

When PM triages a new issue, apply the following mapping to determine the assignee and set the corresponding `owner:*` label:

| Issue label(s) | Assign to | `owner:*` label |
|---|---|---|
| `type:feature` + `type:backend` (or backend scope is clear) | `dev-backend` Copilot agent | `owner:dev-backend` |
| `type:feature` + `type:frontend` (or frontend scope is clear) | `dev-frontend` Copilot agent | `owner:dev-frontend` |
| `type:feature` (full-stack or unclear) | PM reviews scope; split into sub-issues or assign to the primary affected layer | — |
| `type:backend` | `dev-backend` Copilot agent | `owner:dev-backend` |
| `type:frontend` | `dev-frontend` Copilot agent | `owner:dev-frontend` |
| `type:bug` | Agent that owns the affected area (`owner:*` label on the area); PM decides if cross-cutting | per area |
| `type:infra` | `dev-infra` Copilot agent | `owner:dev-infra` |
| `type:test` | `test-specialist` Copilot agent | `owner:test-specialist` |
| `type:research` | `biz-research` local agent | `owner:biz-research` |
| `type:cost` | `cost-controller` local agent | `owner:cost-controller` |
| Architecture / design review | `tech-lead` local agent | `owner:tech-lead` |

**Rules:**
- PM assigns at most **one** primary owner per issue. Split the issue if multiple agents are needed.
- For `type:bug`, PM examines the affected subsystem and assigns the agent responsible for that area. If the bug is cross-cutting, PM coordinates a fix plan and may assign the agent who owns the most impacted layer.
- Issues with no matching label default to `owner:pm` until triaged.

### CI check naming

When agents are wired into CI workflows, use these check names so the Checks tab is unambiguous:

| Check name | Owner |
|---|---|
| `PM Agent – planning check` | PM |
| `Tech Lead – architecture review` | Tech Lead |
| `QA Agent – test summary` | test-specialist |
| `Cost Controller – budget check` | Cost Controller |

## GitHub Projects Mandate

All actionable and trackable work items **must** be attached to a GitHub Project board. This applies to:

- Issues (features, bugs, research tasks, cost analyses)
- Pull Requests
- Milestones and sprint goals
- Roadmap items
- Effort estimates and task breakdowns

**Who can create a project board:** Both **PM** and **CEO** agents may create a GitHub Project if one does not yet exist for a given project repo. Use the repo-scoped board at `https://github.com/<owner>/<repo>/projects`.

**Workflow:**
1. Before delegating any work, PM verifies that a GitHub Project board exists for the target project repo.
2. If no board exists, PM (or CEO) creates one using the **"Team backlog"** template (Kanban columns: `Backlog`, `In Progress`, `In Review`, `Done`).
3. Every new issue or PR **must** be added to the project board at creation time — PM is responsible for this.
4. Sprint columns must map to the current sprint dates and goal defined in `coordination/SPRINT.md`.
5. Closing an issue without it being on the project board is not permitted — PM must add it retroactively and note the gap in the next sprint review.

> **Why this matters:** GitHub Projects provide the single source of truth for work status. Agents must never track progress only in chat messages, Telegram, or workspace files — the project board is authoritative.

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
