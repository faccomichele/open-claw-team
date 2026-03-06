## Architecture Summary: Hybrid Multi-Agent System

### Agents Running Locally (OpenClaw)

| Agent | Responsibility | Why Local | Tools |
|-------|---------------|-----------|-------|
| **CEO** | Vision, priorities, strategic decisions | Needs Telegram access, represents you | Telegram, read planning files |
| **PM/Coordinator** | Task breakdown, delegation, progress tracking | Central orchestrator needs full context | GitHub CLI, sessions_spawn, planning files |
| **Tech Lead** | Architecture decisions, design reviews | Strategic technical oversight | Read/write docs, comment on PRs |
| **Biz Research** | Market research, opportunity analysis | Requires web search + synthesis | Web search, web fetch, write reports |
| **Cost Controller** | Budget monitoring, spend analysis | Needs multi-source cost data aggregation | Read cost exports, GitHub API, write dashboards |

### Agents Running on GitHub (Copilot Custom Agents)

| Agent | Responsibility | Why Copilot | Advantages |
|-------|---------------|-------------|------------|
| **dev-backend** | Backend implementation | Native GitHub workflow, autonomous coding | Runs in GitHub Actions env, tests code, iterates on PR |
| **dev-frontend** | Frontend implementation | Native GitHub workflow, UI validation | Can capture screenshots, test responsiveness |
| **dev-infra** | CI/CD, infrastructure | Native GitHub workflow, deployment expertise | Access to Actions, repo secrets, infrastructure context |
| **test-specialist** | Testing, QA automation | Native GitHub workflow, code coverage | Runs full test suites, analyzes coverage, validates builds |

### Workflow: PM Delegates by Task Type

User (CEO) → CEO Agent → PM Agent → [Decision Point]
                                          ↓
                          ┌───────────────┴───────────────┐
                          ↓                               ↓
                    Code Task?                     Non-Code Task?
                          ↓                               ↓
            Create detailed GitHub issue         Spawn local OpenClaw session
                          ↓                               ↓
         Assign to @copilot:agent-name           biz-research / cost-controller
                          ↓                               ↓
              Copilot creates draft PR            Agent writes files/reports
                          ↓                               ↓
              Copilot iterates on PR          Agent comments on GitHub issue
                          ↓                               ↓
              PM reviews, requests changes         PM verifies deliverables
                          ↓                               ↓
              Human merges when ready           Update planning files

### Key Benefits of This Hybrid Approach

**Copilot for code tasks:**
- ✅ Native GitHub environment (runs in Actions, tests in real repo)
- ✅ Autonomous iteration (creates PR, gets feedback, pushes commits)
- ✅ Transparent (all work visible in commits and PR timeline)
- ✅ Collaborative (team can comment and guide)
- ✅ No local compute cost (runs on GitHub infrastructure)
- ✅ Can capture screenshots and validate UI changes
- ✅ Specialized agents with role-specific expertise

**OpenClaw for strategic tasks:**
- ✅ Complex research requiring web search + synthesis
- ✅ Multi-source cost data aggregation
- ✅ Coordination and delegation logic
- ✅ Telegram notifications for CEO
- ✅ Full control over prompts and tools
- ✅ Access to local scripts and custom workflows

### When NOT to Use Copilot

- ❌ Cross-repo changes (Copilot limited to one repo per task)
- ❌ Tasks requiring extensive web research
- ❌ Cost/budget analysis (needs multi-source aggregation)
- ❌ Strategic architecture decisions (needs human-level judgment)
- ❌ Tasks involving sensitive credentials or production access

### Cost Comparison

| Approach | Cost Model |
|----------|------------|
| **All OpenClaw (local dev agents)** | Local compute + LLM API costs per agent run |
| **Hybrid (Copilot + OpenClaw)** | GitHub Copilot subscription ($10-39/user/mo) + OpenClaw API costs for research/ops agents only |
| **Break-even point** | If >20 code tasks/month, Copilot cheaper than local LLM calls for dev work |

### Migration Path

**Phase 1 (Now)**: Set up hybrid architecture
1. Create GitHub Copilot custom agents (4 agents: backend, frontend, infra, test)
2. Install OpenClaw skills (update agent-coordination skill)
3. Configure PM agent to delegate by task type

**Phase 2 (Week 2)**: Test delegation patterns
1. Create 2-3 code tasks, assign to Copilot agents
2. Create 1 research task, spawn local biz-research agent
3. Verify PM can track both delegation types

**Phase 3 (Week 3)**: Scale up
1. Batch assign multiple issues to Copilot
2. Monitor PR quality and iteration patterns
3. Tune custom agent prompts based on results

**Phase 4 (Month 2)**: Optimize
1. Add more specialized Copilot agents if needed (mobile, docs, security)
2. Fine-tune agent role descriptions based on observed behavior
3. Implement automated PR review flow

