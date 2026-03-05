---
name: business-research
version: 1.0.0
description: Conduct market research and business opportunity analysis
tools: [web_search, web_fetch, read, write]
author: startup-team
---

# Business Opportunity Research

Perform structured market research and opportunity analysis.

## Research Process

### Input: GitHub Issue

Issue labeled `type:opportunity` or `epic:research` with:
- Market hypothesis
- Geographic/industry constraints
- Success criteria
- Time horizon
- Budget constraints (if any)

### Research Steps

1. **Market size estimation:**
   - Web search for TAM/SAM/SOM data
   - Look for industry reports, analyst estimates
   - Document sources and confidence levels

2. **Competitor landscape:**
   - Identify 5-10 direct/indirect competitors
   - For each: product, pricing, market position, strengths/weaknesses
   - Look for gaps or underserved segments

3. **Distribution channels:**
   - How do competitors reach customers?
   - What channels are available for new entrants?
   - Cost/difficulty of each channel

4. **Technical feasibility:**
   - Can we build this with current team/stack?
   - What new skills/tools would be needed?
   - Estimated dev time

5. **Business model:**
   - Possible revenue models (B2B, B2C, SaaS, marketplace, etc.)
   - Pricing benchmarks from competitors
   - Unit economics if estimable

### Output Format

Create `/business/opportunities/<slug>.md`:

# [Opportunity Name]

**Research Date:** Mar 5, 2026  
**Researcher:** Biz Research Agent  
**Status:** Draft / Final

## Executive Summary
[2-3 sentence TL;DR: promising/risky/not viable + key reason]

## Market Opportunity
- **TAM/SAM/SOM:** [estimates with sources]
- **Growth rate:** [X% CAGR, source]
- **Key trends:** [bullet list]

## Competitive Landscape
| Competitor | Product | Pricing | Strength | Weakness |
|------------|---------|---------|----------|----------|
| Comp A | ... | $X/mo | ... | ... |

## Distribution Strategy
- Channel 1: [description, cost, pros/cons]
- Channel 2: [description, cost, pros/cons]

## Technical Feasibility
- **Can build:** Yes/No/Partially
- **Time estimate:** X weeks
- **New skills needed:** [list]
- **Dependencies:** [list]

## Business Model Options
1. **Option A:** [model] - [pros/cons]
2. **Option B:** [model] - [pros/cons]

## Risks & Challenges
- Risk 1
- Risk 2
- Risk 3

## Recommendation
**Go / No-go / Maybe:** [choice]  
**Rationale:** [2-3 sentences]  
**Next steps if go:**
1. Step A
2. Step B
3. Step C

## Sources
[1] [Source citation]  
[2] [Source citation]

Also post a **concise summary comment** on the GitHub issue:

📈 [Biz Research Agent]

Research complete: [OPPORTUNITY NAME]

**TL;DR:** [1-2 sentences]

**Recommendation:** Go / No-go / Maybe

**Key risks:** [top 2]

**Full analysis:** /business/opportunities/<slug>.md

### Best Practices

- **Always include sources** - every claim should have a citation
- **Mark confidence levels** - "High confidence" vs "Rough estimate"
- **Be realistic** - don't oversell opportunities
- **Include dissenting views** - what could go wrong?
- **Quantify when possible** - numbers > adjectives
- **Recommend next steps** - make it actionable

---

