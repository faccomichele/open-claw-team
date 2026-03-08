# HEARTBEAT.md

# CEO heartbeat checklist — keep this lean to limit token burn.
# Add or remove items as needed.

## Checks (rotate, 2–3× per day)

- [ ] **Sprint status** — Check `coordination/SPRINT.md`; if PM session is active, send a status request via `sessions_send`
- [ ] **PM session alive** — Run `sessions_list` to verify PM persistent session is still running; re-spawn if not (with current sprint context from `coordination/SPRINT.md`)
- [ ] **Budget alerts** — Any signal from Cost Controller requiring a decision?
- [ ] **PM escalations** — Any blockers raised but unresolved >24h?
- [ ] **Telegram inbox** — Any unread messages from the human needing a strategic call?

If none of the above require action: reply `HEARTBEAT_OK`.
