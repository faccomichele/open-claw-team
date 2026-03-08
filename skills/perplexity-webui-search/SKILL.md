---
name: perplexity-webui-search
description: Perform web searches via Perplexity WebUI using Playwright automation. Extract answers, sources, and citations for research tasks.
version: 1.2.0
author: Michele Facco
requires:
  bins:
    - npx
  environment:
    - PERPLEXITY_EMAIL
    - PERPLEXITY_PASSWORD
metadata:
  openclaw:
    triggers:
      - web search
      - online research
      - current information
      - perplexity query
    cost: Free with Pro subscription
    latency: 5-15s per query
---

## When to Use This Skill

Use this skill when you need to:

- Search for current, real-time information not in your training data
- Retrieve cited sources and references for factual claims
- Compare multiple perspectives on recent events or topics
- Access Perplexity Pro's unlimited searches without API costs
- Extract structured data from Perplexity's search results

**Do NOT use for:**
- Questions answerable from your existing knowledge
- Queries requiring sub-second response times (use Perplexity API instead)
- Bulk automation (rate limits apply to Pro accounts)

## Prerequisites

### Environment Variables

Set these in your OpenClaw environment or `.env` file:

```bash
export PERPLEXITY_EMAIL="your-email@example.com"
export PERPLEXITY_PASSWORD="your-password"
```

### Playwright MCP Setup

This skill drives the browser through the official **`@playwright/mcp`** package. Install it directly — no third-party skill wrapper needed:

```bash
# Install Playwright MCP server
npm install -g @playwright/mcp@latest

# Install Chromium browser
npx playwright install chromium
```

Then add the MCP server to your OpenClaw (or Claude Desktop) config:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest", "--browser", "chromium"]
    }
  }
}
```

Verify the server starts correctly:

```bash
npx @playwright/mcp@latest --help
```

## MCP Playwright Tool Reference

This skill uses the standard Playwright MCP tool set. Key rules:

- **Always call `browser_snapshot()`** before interacting with elements — it returns the accessibility tree with `ref` identifiers for every interactive node.
- **Use `ref` from the snapshot**, not CSS selectors, when calling `browser_type`, `browser_click`, or `browser_evaluate` on a specific element.
- **`browser_press_key({ key })`** sends a global keypress (no element target needed).
- **`browser_evaluate({ function: "() => { ... }" })`** runs JavaScript in the page context; the parameter is `function`, not `script`.
- **`browser_wait_for({ text, time })`** waits for text to appear or for a fixed duration.
- **`browser_file_upload({ paths })`** uploads local files after a file-chooser is triggered.

### How to Use Refs from Snapshots

`browser_snapshot()` returns an accessibility tree. Locate the element you need by scanning its `name`, `role`, or descriptive text, then pass its `ref` to the interaction tool. Example:

```
// Snapshot output (abbreviated):
// - role: textbox  name: "Ask anything..."  ref: "e123"
// - role: button   name: "Sign in"          ref: "e45"

// Use the ref directly:
await browser_type({ element: "Ask anything search input", ref: "e123", text: query });
await browser_click({ element: "Sign in button", ref: "e45" });
```

All `ref` values in the code examples below are illustrative placeholders — replace them with the actual values returned by `browser_snapshot()` at runtime.

## Core Instructions

### Search Workflow

When the user requests information that requires web search, follow this sequence:

#### Step 1: Navigate to Perplexity

```js
// Navigate — no waitUntil parameter in MCP standard
await browser_navigate({ url: "https://www.perplexity.ai" });
```

#### Step 2: Check Authentication State

```js
// Take accessibility snapshot to inspect page state
const snapshot = await browser_snapshot();

// Detect unauthenticated state: look for a "Sign in" or "Log in" button in the tree.
// The snapshot text representation includes node names — check for these strings:
const isLoggedOut = snapshot.toString().includes("Sign in") || snapshot.toString().includes("Log in");

if (isLoggedOut) {
  await authenticatePerplexity(snapshot);
}
```

#### Step 3: Submit Query

```js
// Take a fresh snapshot to get the search textarea ref
const snapshot = await browser_snapshot();
// Identify the search textarea node in snapshot (ref is assigned by the accessibility tree)

