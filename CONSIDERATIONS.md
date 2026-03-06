# Key things to consider for “startup style” success

If you want this to feel like a functioning early‑stage startup where you’re the CEO:

Make the CEO agent strongly subordinate to you

The CEO agent should never override your decisions; it should propose options, surface risks, and then implement your choice via the PM.
​

Add explicit rules like: “Always summarize options and ask for my decision when stakes are high.”

Keep PM as the single source of truth for work

Only the PM agent edits backlog.json and sprint-board.md.

Other agents request changes via structured outputs or comments; PM approves/merges them.

Define crisp SLAs in prompts

Example for Dev agents: “Every task must end with: (1) files changed, (2) what tests were run, (3) suggested follow‑up tasks, (4) which backlog item status to update.”

Example for QA: “Every run must end with: pass/fail, issues found, affected tasks.”

Guardrails against runaway behavior

In coordinator and specialist prompts, explicitly prohibit:

Delegating back and forth more than once per task.

Spawning new tasks without referencing a clear business goal in vision.md or roadmap.md.

Consider max depth limits for spawn chains and disabling sessions_spawn in specialist agents entirely.

Iteration loop for process

Once a week, ask the CEO or PM agent: “Retrospect on this week’s process: what went wrong, what worked, and what should we change in our prompts or files?”

Let them propose changes to AGENT rules and planning formats, then you approve.

Integration with GitHub from day one (even if minimal)

At least have Dev/QA agents write commit messages and PR summaries referencing TASK‑IDs from backlog.json, so you can manually or automatically sync.
Create/close GitHub Issues
Update GitHub Projects based on backlog.json state.

