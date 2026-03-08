---
name: perplexity-webui-search
description: Perform web searches via Perplexity WebUI using Playwright automation. Extract answers, sources, and citations for research tasks.
version: 1.0.0
author: Michele Facco
requires:
  skills:
    - playwright-mcp  # Spiceman161/playwright-mcp from ClawHub
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

\begin{itemize}
\item Search for current, real-time information not in your training data
\item Retrieve cited sources and references for factual claims
\item Compare multiple perspectives on recent events or topics
\item Access Perplexity Pro's unlimited searches without API costs
\item Extract structured data from Perplexity's search results
\end{itemize}

**Do NOT use for:**
- Questions answerable from your existing knowledge
- Queries requiring sub-second response times (use Perplexity API instead)
- Bulk automation (rate limits apply to Pro accounts)

## Prerequisites

### Environment Variables

Set these in your OpenClaw environment or `.env` file:

export PERPLEXITY_EMAIL="your-email@example.com"
export PERPLEXITY_PASSWORD="your-password"

### Playwright MCP Installation

This skill requires the base `playwright-mcp` skill from ClawHub:

npx -y @lobehub/market-cli skills install Spiceman161/playwright-mcp

Verify Chromium is installed:

playwright install chromium

## Core Instructions

### Search Workflow

When the user requests information that requires web search, follow this sequence:

#### Step 1: Navigate to Perplexity

// Use playwright-mcp's browser_navigate tool
await browser_navigate({
  url: "https://www.perplexity.ai",
  waitUntil: "networkidle"
});

#### Step 2: Check Authentication State

// Take snapshot to check if logged in
const snapshot = await browser_snapshot();

// If login form visible, authenticate
if (snapshot.includes("Sign in") || snapshot.includes("Log in")) {
  await authenticatePerplexity();
}

#### Step 3: Submit Query

// Type into search input
await browser_type({
  selector: 'textarea[placeholder*="Ask anything"]',
  text: userQuery
});

// Submit query (Enter key)
await browser_press({
  selector: 'textarea[placeholder*="Ask anything"]',
  key: "Enter"
});

#### Step 4: Wait for Response

// Wait for response container to appear
// Perplexity streams responses, so wait for completion indicator
await browser_evaluate({
  script: `
    new Promise((resolve) => {
      const checkComplete = () => {
        const stopButton = document.querySelector('[aria-label="Stop generating"]');
        if (!stopButton || stopButton.disabled) {
          resolve(true);
        } else {
          setTimeout(checkComplete, 500);
        }
      };
      checkComplete();
    });
  `
});

#### Step 5: Extract Results

// Extract answer text
const answer = await browser_get_text({
  selector: 'div[class*="answer"]'
});

// Extract sources
const sources = await browser_evaluate({
  script: `
    Array.from(document.querySelectorAll('[data-testid="citation-link"]'))
      .map(link => ({
        title: link.textContent.trim(),
        url: link.href,
        number: link.getAttribute('data-citation-number')
      }));
  `
});

### Authentication Helper

async function authenticatePerplexity() {
  // Click sign-in button
  await browser_click({
    selector: 'button:has-text("Sign in")'
  });
  
  // Wait for email input
  await browser_type({
    selector: 'input[type="email"]',
    text: process.env.PERPLEXITY_EMAIL
  });
  
  // Click continue
  await browser_click({
    selector: 'button:has-text("Continue")'
  });
  
  // Enter password
  await browser_type({
    selector: 'input[type="password"]',
    text: process.env.PERPLEXITY_PASSWORD
  });
  
  // Submit
  await browser_press({
    selector: 'input[type="password"]',
    key: "Enter"
  });
  
  // Wait for redirect to home
  await browser_navigate({
    url: "https://www.perplexity.ai",
    waitUntil: "networkidle"
  });
}

## Response Format

Structure your responses with:

\begin{enumerate}
\item \textbf{Direct Answer}: Summarize Perplexity's response in 2-3 sentences
\item \textbf{Key Points}: Bullet list of main findings
\item \textbf{Sources}: Numbered citations with titles and URLs
\item \textbf{Follow-up}: Suggest related queries if relevant
\end{enumerate}

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

// Click focus dropdown
await browser_click({
  selector: '[aria-label="Focus mode"]'
});

// Select mode: All, Academic, Writing, Wolfram, YouTube, Reddit
await browser_click({
  selector: 'button:has-text("Academic")'  // For research papers
});

### Pro Search Toggle

Enable Pro Search for complex queries:

// Toggle Pro search if available
const proToggle = await browser_evaluate({
  script: `document.querySelector('[aria-label="Pro Search"]')`
});

if (proToggle) {
  await browser_click({
    selector: '[aria-label="Pro Search"]'
  });
}

### Image Analysis

If user provides image URL for visual search:

// Click image upload button
await browser_click({
  selector: '[aria-label="Attach image"]'
});

// Choose file (if local)
await browser_choose_file({
  selector: 'input[type="file"]',
  files: [imagePath]
});

// Or paste URL in dialog
await browser_type({
  selector: 'input[placeholder*="Image URL"]',
  text: imageUrl
});

## Error Handling

### Common Failure Modes

\begin{table}
\begin{tabular}{|l|l|l|}
\hline
\textbf{Error} & \textbf{Cause} & \textbf{Solution} \\
\hline
Login failure & Wrong credentials & Verify PERPLEXITY\_EMAIL/PASSWORD \\
\hline
Timeout & Slow response & Increase waitUntil timeout to 30s \\
\hline
Rate limit & Too many queries & Wait 60s between queries \\
\hline
Selector not found & UI changed & Use accessibility tree snapshot \\
\hline
\end{tabular}
\caption{Perplexity WebUI error handling}
\end{table}

