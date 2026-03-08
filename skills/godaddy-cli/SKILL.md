---
name: godaddy-cli
version: 1.0.0
description: GoDaddy domain and DNS management via the pre-installed `godaddy` CLI — list domains, search availability, and inspect or modify DNS records
requires:
  binaries: [godaddy]
  config:
    - GoDaddy API credentials must exist at $HOME/.config/godaddy/credentials.json
    - Obtain keys at https://developer.godaddy.com/keys
tools: [exec, read, write]
author: faccomichele
---

# GoDaddy CLI

Manage GoDaddy domains and DNS records using the pre-installed `godaddy` CLI.  
The binary is available globally — no installation step is needed.

## Credentials Setup

The CLI reads credentials from `$HOME/.config/godaddy/credentials.json`. Create this file once with your production or OTE API key and secret:

```json
{
  "key": "YOUR_GODADDY_API_KEY",
  "secret": "YOUR_GODADDY_API_SECRET"
}
```

Obtain keys from the GoDaddy Developer Portal: <https://developer.godaddy.com/keys>

> **Never commit this file to source control.** It contains secret credentials.

---

## Read Operations

The commands below are safe to run at any time — they make no changes to your domains or DNS.

### List all domains in the account

```
godaddy domains list
```

Example output:
```
awesomedomain.com
anotherone.org
```

### Search domain availability and pricing

```
godaddy domains search DOMAIN
```

Example:
```
godaddy domains search example.com
# Domain       Available Price     Period
# example.com  true      11.99 USD 1 year(s)
```

### List DNS records for a domain

```
godaddy records list --domain DOMAIN
```

Example:
```
godaddy records list --domain example.com
# A    	 600	             @	134.233.0.41
# NS   	3600	             @	ns23.domaincontrol.com
# CNAME	3600	           www	@
```

---

## Write Operations

> ⚠️ **Write operations modify live DNS.** Always confirm the intent before running these commands. DNS changes can take up to 48 hours to propagate globally. Mistakes may cause downtime.

### Add a DNS record

Supported types: `A`, `AAAA`, `CNAME`, `MX`, `TXT`  
Defaults: `--type A`, `--ttl 600`  
MX records require `--priority`.

```
godaddy records add --domain DOMAIN --type TYPE --name NAME --value VALUE --ttl TTL
```

Examples:
```
# Add an A record
godaddy records add --domain example.com --type A --name app --value 1.2.3.4 --ttl 600

# Add a CNAME record
godaddy records add --domain example.com --type CNAME --name www --value @ --ttl 3600

# Add a TXT record (e.g. for site ownership verification)
godaddy records add --domain example.com --type txt --name _verify --value "verification-token-12345" --ttl 600

# Add an MX record
godaddy records add --domain example.com --type MX --name @ --value mail.example.com --priority 10 --ttl 3600
```

### Remove a DNS record

Provide domain, type, and name — the CLI identifies the record from these three fields.

```
godaddy records remove --domain DOMAIN --type TYPE --name NAME
```

Example:
```
godaddy records remove --domain example.com --type txt --name _verify
```

---

## Best Practices

- **Read before write** — always run `godaddy records list --domain DOMAIN` to inspect the current state before adding or removing records
- **One change at a time** — make one DNS change, verify it is correct, then proceed to the next; batch changes increase the blast radius of mistakes
- **Announce changes** — post a message (via `telegram-notifications` or a GitHub issue comment) describing the DNS change before and after you make it, so the team has an audit trail
- **Read-only by default** — only agents with an explicit write mandate should run `records add` or `records remove`; all other agents should limit themselves to `domains list`, `domains search`, and `records list`
- **Never modify NS records** — nameserver records control DNS delegation; changing them will take a domain offline; treat them as immutable unless there is an explicit infrastructure migration plan approved by the Tech Lead and the human

---
