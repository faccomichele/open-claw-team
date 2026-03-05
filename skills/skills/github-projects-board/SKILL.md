---
name: github-projects-board
version: 1.0.0
description: Manage GitHub Projects v2 board - view, move cards, update fields
requires:
  binaries: [gh]
  env: [GITHUB_TOKEN]
tools: [exec, read]
author: startup-team
---

# GitHub Projects Board Operations

Manage your GitHub Projects v2 Kanban board for agile workflow.

## Setup

First, get your project number:
gh project list --owner OWNER --format json

## Core Operations

### View project board
gh project item-list PROJECT_NUMBER --owner OWNER --format json --limit 100

### Add issue to project
gh project item-add PROJECT_NUMBER --owner OWNER --url https://github.com/OWNER/REPO/issues/123

### Move card to column
# First get the item ID from item-list, then:
gh project item-edit --id ITEM_ID --project-id PROJECT_ID --field-id STATUS_FIELD_ID --text "In Progress"

### Update custom fields
gh project item-edit --id ITEM_ID --project-id PROJECT_ID --field-id FIELD_ID --text "VALUE"

## Workflow Integration

### Standard columns
- **Backlog**: Tasks not yet started
- **In Progress**: Active work (triggers agent assignment)
- **In Review**: Awaiting QA/Architect review
- **Done**: Completed (human-verified only)

### PM Agent responsibilities
- Move cards from Backlog → In Progress when assigning work
- Ensure `owner:<agent>` labels match the agent working the task
- Update status based on agent reports

### Specialist Agent responsibilities
- **Do not** move your own cards to Done
- Comment on your issue when work is complete and ready for review
- Move to In Review only if you have explicit permission

---

