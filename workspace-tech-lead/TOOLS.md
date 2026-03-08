# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics.

## GitHub

- Default org/owner: (set from project context — check PR/issue URL)
- PR review states: `APPROVE`, `REQUEST_CHANGES`, `COMMENT`
- Architecture decision labels: `type:architecture`, `type:tech-debt`, `type:spike`

## Copilot Agent Definitions

- Source of truth: `github_copilot_agents/` in this repo
- Deployed to: `.github/copilot/agents/` in each target project repo
- Changes require: update source file here → copy to target repo → document in issue/PR comment

## Code Standards Location

- Per project repo: `/docs/coding-standards.md`
- Check this file exists and is current before each PR review cycle

## CI Monitoring

```bash
# Replace OWNER/REPO with the actual org and repo name, e.g. faccomichele/my-app
gh run list --repo OWNER/REPO --limit 20 --json databaseId,conclusion,status,workflowName,headBranch
```

- A workflow failing 3+ consecutive runs = systemic issue, raise to PM

## AWS / Infrastructure

- IaC files live under `infra/` or `terraform/` in each target project repo
- Always use `terraform plan` and attach output to the relevant PR before applying
- CloudFormation stacks: use `aws cloudformation describe-stacks` to inspect deployed state
- Tag all resources: `repo`, `env` (`DEV`/`PROD`), `managed-by` (`terraform`)

## DigitalOcean / Infrastructure

- Token stored in OpenClaw keychain — run `doctl auth init` once to configure; never hardcode tokens
- DNS records: `doctl compute domain records list DOMAIN` and `doctl compute domain records create/update/delete`
- Prefer IaC (Terraform with `digitalocean` provider) for persistent resources; use `doctl` for DNS one-offs and inspection
- Tag all Droplets with `repo`, `env`, and `managed-by` per team policy

## Notes

Add any project-specific architectural patterns, preferred libraries, or technical conventions here.
