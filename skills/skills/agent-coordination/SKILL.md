---
name: agent-coordination
version: 1.0.0
description: Spawn sub-agent sessions, delegate tasks, and coordinate multi-agent work
requires:
  config: [agents.list]
tools: [sessions_spawn, sessions_send, sessions_list, sessions_history, session_status]
author: faccomichele
---

# Agent Coordination & Session Management

Used by PM agent to delegate work to specialists.

## Core Operations

### Spawn specialist session

// Via sessions_spawn tool
{
  "agentId": "dev-backend",
  "message": "Work on TASK-42: Implement GitHub issue sync\n\nContext:\n- Issue: https://github.com/OWNER/REPO/issues/42\n- Requirements: [list]\n- Files to modify: [list]\n\nWhen complete:\n1. Create PR with label 'needs-ai-review'\n2. Comment on issue with summary\n3. Report back to PM"
}

### Check session status

// Via session_status tool
{
  "sessionId": "agent:dev-backend:main:abc123"
}

### Send follow-up to existing session

// Via sessions_send tool
{
  "sessionId": "agent:dev-backend:main:abc123",
  "message": "Update: CEO changed priority. Please also add error handling to the sync logic."
}

## PM Agent Delegation Pattern

When moving a task to "In Progress":

1. **Read task context:**
   - GitHub issue body and comments
   - Related files from `/docs/` or repo
   - Dependencies from `/ops/backlog.json`

2. **Prepare delegation payload:**
   - Task ID and title
   - Clear success criteria
   - Links to relevant docs/issues
   - Explicit deliverables (PR, files, report)
   - Reporting instructions

3. **Spawn appropriate specialist:**
   - `dev-backend` for API/server work
   - `dev-frontend` for UI work
   - `dev-infra` for CI/deployment
   - `biz-research` for market analysis
   - `cost-controller` for budget tasks

4. **Track session:**
   - Store mapping: `TASK-ID → sessionId` in memory
   - Check status periodically
   - Never spawn multiple sessions for same task

5. **Collect results:**
   - Read specialist's GitHub comments
   - Verify deliverables (PR created, files updated)
   - Update `/ops/backlog.json` and `/ops/sprint-board.md`
   - Close loop with CEO if milestone reached

## Guardrails

- **No recursion:** Specialists cannot spawn sub-sessions (only PM can)
- **One session per task:** Don't spawn multiple agents for the same issue
- **Timeout handling:** If session stalls >24 hours, reassess or reassign
- **Human escalation:** For blockers or conflicts, notify CEO via Telegram

## Example Delegation

Work on TASK-42: Implement GitHub issue sync

**Objective:** Create a Node.js module that fetches GitHub issues and updates /ops/backlog.json

**Context:**
- GitHub issue: #42
- Related epic: github-integration (see /docs/roadmap.md)
- Dependencies: None

**Requirements:**
1. Use `gh` CLI or Octokit library
2. Fetch issues labeled 'tracked'
3. Map to backlog.json schema
4. Handle rate limits gracefully
5. Add tests

**Deliverables:**
1. Code in /src/github-sync.js
2. Tests in /tests/github-sync.test.js
3. PR with label 'needs-ai-review'
4. Comment on issue #42 with summary

**Reporting:**
When complete, comment on issue #42 with:
- Files changed
- Test results
- Any blockers or follow-up tasks

PM will review and move to QA.

## Session Lifecycle

PM: Spawn session → Specialist: Work → Specialist: Report
         ↓                                      ↓
   PM: Monitor status                  PM: Verify deliverables
         ↓                                      ↓
   (If blocked: escalate)              Update planning files
                                               ↓
                                       CEO: Review in weekly brief

---

