# openclaw.json - Workspace Configuration Format

Each workspace folder may contain an `openclaw.json` file that tells the OpenClaw runtime:
- Which skills to load for this agent
- Which actions are allowed or denied

## Format

```json
{
  "agentId": "<agent-name>",
  "skills": [
    "<skill-name>",
    "..."
  ],
  "actions": {
    "allow": ["<action>", "..."],
    "deny":  ["<action>", "..."]
  },
  "notes": "Human-readable explanation of any non-obvious choices."
}
```

## Available Actions (OpenClaw tool names)

| Action | Description |
|---|---|
| `read` | Read files from disk |
| `write` | Write/create files on disk |
| `exec` | Run shell commands |
| `message` | Send messages via Telegram or other messaging |
| `web_search` | Perform web searches |
| `web_fetch` | Fetch URLs |
| `sessions_spawn` | Spawn a new OpenClaw agent session |
| `sessions_send` | Send a message to an existing session |
| `sessions_list` | List active sessions |
| `sessions_history` | Read session history |
| `session_status` | Query session status |
| `delete_file` | Delete a file |
| `rm` | Remove files via shell |

## Per-Agent Configuration Summary

| Agent | Key Allowed | Key Denied | Rationale |
|---|---|---|---|
| **pm** | `sessions_spawn`, `sessions_send`, `message` | `delete_file`, `rm` | Only PM may delegate sub-sessions |
| **tech-lead** | `exec`, `read`, `write` | `sessions_spawn`, `message` | Reviews only; no delegation, no Telegram |
| **biz-research** | `web_search`, `web_fetch`, `read`, `write` | `sessions_spawn`, `exec`, `message` | Research only; no shell, no delegation, no Telegram |
| **cost-controller** | `exec`, `read`, `write`, `message` | `sessions_spawn`, `delete_file` | Needs Telegram for critical alerts; no spawning |

## Rules

- Only **PM** may use `sessions_spawn` and `sessions_send` (see `coordination/PROTOCOLS.md`).
- Only **CEO** and **Cost Controller** have `message` (Telegram) access — all other agents route through PM.
- `delete_file` and `rm` are denied for all agents by default — data preservation is a priority.
- The `deny` list takes precedence over `allow`.
