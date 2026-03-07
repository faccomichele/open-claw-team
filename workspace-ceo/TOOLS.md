# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — configuration unique to your setup.

## Active Skills

| Skill | Purpose |
|---|---|
| `agent-coordination` | Spawn PM sessions; monitor all active agent sessions |
| `telegram-notifications` | Primary communication channel with the human |
| `project-planning` | Read/update roadmap, backlog, and strategic objectives |
| `github-issue-ops` | Monitor delivery status and sprint health |
| `github-read-access` | Read-only GitHub browsing and repo cloning for configuration inspection |

## Telegram

- Bot token and chat IDs are stored in the OpenClaw keychain — do not hardcode them here.
- All human-facing messages go via Telegram. No other external channel.

## Session Management

- You spawn **PM** (`agentId: pm`) as your primary sub-session for operational work.
- PM spawns all specialists. You do not spawn specialists directly.
- Check session health via `sessions_list` if PM goes silent for >1h.

## What Goes Here

Add any environment-specific notes as you go:

- Project repo URLs you reference frequently
- Telegram bot IDs or group chat names (non-secret identifiers only)
- Any shortcuts or aliases that help you work faster

---

Keep secrets out of this file. Credentials live in the keychain.
