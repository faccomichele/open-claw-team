---
name: project-planning
version: 1.0.0
description: Read and update project planning documents - roadmap, vision, backlog files
tools: [read, write, edit]
author: faccomichele
---

# Project Planning & Roadmap Management

Maintain the shared planning documents that coordinate all agent work.

## Core Files

### `/docs/vision.md`
High-level mission, constraints, and current top priorities.

**Owned by:** CEO Agent (with input from PM)

**Format:**
# Vision

## Mission
[Core mission statement]

## Current Focus (Q1 2026)
- Priority 1
- Priority 2
- Priority 3

## Constraints
- Budget: $X/month
- Timeline: Launch by [DATE]
- Team size: [N] agents + 1 human CEO

### `/docs/roadmap.md`
Quarterly milestones and epic descriptions.

**Owned by:** PM Agent

**Format:**
# Roadmap

## Q1 2026 (Jan-Mar)
- **Epic 1**: GitHub integration MVP
  - Target: Feb 15
  - Owner: dev-backend
  - Status: in_progress
- **Epic 2**: Cost monitoring dashboard
  - Target: Mar 1
  - Owner: cost-controller
  - Status: planning

## Q2 2026 (Apr-Jun)
[Future epics]

### `/ops/backlog.json`
Structured task list with dependencies.

**Owned by:** PM Agent

**Format:**
[
  {
    "id": "TASK-1",
    "title": "Implement GitHub issue sync",
    "epic": "github-integration",
    "owner": "dev-backend",
    "status": "in_progress",
    "priority": "high",
    "sprint": "2026-03-1",
    "dependsOn": [],
    "githubIssue": 42
  }
]

### `/ops/sprint-board.md`
Current sprint Kanban view.

**Owned by:** PM Agent

**Format:**
# Sprint 2026-03-1 (Mar 3-9)

## Todo
- [ ] TASK-5: Research competitor features

## In Progress
- [x] TASK-1: Implement GitHub issue sync (dev-backend)
- [x] TASK-3: Cost dashboard MVP (cost-controller)

## In Review
- [x] TASK-2: Setup CI pipeline (dev-infra)

## Done
- [x] TASK-0: Bootstrap project structure

## Operations

### PM Agent: Create new task
1. Read `/docs/vision.md` and `/docs/roadmap.md` for context
2. Add entry to `/ops/backlog.json`
3. Create corresponding GitHub issue
4. Update `/ops/sprint-board.md` if task is in current sprint

### PM Agent: Assign task
1. Update `owner` field in `/ops/backlog.json`
2. Add `owner:<agent>` label to GitHub issue
3. Move card to "In Progress" on Projects board
4. Notify specialist agent via session spawn

### Specialist Agent: Complete task
1. Read task from GitHub issue
2. Do the work
3. Update GitHub issue with completion comment
4. **Do not** edit planning files directly - PM will update based on your report

---

