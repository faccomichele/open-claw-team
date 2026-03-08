---
name: digitalocean-cli
version: 1.0.0
description: DigitalOcean CLI (doctl) and REST API operations — DNS records, Droplets, Databases, Spaces, and billing inspection
requires:
  binaries: [doctl, curl]
  config:
    - DIGITALOCEAN_ACCESS_TOKEN must be set (or `doctl auth init` completed)
    - Run `doctl auth init` once with a Personal Access Token that has the required scopes
    - For REST API calls: export DO_TOKEN=<your-personal-access-token>
tools: [exec, read]
author: faccomichele
---

# DigitalOcean CLI

Interact with DigitalOcean via `doctl` (the official CLI) and the REST API (`https://api.digitalocean.com/v2/`). Use `doctl help` or `doctl <command> --help` to discover subcommands you are unsure about.

---

## Authentication

```bash
# Interactive auth setup (stores token in ~/.config/doctl/config.yaml)
doctl auth init

# Switch between named auth contexts
doctl auth switch --context CONTEXT_NAME

# Verify active context and token
doctl account get
```

For REST API calls via `curl`, export your token:

```bash
export DO_TOKEN="your-personal-access-token"
```

---

## DNS Records

DNS management is under `doctl compute domain`. Each domain maps to a zone; records live inside a domain.

### List all managed domains

```bash
doctl compute domain list
```

### Create a new domain (delegates NS to DigitalOcean)

```bash
doctl compute domain create example.com --ip-address 1.2.3.4
```

### Delete a domain

```bash
doctl compute domain delete example.com
```

---

### List all DNS records for a domain

```bash
doctl compute domain records list example.com \
  --format ID,Type,Name,Data,TTL
```

### Create a DNS record

```bash
# A record
doctl compute domain records create example.com \
  --record-type A \
  --record-name www \
  --record-data 1.2.3.4 \
  --record-ttl 3600

# CNAME record
doctl compute domain records create example.com \
  --record-type CNAME \
  --record-name blog \
  --record-data example.com. \
  --record-ttl 3600

# MX record
doctl compute domain records create example.com \
  --record-type MX \
  --record-name @ \
  --record-data mail.example.com. \
  --record-priority 10 \
  --record-ttl 3600

# TXT record (e.g. SPF, DKIM, domain verification)
doctl compute domain records create example.com \
  --record-type TXT \
  --record-name @ \
  --record-data "v=spf1 include:sendgrid.net ~all" \
  --record-ttl 3600
```

### Update a DNS record

```bash
# Get the record ID first
doctl compute domain records list example.com --format ID,Type,Name,Data

# Update the record
doctl compute domain records update example.com \
  --record-id RECORD_ID \
  --record-data 5.6.7.8 \
  --record-ttl 1800
```

### Delete a DNS record

```bash
doctl compute domain records delete example.com RECORD_ID
```

### REST API equivalents (DNS)

```bash
# List all domains
curl -s -X GET "https://api.digitalocean.com/v2/domains" \
  -H "Authorization: Bearer $DO_TOKEN" | jq '.domains[]'

# List records for a domain
curl -s -X GET "https://api.digitalocean.com/v2/domains/example.com/records" \
  -H "Authorization: Bearer $DO_TOKEN" | jq '.domain_records[]'

# Create an A record
curl -s -X POST "https://api.digitalocean.com/v2/domains/example.com/records" \
  -H "Authorization: Bearer $DO_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"type":"A","name":"www","data":"1.2.3.4","ttl":3600}' | jq '.domain_record'

# Update a record (full replacement)
curl -s -X PUT "https://api.digitalocean.com/v2/domains/example.com/records/RECORD_ID" \
  -H "Authorization: Bearer $DO_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"type":"A","name":"www","data":"5.6.7.8","ttl":1800}' | jq '.domain_record'

# Delete a record
curl -s -X DELETE "https://api.digitalocean.com/v2/domains/example.com/records/RECORD_ID" \
  -H "Authorization: Bearer $DO_TOKEN" -o /dev/null -w "%{http_code}"
```

---

## Droplets (Compute)

