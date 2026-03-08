---
name: agent-coordination
version: 1.1.0
description: Delegate tasks to GitHub Copilot coding agents (for dev work) or spawn local OpenClaw sessions (for research/ops)
requires:
  config: [agents.list]
tools: [sessions_spawn, sessions_send, sessions_list, sessions_history, session_status]
author: faccomichele
---

# Agent Coordination & Delegation (Hybrid Architecture)

PM/Coordinator delegates work based on task type:
- **Code implementation** → GitHub Copilot custom agents
- **Research, cost analysis, planning** → Local OpenClaw agents

## Delegation Decision Matrix

| Task Type | Delegate To | Method |
|-----------|-------------|--------|
| Feature implementation | GitHub Copilot (custom dev agent) | `gh copilot suggest -p bash` → assign `dev-backend` |
| Bug fix | GitHub Copilot (custom dev agent) | `gh copilot suggest -p bash` → assign `dev-frontend` |
| Refactoring | GitHub Copilot (custom dev agent) | `gh copilot suggest -p bash` → assign `dev-backend` |
| Infrastructure/DevOps | GitHub Copilot (custom infra agent) | `gh copilot suggest -p bash` → assign `dev-infra` |
| Test writing | GitHub Copilot (test specialist) | `gh copilot suggest -p bash` → assign `test-specialist` |
| Market research | OpenClaw Biz Research agent | `sessions_spawn` with agentId `biz-research` |
| Cost analysis | OpenClaw Cost Controller agent | `sessions_spawn` with agentId `cost-controller` |
| Architecture review | OpenClaw Tech Lead agent | `sessions_spawn` with agentId `tech-lead` |

## GitHub Copilot Delegation (for Code Tasks)

### 1. Create well-structured issue

Issue requirements for Copilot success:
- **Clear title**: `feat: implement GitHub issue sync`
- **Detailed description** with sections:
  - **Objective**: What needs to be built
  - **Context**: Why this matters, related work
  - **Requirements**: Functional specs (numbered list)
  - **Technical constraints**: APIs, patterns, dependencies
  - **Acceptance criteria**: How to verify success
  - **Files to modify**: Specific paths if known

### 2. Assign to appropriate custom Copilot agent

Use `gh copilot suggest` with the `-p` (pipe/non-interactive) flag to generate and execute the correct assignment command.
Replace `ISSUE_NUMBER` with the issue number, `OWNER/REPO` with the repository, and the agent name with the appropriate custom agent:

```bash
# Example: assign issue 42 in myorg/myrepo to dev-backend
gh copilot suggest -p bash "assign issue ISSUE_NUMBER in OWNER/REPO to the dev-backend custom GitHub Copilot agent" | bash
```

Replace `dev-backend` with the appropriate agent name:

- `dev-backend` - Backend specialist
- `dev-frontend` - Frontend specialist
- `dev-infra` - Infrastructure & DevOps specialist
- `test-specialist` - Testing & QA specialist

> The `-p bash` flag makes `gh copilot suggest` non-interactive: it writes the suggested shell command directly to stdout so it can be piped or executed in scripts.

### 3. Add agent-specific context in issue body

Include an **"Agent Instructions"** section:

## Agent Instructions for dev-backend

**Your role**: You are a **senior backend engineer** specializing in Node.js/TypeScript APIs, database design, and integration patterns.

**Your focus**:
- Write production-ready, type-safe code
- Follow repository coding standards in `/docs/coding-standards.md`
- Prioritize error handling and logging
- Use existing utilities from `/src/utils/*`
- Add unit tests alongside implementation

**Avoid**:
- Modifying frontend code
- Changing infrastructure configs
- Altering database migrations without approval

**Deliverables**:
1. Implementation in `/src/backend/*`
2. Tests in `/tests/backend/*`
3. Updated API documentation if endpoints changed

### 4. Monitor Copilot's work

Copilot creates a draft PR and works asynchronously. Track progress:

gh pr list --repo OWNER/REPO --author "@copilot" --state open --json number,title,isDraft

### 5. Provide feedback via PR comments

If Copilot needs course correction, comment on the draft PR:

gh pr comment PR_NUMBER --repo OWNER/REPO --body "@copilot Please also add rate limiting to the API endpoint as specified in requirements."

Copilot will iterate and push new commits.

## Local OpenClaw Agent Delegation (for Non-Code Tasks)

### Spawn local specialist session

// Via sessions_spawn tool for research/ops tasks
{
  "id": "biz-research",
  "message": "Research opportunity: AI-powered code review SaaS\n\nContext:\n- Issue: #85\n- Market: Developer tools, B2B SaaS\n- Budget constraint: Validate with <$5K investment\n\nDeliverables:\n1. Market analysis in /business/opportunities/code-review-saas.md\n2. TAM/SAM/SOM estimates\n3. Competitor landscape\n4. Recommendation: Go/No-go"
}

### Check session status

// Via session_status tool
{
  "sessionId": "agent:biz-research:main:abc123"
}

### Send follow-up to existing session

// Via sessions_send tool
{
  "sessionId": "agent:cost-controller:main:xyz789",
  "message": "Update: CEO approved +$50/mo budget increase for Q2. Recalculate projections."
}

## PM Agent Delegation Pattern (Hybrid)

When moving a task to "In Progress":

1. **Read task context:**
   - GitHub issue body and comments
   - Related files from `/docs/` or repo
   - Dependencies from `/ops/backlog.json`

2. **Determine delegation target:**
   - **Code task?** → GitHub Copilot custom agent
   - **Research/ops task?** → Local OpenClaw agent

