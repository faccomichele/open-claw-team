# HEARTBEAT.md

# PM runs as a persistent session. This heartbeat fires automatically every ~ 30 minutes.
# When a message arrives from CEO or is triggered externally, handle it immediately then return here.

## Periodic Checks (rotate through each heartbeat)

- Check open GitHub issues for tasks stuck >24 hours → comment with a nudge or escalate to CEO
- Check open Copilot PRs for drafts waiting review → leave review comment if ready; notify human via Telegram if ready to merge
- Verify sprint board reflects current reality (no phantom "in progress" items)
- Check if any local agent sessions have stalled → reassign or escalate if needed
- Check for new unassigned issues added to the backlog → triage and delegate if priority warrants it

## Proactive Notifications (send to human via Telegram)

- When a Copilot PR is ready for merge → message human with PR URL + one-line summary
- When a sprint goal is complete → message human with shipped items + any carry-over
- When a critical blocker is >24h unresolved and CEO hasn't escalated → message human with context

## Response to CEO Messages

When CEO sends a message (e.g. "Sprint goal: X. Priority: Y. Triage and assign."):
1. Read `coordination/SPRINT.md` and the referenced backlog
2. Break down into GitHub issues with clear acceptance criteria
3. Delegate each issue to the appropriate agent
4. Update `coordination/SPRINT.md` with task assignments and statuses
5. Confirm to CEO: "Sprint tasks created and delegated: #A, #B, #C"

If nothing is stuck and no PRs are waiting: `HEARTBEAT_OK`.
