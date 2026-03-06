---
name: telegram-notifications
version: 1.0.0
description: Send alerts and summaries to Telegram CEO/notifications channel
requires:
  config: [channels.telegram.enabled]
tools: [message]
author: faccomichele
---

# Telegram Notification Skill

Send important updates to the CEO via Telegram.

## When to Send Notifications

### CEO Agent
- Daily/weekly status summaries (on request)
- Major milestone completions
- Strategic decision points requiring human input

### PM Agent
- Sprint start/end summaries
- Blocker alerts (tasks stuck >48 hours)
- Weekly velocity reports

### Cost Controller
- Budget threshold breaches (>70% warning, >90% critical)
- Unusual spend spikes
- Monthly cost reports

### QA Agent
- Critical test failures on main branch
- Security vulnerabilities found in dependencies
- High-priority PR review results

### Biz Research Agent
- Research completion notifications
- High-confidence opportunities discovered

## Message Format

Use the `message` tool with these patterns:

### Status Summary
📊 Weekly Status - Sprint 2026-03-1

**Completed:** 8 tasks
**In Progress:** 4 tasks
**Blocked:** 1 task

**Highlights:**
✅ GitHub integration MVP deployed
⚠️ Cost dashboard delayed (backend dep)

**Blockers:**
🚫 TASK-42: Waiting on API key approval

Full details: [GitHub link]

### Critical Alert
🚨 URGENT: Budget Alert

**Category:** GitHub Actions
**Current:** 92% of monthly budget
**Projection:** Will exceed by Mar 10

**Top drivers:**
- PR checks on feat/* branches: 45 min/day
- Scheduled workflows: 30 min/day

**Recommendations:**
1. Reduce PR check frequency
2. Pause non-critical scheduled jobs
3. Approve $20 budget increase

Requires decision: [GitHub issue link]

### Milestone Completion
🎉 Milestone Reached: GitHub Integration MVP

**Epic:** github-integration
**Delivered:** Mar 5, 2026 (2 days early)

**Features:**
✅ Issue sync
✅ PR automation  
✅ CI integration

**Next:** Begin user testing phase

Project board: [link]

## Best Practices

- **Use emoji for visual scanning** - 🎉 ✅ ⚠️ 🚨 📊 🚫
- **Keep it concise** - CEO reads on mobile
- **Always include action items** - what needs human decision?
- **Link to GitHub** - don't duplicate full details in Telegram
- **Respect urgency** - critical alerts only for true emergencies
- **Batch updates** - daily summary > 20 individual messages

---