await browser_type({
  element: "search input – Ask anything",  // human-readable description
  ref: "<ref from snapshot>",              // ref returned by browser_snapshot
  text: userQuery
});

// Submit with Enter key (global keypress — no element ref needed)
await browser_press_key({ key: "Enter" });
```

#### Step 4: Wait for Response

```js
// Wait until the "Stop generating" button disappears, indicating completion
await browser_wait_for({ textGone: "Stop generating" });

// Fallback: poll via browser_evaluate if browser_wait_for is insufficient
await browser_evaluate({
  function: `() => new Promise((resolve, reject) => {
    const timeout = setTimeout(() => reject(new Error('Response timeout')), 30000);
    const check = () => {
      const stopBtn = document.querySelector('[aria-label="Stop generating"]');
      if (!stopBtn || stopBtn.disabled) { clearTimeout(timeout); resolve(true); }
      else setTimeout(check, 500);
    };
    check();
  })`
});
```

#### Step 5: Extract Results

```js
// Extract answer text via browser_evaluate (no browser_get_text in MCP standard)
const answer = await browser_evaluate({
  function: `() => {
    const el = document.querySelector('[class*="answer"], [data-testid="answer"]');
    return el ? el.innerText.trim() : "";
  }`
});

// Extract citations
const sources = await browser_evaluate({
  function: `() => Array.from(document.querySelectorAll('[data-testid="citation-link"]'))
    .map(link => ({
      title: link.textContent.trim(),
      url: link.href,
      number: link.getAttribute('data-citation-number')
    }))`
});
```

### Authentication Helper

```js
async function authenticatePerplexity(snapshot) {
  // Click the "Sign in" button — use ref from snapshot
  await browser_click({
    element: "Sign in button",
    ref: "<ref from snapshot>"
  });

  // Take new snapshot after the modal/form appears
  const loginSnapshot = await browser_snapshot();

  // Fill email
  await browser_type({
    element: "email input",
    ref: "<ref from loginSnapshot>",
    text: process.env.PERPLEXITY_EMAIL
  });

  // Click Continue
  await browser_click({
    element: "Continue button",
    ref: "<ref from loginSnapshot>"
  });

  // Take snapshot again for the password screen
  const pwSnapshot = await browser_snapshot();

  // Fill password
  await browser_type({
    element: "password input",
    ref: "<ref from pwSnapshot>",
    text: process.env.PERPLEXITY_PASSWORD
  });

  // Submit with Enter (global keypress)
  await browser_press_key({ key: "Enter" });

  // Wait for home page to load
  await browser_wait_for({ text: "Ask anything" });
}
```

## Response Format

Structure your responses with:

1. **Direct Answer**: Summarize Perplexity's response in 2-3 sentences
2. **Key Points**: Bullet list of main findings
3. **Sources**: Numbered citations with titles and URLs
4. **Follow-up**: Suggest related queries if relevant

### Example Output

**Answer**: Renewable energy capacity grew 25% globally in 2025, with solar installations leading at 40% of new capacity. Wind power contributed 35%, while hydroelectric and other sources made up the remainder[1][2].

**Key Findings**:
- Solar installations reached 450 GW in 2025, up from 360 GW in 2024[1]
- Offshore wind projects doubled in Europe and Asia[2]
- Battery storage deployments increased 60% to support intermittent sources[3]
- Cost per MWh for solar dropped below coal in 80% of global markets[1]

**Sources**:
[1] IEA World Energy Outlook 2025 - https://www.iea.org/reports/weo-2025
[2] Global Wind Energy Council Annual Report - https://gwec.net/annual-2025
[3] BloombergNEF Energy Storage Report - https://about.bnef.com/storage-2025

**Related Queries**: Would you like to explore regional breakdowns, policy impacts, or future projections?

## Advanced Features

### Focus Mode Selection

Perplexity offers different search modes. Select before querying:

```js
// Take snapshot to locate the Focus mode control
const snapshot = await browser_snapshot();

// Click the Focus mode dropdown
await browser_click({
  element: "Focus mode dropdown",
  ref: "<ref from snapshot>"
});

