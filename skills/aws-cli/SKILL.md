---
name: aws-cli
version: 1.0.0
description: AWS CLI operations focused on CloudFormation stack management, plus `aws help` for command discovery
requires:
  binaries: [aws]
  config:
    - AWS_PROFILE or AWS_ACCESS_KEY_ID + AWS_SECRET_ACCESS_KEY must be configured
    - AWS_DEFAULT_REGION should be set (or pass --region on every call)
tools: [exec, read]
author: faccomichele
---

# AWS CLI

Interact with AWS services via the `aws` CLI. This skill is focused on **CloudFormation stack operations** and general infrastructure inspection. Use `aws help` to discover commands you are unsure about without guessing.

## Discovering Commands with `aws help`

When unsure of a command or flag, always consult the built-in help first:

```
# Top-level service list
aws help

# All commands for a service
aws cloudformation help

# Detailed help for a specific command (includes all flags and examples)
aws cloudformation describe-stacks help
aws cloudformation list-stack-resources help
```

The help output is authoritative — prefer it over guessing flag names.

---

## CloudFormation Stack Operations

### List all stacks

```
aws cloudformation list-stacks \
  --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE ROLLBACK_COMPLETE \
  --query 'StackSummaries[*].{Name:StackName,Status:StackStatus,Updated:LastUpdatedTime}' \
  --output table
```

### Describe a stack (config, outputs, parameters)

```
aws cloudformation describe-stacks \
  --stack-name STACK_NAME \
  --query 'Stacks[0].{Status:StackStatus,Outputs:Outputs,Parameters:Parameters,Tags:Tags}' \
  --output json
```

### List all resources in a stack

```
aws cloudformation list-stack-resources \
  --stack-name STACK_NAME \
  --query 'StackResourceSummaries[*].{LogicalId:LogicalResourceId,PhysicalId:PhysicalResourceId,Type:ResourceType,Status:ResourceStatus}' \
  --output table
```

### View stack events (useful for diagnosing failures)

```
aws cloudformation describe-stack-events \
  --stack-name STACK_NAME \
  --query 'StackEvents[*].{Time:Timestamp,Resource:LogicalResourceId,Status:ResourceStatus,Reason:ResourceStatusReason}' \
  --output table
```

### Get the deployed template for a stack

```
aws cloudformation get-template \
  --stack-name STACK_NAME \
  --query TemplateBody \
  --output json
```

### Validate a CloudFormation template before deploying

```
aws cloudformation validate-template \
  --template-body file://path/to/template.yaml
```

### Detect stack drift (configuration drift from declared state)

```
# Start drift detection
aws cloudformation detect-stack-drift --stack-name STACK_NAME

# Check detection status (use the DetectionId returned above)
aws cloudformation describe-stack-drift-detection-status \
  --stack-drift-detection-id DETECTION_ID

# View drifted resources
aws cloudformation describe-stack-resource-drifts \
  --stack-name STACK_NAME \
  --stack-resource-drift-status-filters MODIFIED DELETED
```

---

## General Infrastructure Inspection

### List S3 buckets

```
aws s3 ls
```

### List EC2 instances with their state and tags

```
aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].{ID:InstanceId,State:State.Name,Type:InstanceType,Name:Tags[?Key==`Name`].Value|[0]}' \
  --output table
```

### List Lambda functions

```
aws lambda list-functions \
  --query 'Functions[*].{Name:FunctionName,Runtime:Runtime,LastModified:LastModified}' \
  --output table
```

### List RDS instances

```
aws rds describe-db-instances \
  --query 'DBInstances[*].{ID:DBInstanceIdentifier,Engine:Engine,Status:DBInstanceStatus,Endpoint:Endpoint.Address}' \
  --output table
```

### Query Cost Explorer (last 30 days, grouped by service)

```
aws ce get-cost-and-usage \
  --time-period Start=$(date -d '-30 days' +%Y-%m-%d),End=$(date +%Y-%m-%d) \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=SERVICE \
  --query 'ResultsByTime[*].Groups[*].{Service:Keys[0],Cost:Metrics.BlendedCost.Amount}' \
  --output table
```

---

## Best Practices

- **Use `--query` and `--output json|table`** — never parse unstructured text output
- **Use `aws <service> <command> help`** before guessing a flag; the CLI has exhaustive built-in documentation
- **Prefer `--profile`** over hardcoded credentials; set `AWS_PROFILE` in the environment
- **Always pass `--region`** (or set `AWS_DEFAULT_REGION`) — never rely on implicit defaults
- **Read-only by default** — use `describe-*`, `list-*`, `get-*` commands; escalate to `deploy` / `create-change-set` only when explicitly instructed
- **Tag every resource** you create with `repo`, `env`, and `managed-by` tags per the team infrastructure policy

---
