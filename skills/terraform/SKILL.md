---
name: terraform
version: 1.0.0
description: Terraform workflow for provisioning, inspecting, and managing infrastructure as code
requires:
  binaries: [terraform]
  config:
    - Cloud provider credentials must be configured (e.g. AWS_PROFILE, GOOGLE_CREDENTIALS)
    - Backend configuration (S3/GCS/Terraform Cloud) must exist in the repo's infra/ directory
tools: [exec, read, write]
author: faccomichele
---

# Terraform

Manage infrastructure as code with Terraform. All IaC files live under `infra/` (or `terraform/`) in the target project repo. Always use workspaces or variable files to separate `DEV` and `PROD` environments.

## Core Workflow

### 1. Initialise (always run first in a new clone or after provider changes)

```
cd infra/
terraform init
```

For a specific backend config:

```
terraform init -backend-config=envs/prod/backend.hcl
```

### 2. Select or create a workspace

```
# List available workspaces
terraform workspace list

# Switch to an existing workspace
terraform workspace select prod

# Create a new workspace
terraform workspace new staging
```

### 3. Validate configuration syntax

```
terraform validate
```

### 4. Format check (lint)

```
terraform fmt -check -recursive
# Auto-fix formatting issues
terraform fmt -recursive
```

### 5. Plan — preview changes without applying

```
# Against a var file
terraform plan -var-file=envs/prod/terraform.tfvars -out=tfplan

# View the saved plan in human-readable form
terraform show tfplan
```

> **Always generate a plan and review it before applying.** Share the plan output with the relevant stakeholder (via Telegram or PR comment) before proceeding.

### 6. Apply — provision or update infrastructure

```
# Apply a previously saved plan (safest approach)
terraform apply tfplan

# Apply with auto-approval (only for non-production or explicitly approved changes)
terraform apply -auto-approve -var-file=envs/dev/terraform.tfvars
```

> **Never use `-auto-approve` on `prod` workspace** without explicit human approval.

### 7. Destroy — tear down infrastructure

```
terraform destroy -var-file=envs/dev/terraform.tfvars
```

> **Always require explicit human sign-off before running destroy on any environment.**

---

## State Management

### List resources in state

```
terraform state list
```

### Inspect a specific resource's state

```
terraform state show aws_instance.web_server
```

### Pull current remote state (read-only inspection)

```
terraform state pull | jq '.resources[] | {type: .type, name: .name}'
```

### Move a resource to a new address (rename refactor)

```
terraform state mv aws_instance.old_name aws_instance.new_name
```

### Import an existing resource into state

```
terraform import aws_s3_bucket.my_bucket my-bucket-name
```

---

## Outputs & Values

### Show all outputs for the current workspace

```
terraform output
terraform output -json
```

### Show a specific output value

```
terraform output database_endpoint
```

---

## Debugging & Troubleshooting

### Enable verbose logging

```
TF_LOG=DEBUG terraform plan -var-file=envs/prod/terraform.tfvars 2>&1 | tee tf-debug.log
```

### Graph the resource dependency tree

```
terraform graph | dot -Tsvg > tf-graph.svg
```

### Refresh state from live infrastructure (without making changes)

```
terraform refresh -var-file=envs/prod/terraform.tfvars
```

---

## Best Practices

- **IaC only** — never create cloud resources via console or CLI; everything must be in Terraform and committed to `infra/`
- **Workspaces = environments** — use `dev`, `staging`, `prod` workspaces (or separate state files) to isolate environments; never reuse state across environments
- **Always tag resources** — include `repo`, `env`, and `managed-by = "terraform"` tags on every resource per team policy
- **Plan before apply** — always run `terraform plan` and attach the output to the relevant issue or PR before applying
- **Store state remotely** — use an S3 backend (with DynamoDB locking) or Terraform Cloud; never commit `.tfstate` files
- **Pin provider versions** — specify `required_providers` with exact or constrained versions to prevent unexpected upgrades
- **Never commit secrets** — use `sensitive = true` for outputs containing credentials; inject secrets via environment variables or a secrets manager

---