// Take new snapshot after dropdown opens, then click desired mode
const dropdownSnapshot = await browser_snapshot();
await browser_click({
  element: "Academic mode option",  // or All, Writing, Wolfram, YouTube, Reddit
  ref: "<ref from dropdownSnapshot>"
});
```

### Pro Search Toggle

Enable Pro Search for complex queries:

```js
const snapshot = await browser_snapshot();
// The Pro Search toggle appears in the accessibility tree as a button/checkbox
// whose name contains "Pro Search". Scan snapshot nodes for this name to get its ref,
// then click it.
// Example (ref value will differ each page load — always read from the live snapshot):
//   Snapshot node: role: checkbox  name: "Pro Search"  ref: "e99"
await browser_click({
  element: "Pro Search toggle",
  ref: "<ref for Pro Search node from snapshot>"
});
```

### Image Analysis

If the user provides a local image for visual search:

```js
// Click the image/attach button (get ref from snapshot first)
const snapshot = await browser_snapshot();
await browser_click({
  element: "Attach image button",
  ref: "<ref from snapshot>"
});

// The file chooser dialog opens — upload file(s)
await browser_file_upload({ paths: ["/absolute/path/to/image.png"] });
```

## Error Handling

### Common Failure Modes

| Error | Cause | Solution |
|-------|-------|----------|
| Login failure | Wrong credentials | Verify `PERPLEXITY_EMAIL` / `PERPLEXITY_PASSWORD` |
| Timeout | Slow response | Increase poll timeout to 60 s |
| Rate limit | Too many queries | Wait 60 s between queries |
| Ref not found | UI changed | Call `browser_snapshot()` and inspect the updated tree |

### Retry Logic

```js
async function searchWithRetry(query, maxRetries = 3) {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await performSearch(query);
    } catch (error) {
      if (attempt === maxRetries) throw error;
      await browser_wait_for({ time: attempt * 2 });
      // Reset to home page before retrying
      await browser_navigate({ url: "https://www.perplexity.ai" });
    }
  }
}
```

## Performance Optimization

### Session Persistence

Playwright MCP maintains browser context between queries. Leverage this:

- First query: Full authentication flow (10-15 s)
- Subsequent queries: Skip auth, direct search (5-8 s)
- Session expires: Re-authenticate automatically

### Parallel Queries

For multiple searches, use sequential execution (Perplexity limits concurrent sessions):

```js
// WRONG: Parallel execution
const results = await Promise.all(queries.map(q => search(q)));

