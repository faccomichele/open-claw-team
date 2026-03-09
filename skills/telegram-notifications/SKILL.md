---
name: telegram-notifications
version: 1.1.0
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

## Proposing Choices with Inline Buttons

**Always use Telegram inline keyboard buttons** when asking the human to choose between options. Never ask the human to type a reply.

Pass a `reply_markup` with an `inline_keyboard` in the `message` tool call. Each button's `callback_data` is the machine-readable value the agent will receive when the human taps it.

### Two-option (yes / no)

```json
{
  "text": "🚨 Budget alert: GitHub Actions is at 92% for March.\nApprove a $20 top-up to avoid workflow failures?",
  "reply_markup": {
    "inline_keyboard": [
      [
        { "text": "✅ Approve", "callback_data": "approve" },
        { "text": "❌ Reject",  "callback_data": "reject"  }
      ]
    ]
  }
}
```

### Go / propose alternatives

```json
{
  "text": "📋 Sprint 7 plan is ready.\n\n• 6 issues triaged\n• Est. 8 story points\n• Goal: ship auth MVP\n\nReady to kick off?",
  "reply_markup": {
    "inline_keyboard": [
      [
        { "text": "🚀 Go",                 "callback_data": "go"      },
        { "text": "💬 Propose changes",    "callback_data": "propose" }
      ]
    ]
  }
}
```

### Multi-option (three or more)

Put each option on its own row for readability on mobile:

```json
{
  "text": "🔧 Tech debt spike detected in auth module.\nHow should we handle it?",
  "reply_markup": {
    "inline_keyboard": [
      [{ "text": "🗓 Schedule next sprint", "callback_data": "schedule" }],
      [{ "text": "⚡ Fix now (unblock)",    "callback_data": "fix_now"  }],
      [{ "text": "🚫 Ignore for now",       "callback_data": "ignore"   }]
    ]
  }
}
```

### Rules for inline buttons

- **Always prefer buttons** over free-text prompts. If Telegram does not deliver buttons in a particular context (e.g. a broadcast channel without bot interaction), fall back to numbered list options and explicitly note the limitation so the human knows to reply with a number.
- Keep button labels short (≤ 20 characters) and add an emoji prefix.
- Use lowercase `snake_case` for `callback_data` values.
- One decision per message — don't stack unrelated choices in a single keyboard.
- After the human taps a button, acknowledge the selection in your next message (e.g. "✅ Got it — proceeding with approval.").

## Best Practices

- **Use emoji for visual scanning** - 🎉 ✅ ⚠️ 🚨 📊 🚫
- **Keep it concise** - CEO reads on mobile
- **Always include action items** - what needs human decision?
- **Use inline buttons for every choice** - never ask the human to type an option
- **Link to GitHub** - don't duplicate full details in Telegram
- **Respect urgency** - critical alerts only for true emergencies
- **Batch updates** - daily summary > 20 individual messages

---

