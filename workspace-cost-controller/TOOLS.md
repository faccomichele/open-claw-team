# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics.

## Budget Files (per target project repo)

- Budget config: `/ops/budget.yaml` (CEO owns; read-only for me)
- Cost dashboard: `/ops/costs.md` (I own this)
- Raw cost exports: `/ops/raw-costs/*.json` (populated by external scripts or manual exports)

## GitHub Actions Billing

```bash
# Replace OWNER/REPO with the actual org and repo name, e.g. faccomichele/my-app
gh api /repos/OWNER/REPO/actions/cache/usage

# Replace ORG with the GitHub organisation name, e.g. faccomichele
# Note: org-level billing requires a token with admin:org scope
gh api /orgs/ORG/settings/billing/actions
```

## Alert Thresholds (default from budget.yaml)

- **Healthy:** < 70% used
- **Warning:** 70–90% used → comment on issue
- **Critical:** > 90% used → comment + Telegram alert

## Cost Categories to Track

- `cloud_infra` — AWS/GCP/Azure (read from raw-costs exports)
- `github_actions` — CI/CD minutes (via `gh api`)
- `openclaw_tokens` — LLM API costs (from token logs)

## AWS Cost Explorer

```bash
# Last 30 days, grouped by service
aws ce get-cost-and-usage \
  --time-period Start=$(date -d '-30 days' +%Y-%m-%d),End=$(date +%Y-%m-%d) \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=SERVICE \
  --query 'ResultsByTime[*].Groups[*].{Service:Keys[0],Cost:Metrics.BlendedCost.Amount}' \
  --output table
```

## Status Emoji Convention

- ✅ Healthy (< 70%)
- ⚠️ Warning (70–90%)
- 🚨 Critical (> 90%)

## Notes

Add any project-specific cost patterns, known expensive operations, or billing quirks here.