// CORRECT: Sequential with rate limiting
const results = [];
for (const query of queries) {
  results.push(await search(query));
  await browser_wait_for({ time: 2 });  // 2 s between queries
}
```

## Integration Example

### Full Search Function

```js
async function perplexitySearch(query, options = {}) {
  const { focusMode = "All", proSearch = false } = options;

  // Navigate to Perplexity
  await browser_navigate({ url: "https://www.perplexity.ai" });

  // Check and handle authentication
  let snapshot = await browser_snapshot();
  const snapshotText = snapshot.toString();
  if (snapshotText.includes("Sign in") || snapshotText.includes("Log in")) {
    await authenticatePerplexity(snapshot);
    snapshot = await browser_snapshot();
  }

  // Configure focus mode if requested
  if (focusMode !== "All") {
    await browser_click({ element: "Focus mode dropdown", ref: "<ref from snapshot>" });
    const dropdownSnapshot = await browser_snapshot();
    await browser_click({ element: `${focusMode} option`, ref: "<ref from dropdownSnapshot>" });
    snapshot = await browser_snapshot();
  }

  // Enable Pro Search if requested — find the toggle in the snapshot by its name
  if (proSearch) {
    // The Pro Search toggle typically appears as a button/checkbox named "Pro Search" in the tree
    // After snapshot, iterate nodes to find the ref, then click it
    const proToggleRef = /* parse snapshot for node with name "Pro Search" */;
    if (proToggleRef) await browser_click({ element: "Pro Search toggle", ref: proToggleRef });
    snapshot = await browser_snapshot();
  }

  // Submit query
  await browser_type({
    element: "search input",
    ref: "<ref from snapshot>",
    text: query
  });
  await browser_press_key({ key: "Enter" });

  // Wait for completion
  await browser_wait_for({ textGone: "Stop generating" });

  // Extract answer
  const answer = await browser_evaluate({
    function: `() => {
      const el = document.querySelector('[class*="answer"], [data-testid="answer"]');
      return el ? el.innerText.trim() : "";
    }`
  });

  // Extract citations
  const sources = await browser_evaluate({
    function: `() => Array.from(document.querySelectorAll('[data-testid="citation-link"]'))
      .map(link => ({
        title: link.textContent.trim(),
        url: link.href,
        citation: link.getAttribute('data-citation-number')
      }))`
  });

  return { query, answer, sources, focusMode, proSearch, timestamp: new Date().toISOString() };
}
```

## Usage Guidelines

### Cost Management

- Pro subscription: $20/month for unlimited searches
- No per-query API costs
- Browser overhead: ~100-200 MB RAM per session
- Typical query: 5-15 seconds end-to-end

### When to Prefer API Over WebUI

Use Perplexity's Search API instead if:

- You need sub-5-second responses
- Running bulk/batch queries (>50/day)
- Building production services
- Require structured JSON responses
- Need programmatic reliability guarantees

Use this WebUI skill if:

- You have a Pro subscription (unlimited free queries)
- Running 5-20 queries per day
- Need Pro Search features (deep research mode)
- Want to avoid API credit costs during prototyping
- Comfortable with 10-15 s latency

## Troubleshooting

### Browser Context Issues

If Playwright MCP loses browser state:

```bash
# Reinstall Chromium for the official package
npx playwright install chromium

# Or clear cached browser data
rm -rf ~/Library/Application\ Support/ms-playwright/
npx playwright install chromium
```

### Element Not Found

Perplexity updates its UI regularly. If a `ref` lookup fails:

1. Call `browser_snapshot()` to get the current accessibility tree
2. Locate the element by its `aria-label`, `role`, or visible text in the tree
3. Use the new `ref` value
4. Update this skill file with the new selector description and submit a PR

### Rate Limiting

If you hit rate limits:

- Reduce query frequency to 1 per 2-3 seconds
- Check for concurrent sessions (max 1 per account)
- Verify Pro subscription is active
- Consider switching to API for high-volume needs

## References

[1] Playwright MCP — Standard tool reference. https://github.com/microsoft/playwright-mcp

[2] OpenClaw Skills Guide 2026. https://techsona.dev/blog/openclaw-skills-guide-2026

[3] Perplexity Pro Features. https://www.perplexity.ai/help-center/en/articles/10352901-what-is-perplexity-pro

[4] Building AI Agents with Playwright MCP. https://www.linkedin.com/posts/bichev_aiinfrastructure-llmengineering-firecrawl-activity-7349534267925831680

## Changelog

**v1.2.0** (2026-03-08)
- Replaced ClawHub super-skill dependency (`Spiceman161/playwright-mcp`) with direct `@playwright/mcp` package
- Updated prerequisites to show `npm install -g @playwright/mcp@latest` and MCP server config
- Updated troubleshooting to use `npx playwright install chromium`

**v1.1.0** (2026-03-08)
- Fixed all tool calls to comply with MCP Playwright standard
- Replaced CSS selector pattern with accessibility-tree `ref` pattern (snapshot-first)
- Replaced `browser_press` with `browser_press_key` (global keypress, no element target)
- Replaced `browser_evaluate { script }` with `browser_evaluate { function }`
- Replaced non-standard `browser_get_text` with `browser_evaluate`
- Replaced `browser_choose_file` with `browser_file_upload`
- Removed unsupported `waitUntil` param from `browser_navigate`; use `browser_wait_for` instead
- Replaced LaTeX formatting with standard Markdown
- Updated references to use canonical Playwright MCP repository

**v1.0.0** (2026-03-07)
- Initial release
- Core search functionality
- Authentication handling
- Source extraction
- Error handling and retries
- Focus mode and Pro Search support