```bash
# List all Droplets with key fields
doctl compute droplet list \
  --format ID,Name,Status,Region,Size,PublicIPv4

# Get details of a specific Droplet
doctl compute droplet get DROPLET_ID

# Create a Droplet (read terraform skill for IaC approach — prefer that)
doctl compute droplet create my-server \
  --region nyc3 \
  --size s-1vcpu-1gb \
  --image ubuntu-22-04-x64 \
  --ssh-keys KEY_ID \
  --tag-names "env:dev,repo:owner/repo,managed-by:doctl"

# Delete a Droplet
doctl compute droplet delete DROPLET_ID
```

---

## Managed Databases

```bash
# List all database clusters
doctl databases list \
  --format ID,Name,Engine,Version,Region,Status

# Get connection details for a cluster
doctl databases connection CLUSTER_ID

# List databases within a cluster
doctl databases db list CLUSTER_ID

# List database users
doctl databases user list CLUSTER_ID

# Get firewall (trusted sources)
doctl databases firewalls list CLUSTER_ID

# Add a firewall rule (allow a Droplet)
doctl databases firewalls append CLUSTER_ID \
  --rule droplet:DROPLET_ID
```

---

## Spaces (Object Storage)

DigitalOcean Spaces is S3-compatible. Use the `doctl` spaces subcommand or the AWS CLI with a custom endpoint.

```bash
# List Spaces buckets
doctl spaces list

# Using AWS CLI with Spaces endpoint (set AWS_ACCESS_KEY_ID/SECRET to Spaces keys)
aws s3 ls --endpoint-url https://nyc3.digitaloceanspaces.com

# Upload a file
aws s3 cp ./file.txt s3://my-space/file.txt \
  --endpoint-url https://nyc3.digitaloceanspaces.com
```

---

## Kubernetes (DOKS)

```bash
# List Kubernetes clusters
doctl kubernetes cluster list \
  --format ID,Name,Region,Status,NodePools

# Save kubeconfig for a cluster
doctl kubernetes cluster kubeconfig save CLUSTER_ID

# List node pools
doctl kubernetes cluster node-pool list CLUSTER_ID
```

---

## Account & Billing (read-only)

```bash
# Account summary
doctl account get

# Billing history
doctl invoice list

# Get details of a specific invoice
doctl invoice get INVOICE_UUID

# REST API: account balance
curl -s -X GET "https://api.digitalocean.com/v2/customers/my/balance" \
  -H "Authorization: Bearer $DO_TOKEN" | jq '.'

# REST API: billing history (current month)
curl -s -X GET "https://api.digitalocean.com/v2/customers/my/billing_history" \
  -H "Authorization: Bearer $DO_TOKEN" | jq '.billing_history[]'
```

---

## Firewall Rules

```bash
# List all Cloud Firewalls
doctl compute firewall list \
  --format ID,Name,Status,DropletIDs

# Get rules for a specific firewall
doctl compute firewall get FIREWALL_ID

# Add an inbound rule
doctl compute firewall add-rules FIREWALL_ID \
  --inbound-rules "protocol:tcp,ports:443,sources:addresses:0.0.0.0/0,::/0"

# Remove a Droplet from a firewall
doctl compute firewall remove-droplets FIREWALL_ID \
  --droplet-ids DROPLET_ID
```

---

## Load Balancers

```bash
# List load balancers
doctl compute load-balancer list \
  --format ID,Name,IP,Region,Status

# Get details
doctl compute load-balancer get LB_ID
```

---

## General Inspection

```bash
# List available regions
doctl compute region list

# List available Droplet sizes (with pricing)
doctl compute size list

# List available images (distributions)
doctl compute image list --public --format Slug,Distribution,Name | grep ubuntu

# List your SSH keys
doctl compute ssh-key list --format ID,Name,FingerPrint
```

---

## Best Practices

- **Use `doctl <command> --help`** before guessing flags — it has complete documentation
- **Prefer IaC (Terraform)** for creating/modifying infrastructure; use `doctl` only for inspection and one-off DNS operations
- **Read-only by default** — use `list`, `get` commands; only use `create`, `update`, `delete` when explicitly instructed
- **Never hardcode tokens** — keep `DIGITALOCEAN_ACCESS_TOKEN` in the environment or use `doctl auth init`; do not commit tokens to files
- **Always use `--format`** on list commands to get clean, parsable output; combine with `jq` for REST API responses
- **Paginate large lists** with `--page` and `--per-page` (REST API uses `?page=N&per_page=100`)
- **Tag Droplets** with `repo`, `env` (`DEV`/`PROD`), and `managed-by` per team infrastructure policy

---