### Retry Logic

async function searchWithRetry(query, maxRetries = 3) {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await performSearch(query);
    } catch (error) {
      if (attempt === maxRetries) throw error;
      
      console.log(`Attempt ${attempt} failed, retrying in ${attempt * 2}s...`);
      await sleep(attempt * 2000);
      
      // Reset browser state
      await browser_navigate({
        url: "https://www.perplexity.ai",
        waitUntil: "networkidle"
      });
    }
  }
}

## Performance Optimization

### Session Persistence

Playwright MCP maintains browser context between queries. Leverage this:

\begin{itemize}
\item First query: Full authentication flow (10-15s)
\item Subsequent queries: Skip auth, direct search (5-8s)
\item Session expires: Re-authenticate automatically
\end{itemize}

### Parallel Queries

For multiple searches, use sequential execution (Perplexity limits concurrent sessions):

// WRONG: Parallel execution
const results = await Promise.all(queries.map(q => search(q)));

// CORRECT: Sequential with rate limiting
const results = [];
for (const query of queries) {
  results.push(await search(query));
  await sleep(2000);  // 2s between queries
}

## Integration Example

### Full Search Function

async function perplexitySearch(query, options = {}) {
  const {
    focusMode = "All",
    proSearch = false,
    maxWaitTime = 30000
  } = options;
  
  // Navigate to Perplexity
  await browser_navigate({
    url: "https://www.perplexity.ai",
    waitUntil: "networkidle"
  });
  
  // Check and handle authentication
  const snapshot = await browser_snapshot();
  if (snapshot.includes("Sign in")) {
    await authenticatePerplexity();
  }
  
  // Configure search mode
  if (focusMode !== "All") {
    await browser_click({ selector: '[aria-label="Focus mode"]' });
    await browser_click({ selector: `button:has-text("${focusMode}")` });
  }
  
  // Enable Pro search if requested
  if (proSearch) {
    await browser_click({ selector: '[aria-label="Pro Search"]' });
  }
  
  // Submit query
  await browser_type({
    selector: 'textarea[placeholder*="Ask anything"]',
    text: query
  });
  await browser_press({
    selector: 'textarea[placeholder*="Ask anything"]',
    key: "Enter"
  });
  
  // Wait for completion
  await browser_evaluate({
    script: `
      new Promise((resolve, reject) => {
        const timeout = setTimeout(() => reject(new Error('Response timeout')), ${maxWaitTime});
        const checkComplete = () => {
          const stopButton = document.querySelector('[aria-label="Stop generating"]');
          if (!stopButton || stopButton.disabled) {
            clearTimeout(timeout);
            resolve(true);
          } else {
            setTimeout(checkComplete, 500);
          }
        };
        checkComplete();
      });
    `
  });
  
  // Extract results
  const answer = await browser_get_text({
    selector: 'div[class*="answer"]'
  });
  
  const sources = await browser_evaluate({
    script: `
      Array.from(document.querySelectorAll('[data-testid="citation-link"]'))
        .map(link => ({
          title: link.textContent.trim(),
          url: link.href,
          citation: link.getAttribute('data-citation-number')
        }));
    `
  });
  
  return {
    query,
    answer,
    sources,
    focusMode,
    proSearch,
    timestamp: new Date().toISOString()
  };
}

## Usage Guidelines

### Cost Management

\begin{itemize}
\item Pro subscription: \$20/month for unlimited searches
\item No per-query API costs
\item Browser overhead: ~100-200 MB RAM per session
\item Typical query: 5-15 seconds end-to-end
\end{itemize}

### When to Prefer API Over WebUI

Use Perplexity's Search API instead if:

\begin{itemize}
\item You need sub-5-second responses
\item Running bulk/batch queries (>50/day)
\item Building production services
\item Require structured JSON responses
\item Need programmatic reliability guarantees
\end{itemize}

Use this WebUI skill if:

\begin{itemize}
\item You have Pro subscription (unlimited free queries)
\item Running 5-20 queries per day
\item Need Pro Search features (deep research mode)
\item Want to avoid API credit costs during prototyping
\item Comfortable with 10-15s latency
\end{itemize}

## Troubleshooting

### Browser Context Issues

If Playwright MCP loses browser state:

# Reset Playwright browser data
rm -rf ~/Library/Application\ Support/ms-playwright/
playwright install chromium

### Selector Changes

Perplexity updates UI regularly. If selectors break:

\begin{enumerate}
\item Use \texttt{browser\_snapshot()} to get accessibility tree
\item Find updated selectors via \texttt{data-testid} or \texttt{aria-label}
\item Update selectors in skill file
\item Submit PR to skill repository with fix
\end{enumerate}

### Rate Limiting

If you hit rate limits:

\begin{itemize}
\item Reduce query frequency to 1 per 2-3 seconds
\item Check for concurrent sessions (max 1 per account)
\item Verify Pro subscription is active
\item Consider switching to API for high-volume needs
\end{itemize}

## References

[1] Playwright MCP Documentation. https://github.com/spiceman161/playwright-mcp

[2] OpenClaw Skills Guide 2026. https://techsona.dev/blog/openclaw-skills-guide-2026

[3] Perplexity Pro Features. https://www.perplexity.ai/help-center/en/articles/10352901-what-is-perplexity-pro

[4] Building AI Agents with Playwright MCP. https://www.linkedin.com/posts/bichev_aiinfrastructure-llmengineering-firecrawl-activity-7349534267925831680

## Changelog

**v1.0.0** (2026-03-07)
- Initial release
- Core search functionality
- Authentication handling
- Source extraction
- Error handling and retries
- Focus mode and Pro Search support
