---
name: cost-tracking
version: 1.0.0
description: Track infrastructure costs, token usage, and budget compliance
tools: [read, write, exec]
author: faccomichele
---

# Cost Tracking & Budget Control

Monitor spend across cloud, CI, and AI services against defined budgets.

## Core Files

### `/ops/budget.yaml`
Budget caps and alert thresholds.

**Owned by:** CEO (Cost Controller updates actuals)

**Format:**
period: monthly
currency: USD
caps:
  cloud_infra: 300      # AWS/GCP/Azure
  github_actions: 50     # CI minutes
  openclaw_tokens: 150   # LLM API costs
alerts:
  warn_at: 0.7    # 70% threshold
  critical_at: 0.9  # 90% threshold

### `/ops/costs.md`
Current spend dashboard and analysis.

**Owned by:** Cost Controller Agent

**Format:**
# Cost Dashboard - March 2026

## Summary (as of Mar 5)
| Category | Budget | Actual | % Used | Status |
|----------|--------|--------|--------|--------|
| Cloud Infra | $300 | $187 | 62% | ✅ Healthy |
| GitHub Actions | $50 | $42 | 84% | ⚠️ Warning |
| OpenClaw Tokens | $150 | $98 | 65% | ✅ Healthy |

## Alerts
- ⚠️ GitHub Actions at 84% - projected to exceed budget by Mar 20
- Recommendation: Reduce CI frequency or optimize workflows

## Top Cost Drivers
1. AWS Lambda invocations: $95
2. OpenAI API (o1-mini): $78
3. GitHub Actions minutes: $42

### `/ops/raw-costs/` directory
Export files from cost sources (CSV, JSON).

**Populated by:** External scripts or manual exports

## Operations

### Daily Cost Controller Run

1. **Read budget config:**
   cat /ops/budget.yaml

2. **Collect cost data:**
   - Read `/ops/raw-costs/*.json` (AWS, GCP exports)
   - Parse OpenClaw token logs
   - Query GitHub Actions billing via `gh api`

3. **Calculate spend vs budget:**
   for category in ['cloud_infra', 'github_actions', 'openclaw_tokens']:
       usage_pct = actual / cap
       if usage_pct > warn_threshold:
           # Generate alert

4. **Update dashboard:**
   - Write summary table to `/ops/costs.md`
   - Update status emoji (✅/⚠️/🚨)
   - Add commentary on trends

5. **Create/update budget issue:**
   gh issue list --label "type:cost" --state open
   # If exists, comment with update
   # If critical, also send Telegram alert

### Alert Conditions

- **Healthy** (< 70%): No action, routine update
- **Warning** (70-90%): Comment on issue, include in weekly CEO brief
- **Critical** (> 90%): Urgent issue comment + Telegram alert to CEO

### Recommendations Format

Always include:
- Current trajectory (will exceed by X%)
- Specific cost drivers causing overrun
- 2-3 concrete mitigation options with estimated impact
- No autonomous action - only recommendations

---

