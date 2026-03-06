# Key things to consider for “startup style” success

## Make the CEO agent strongly subordinate to you

The CEO agent should never override your decisions; it should propose options, surface risks, and then implement your choice via the PM.
​
Add explicit rules like: “Always summarize options and ask for my decision when stakes are high.”

## Keep PM as the single source of truth for work

Only the PM agent edits backlog.json and sprint-board.md.
Other agents request changes via structured outputs or comments; PM approves/merges them.

## Define crisp SLAs in prompts

Example for Dev agents: “Every task must end with: (1) files changed, (2) what tests were run, (3) suggested follow‑up tasks, (4) which backlog item status to update.”
Example for QA: “Every run must end with: pass/fail, issues found, affected tasks.”

## Guardrails against runaway behavior

In coordinator and specialist prompts, explicitly prohibit:
- Delegating back and forth more than once per task.
- Spawning new tasks without referencing a clear business goal in vision.md or roadmap.md.
- Consider max depth limits for spawn chains and disabling sessions_spawn in specialist agents entirely.

## Iteration loop for process

Set both the CEO and PM agents to report weekly: “Retrospect on this week’s process: what went wrong, what worked, and what should we change in our prompts or files?”

Let them propose changes to AGENT rules and planning formats, then you approve.

# Critical considerations so it behaves as expected

## Clear labelling & conventions

Decide and document:
- Ownership labels (owner:pm, owner:biz-research, owner:cost-controller, etc.).
- Task types (type:feature, type:bug, type:research, type:cost).
- How Board columns map to agent actions (only moving to In Progress should wake agents).

## Guardrails in prompts

CEO and PM:

- Must never change budget caps without an explicit directive from you.
- Must ask before enabling any auto‑merge or write access beyond labels/comments.

Biz research:

- Must always include sources and confidence; never make financial commitments.

Cost Controller:

- Must never auto‑delete infra or repos; only recommend cuts with rationale.

## Human‑only decisions

Non‑delegable: merges to main, budget cap changes, entering new product lines.

Agents propose; you approve via GitHub (merges) or Telegram commands.

## How to know which agent is doing what

1) Issues and assignment

Use GitHub fields and labels, not separate accounts:

- Assignee: usually a human (you) or left blank.
- Agent‑owner labels: e.g.
    owner:pm
    owner:dev-backend
    owner:biz-research
    owner:cost-controller

PM / coordinator agent is responsible for keeping these labels accurate, and that’s how you see “who” is expected to work an issue.

Also use: type:feature, type:research, type:cost to distinguish work types.

2) Comments and reviews

Have each agent sign its comments in a consistent way, even though the GitHub user is the same:

Comment header convention, for example:

🧭 [PM Agent]

👨‍💻 [Dev Backend Agent]

📊 [Cost Controller Agent]

📈 [Biz Research Agent]

So a PR timeline might show multiple comments from yourname-bot, but the first line clearly says which internal agent is speaking.

You can enforce this with small prompt snippets in each agent’s AGENTS.md:

“Prefix every GitHub comment you write with 🧭 [PM Agent].”

3) Commits and branches

Use the same GitHub account, but set different git author names per agent while keeping a bot email.
​
e.g.

GIT_AUTHOR_NAME="Dev Backend Agent (bot)"

GIT_AUTHOR_EMAIL="yourname-bot@users.noreply.github.com"

This way git log --author="Dev Backend Agent" shows just that agent’s commits, but they all authenticate via the same GitHub account/SSH key.
​
4) Checks and CI

If you wire agents into CI (e.g. review/check workflows), use distinct check names:

PM Agent – planning check

QA Agent – test summary

Cost Controller – budget check

So on a PR’s “Checks” tab it’s obvious which logical agent produced each report.