3. **For Copilot delegation (code tasks):**
   - Ensure issue has detailed requirements + agent instructions
   - Add label and assign the custom Copilot agent in one step:
     ```bash
     # Replace ISSUE_NUMBER, OWNER/REPO, and the agent name as appropriate
     gh issue edit ISSUE_NUMBER --repo OWNER/REPO --add-label "status:in_progress"
     gh copilot suggest -p bash "assign issue ISSUE_NUMBER in OWNER/REPO to the dev-backend custom GitHub Copilot agent" | bash
     ```
   - Do NOT spawn local session

4. **For local OpenClaw delegation (non-code):**
   - Prepare delegation payload with clear deliverables
   - Spawn appropriate specialist: `biz-research`, `cost-controller`, `tech-lead`
   - Track session ID in memory

5. **Track progress:**
   - **Copilot tasks**: Monitor draft PR creation and commits
   - **Local tasks**: Check session status periodically
   - Store mapping: `TASK-ID → (copilot-PR or sessionId)`

6. **Collect results:**
   - **Copilot**: Review draft PR, request changes if needed, approve when ready
   - **Local**: Read agent's file outputs and GitHub comments
   - Update `/ops/backlog.json` and `/ops/sprint-board.md`
   - Notify CEO if milestone reached

## Guardrails

- **No recursion:** Local specialists cannot spawn sub-sessions (only PM can)
- **One delegation per task:** Don't assign Copilot AND spawn local session for same issue
- **Timeout handling:** 
  - **Copilot tasks**: If no PR draft after 30 min, check issue comments for blockers
  - **Local tasks**: If session stalls >24 hours, reassess or reassign
- **Human escalation:** For blockers or conflicts, notify CEO via Telegram
- **Copilot cannot access other repos**: Each Copilot assignment works in one repo only
- **No Copilot for sensitive ops**: Cost/budget decisions stay with local agents

## Example Delegation: Code Task (Copilot)

**Issue #42: Implement GitHub issue sync**

### Issue Body

## Objective
Create a Node.js module that fetches GitHub issues and updates `/ops/backlog.json`

## Context
- Related epic: github-integration (see `/docs/roadmap.md`)
- Part of PM automation suite
- Dependencies: None

## Requirements
1. Use Octokit library for GitHub API access
2. Fetch issues with label `tracked`
3. Map GitHub issue fields to `/ops/backlog.json` schema
4. Handle rate limits gracefully with retry logic
5. Add comprehensive unit tests
6. Follow coding standards in `/docs/coding-standards.md`

## Technical Constraints
- Must work with existing auth in `/src/auth/github-auth.js`
- Respect existing backlog schema (see `/ops/backlog.json`)
- Use existing logger from `/src/utils/logger.js`

## Acceptance Criteria
- [ ] Module exports `syncIssues()` function
- [ ] All tests pass
- [ ] Rate limiting handles 5000 req/hour GitHub limit
- [ ] No breaking changes to backlog.json structure
- [ ] Error cases logged appropriately

## Agent Instructions for dev-backend

**Your role**: Senior backend engineer specializing in Node.js/TypeScript, API integrations, and data transformation.

**Your expertise**:
- Production-ready TypeScript with strict mode
- RESTful API integration patterns
- Error handling and retry logic
- Unit testing with Jest

**Focus areas for this task**:
- Use existing `/src/auth/github-auth.js` for credentials
- Follow repository logging patterns
- Write defensive code (validate all external data)
- Add JSDoc comments for public functions

**Avoid**:
- Don't modify frontend code
- Don't change backlog.json schema
- Don't add new dependencies without justification

**Deliverables**:
1. Implementation in `/src/integrations/github-sync.js`
2. Tests in `/tests/integrations/github-sync.test.js`
3. Update `/README.md` if new env vars needed

### PM Agent Action

```bash
# Replace 42 and OWNER/REPO with the actual issue number and repo
gh issue edit 42 --repo OWNER/REPO --add-label "status:in_progress,owner:copilot-dev-backend"
gh copilot suggest -p bash "assign issue 42 in OWNER/REPO to the dev-backend custom GitHub Copilot agent" | bash
```

## Example Delegation: Research Task (Local Agent)

**Issue #85: Research AI code review SaaS opportunity**

### PM spawns local research agent

{
  "id": "biz-research",
  "message": "Research opportunity: AI-powered code review SaaS targeting mid-size engineering teams\n\nContext:\n- GitHub issue: #85\n- Market hypothesis: Teams want automated PR reviews beyond linting\n- Geographic focus: North America, Europe\n- Success criteria: TAM >$500M, <10 strong competitors\n\nRequirements:\n1. Market size estimation (TAM/SAM/SOM)\n2. Identify top 10 competitors with pricing\n3. Assess distribution channels (developer-led, sales-led)\n4. Technical feasibility (can we build with current stack?)\n5. Business model options\n\nDeliverables:\n1. Full analysis: /business/opportunities/ai-code-review.md\n2. Summary comment on issue #85\n3. Recommendation: Go/No-go/Maybe with rationale\n\nTimeline: Complete within 48 hours"
}

## Task Lifecycle Comparison

### Copilot Task (Code)
PM: gh copilot suggest -p bash → Copilot: Draft PR → Copilot: Commits → PM: Review PR → Human: Merge
         ↓                              ↓                    ↓                ↓              ↓
  assign custom agent             Watch for draft        Monitor commits    Request changes   Update backlog
  (non-interactive CLI)                                                      if needed

### Local Task (Research/Ops)
PM: Spawn session → Agent: Research → Agent: Write files → Agent: Report → PM: Verify
         ↓                  ↓                 ↓                  ↓              ↓
   Track sessionId    Monitor status    Check outputs     Read comment   Update planning

---

