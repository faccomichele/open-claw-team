# HEARTBEAT.md

# Add tasks below when you want the agent to check something periodically.

## Periodic Cost Checks

- Collect latest cost data and update /ops/costs.md in the active project repo
- Recalculate spend vs budget; flag any category crossing 70% or 90% threshold
- Check GitHub Actions billing: `gh api /repos/OWNER/REPO/actions/cache/usage`
- If critical threshold hit: send Telegram alert to CEO immediately
- If warning threshold hit: comment on the type:cost GitHub issue
