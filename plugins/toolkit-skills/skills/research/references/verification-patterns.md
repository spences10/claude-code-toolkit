# Verification Patterns

Detailed patterns for verifying sources during research.

## Pattern 1: URL Research

When given a URL to research:

1. Use WebFetch to get the actual content
2. Read the complete relevant sections
3. Don't rely on summaries or snippets
4. Quote specific passages that support claims
5. Cite exact URLs

**Example:**

```
User: "Research this article about MCP performance"

WRONG approach:
- Search for article
- Present snippet results
- Make claims based on title

RIGHT approach:
- WebFetch the URL
- Read full content
- Search for performance mentions
- Quote specific data/claims
- If no performance data exists, say so
```

## Pattern 2: Official Sources

When asked to "use official sources":

1. Search for official documentation
2. **Fetch the actual pages** (don't trust search snippets)
3. Read relevant sections completely
4. Quote specific parts
5. Cite exact URLs for each claim

## Pattern 3: Questionable Claims

When something seems questionable:

- Fetch the original source
- Compare snippet/summary to actual content
- Call out discrepancies explicitly
- Say "I couldn't verify this" if sources don't support

## Anti-Patterns

Never do these:

- Presenting search snippets as facts without verification
- Trusting summaries without checking original sources
- Citing sources you haven't actually read
- Assuming snippets accurately represent full content
- Making confident claims based on titles alone

## When To Admit Uncertainty

If you can't verify because:

- Source is behind paywall/404
- Content doesn't support the claim
- Multiple sources contradict

**Say so explicitly.** Better to admit uncertainty than present unverified info.

## Detailed Examples

### Example 1: Security Documentation

User: "Research how Claude Code handles bash security"

Process:

1. Search for official Claude Code security docs
2. **Fetch the actual documentation pages**
3. Read security sections completely
4. Extract specific quotes about bash handling
5. Present findings with exact citations and line references

Not: Just present search result snippets

### Example 2: Technical Article

User: "Study this article and tell me what it says about overhead"

Process:

1. **Fetch the actual article content**
2. Search for mentions of "overhead", "performance"
3. Read those sections in full context
4. Quote specific passages
5. If article doesn't mention overhead, say "The article doesn't actually discuss overhead"

Not: Assume what it says based on title/snippet

### Example 3: Contradictory Sources

User: "Research whether MCP tools are faster than CLI"

Process:

1. Search for relevant sources
2. **Fetch multiple actual sources**
3. Compare what they actually say
4. If they contradict, present both views with quotes
5. Explain the contradiction explicitly
6. Don't pick one without evidence

Not: Present the first search result as truth

## Pattern 4: Source Conflict Resolution

When sources contradict each other, use Chain-of-Verification with credibility-aware aggregation.

### Detection

1. Identify the specific claim in conflict
2. Note each source's position explicitly
3. Check publication dates for each source
4. Assess source authority (official docs > blogs > forums)

### Credibility Scoring

Rate sources on 1-5 scale before aggregating:

| Score | Criteria                                                  |
| ----- | --------------------------------------------------------- |
| 5     | Primary source, peer-reviewed, official documentation     |
| 4     | Reputable secondary source, cross-referenced with primary |
| 3     | Established publication, some verification possible       |
| 2     | Blog/forum with citations, partial verification           |
| 1     | Unverified, no citations, unknown author                  |

### Chain-of-Verification Process

Decompose conflicting claims and verify systematically:

1. **Decompose**: Break claim into verifiable sub-claims
2. **Query**: Search each sub-claim against multiple sources
3. **Annotate stance**: Mark each source as support/refute/neutral
4. **Score credibility**: Apply 1-5 rating per source
5. **Compare**: Identify where sources agree/disagree
6. **Aggregate**: Weight by credibility, resolve via rationales

### Resolution Strategies

**Source Background Augmentation (SBA)**: Append credibility context when reasoning about conflicts. Include source type, date, and credibility score in analysis.

**Ensemble approach** for complex conflicts:

1. Generate answer per source
2. Compare rationales
3. Reconcile based on credibility weighting

### Resolution Hierarchy

1. **Prefer authoritative sources**: Official documentation > peer-reviewed > news > blogs
2. **Check recency**: Newer sources often supersede older ones (especially in tech)
3. **Seek consensus**: If 3+ independent sources agree, weight that heavily
4. **Verify primary sources**: Trace claims back to originals when possible
5. **Check topical consistency**: Verify claim aligns with evidence topic

### When Resolution Fails

<good-example>
Source A (official docs, 2024, credibility: 5) states the API uses REST endpoints.
However, Source B (developer blog, 2025, credibility: 3) claims GraphQL support was added.
The higher-credibility source may be outdated. Recommend checking the changelog or
testing directly. Both views presented pending verification.
</good-example>

<bad-example>
The API supports both REST and GraphQL.
(Silently merging conflicting info without attribution or credibility analysis)
</bad-example>

**Present both views with citations and credibility context. Don't silently pick one.**

### Prioritization Table

| Factor           | Action                                                             |
| ---------------- | ------------------------------------------------------------------ |
| Credibility      | Score 1-5; official docs > peer-reviewed > verified blogs > forums |
| Recency          | Check dates; newer often wins for evolving topics                  |
| Consensus        | 3+ independent sources agreeing = strong signal                    |
| Specificity      | Specific claims with evidence > vague assertions                   |
| Stance alignment | Check if evidence actually supports or refutes claim               |

## Pattern 5: Knowledge Cutoff Handling

When research involves potentially outdated knowledge. LLMs have temporal blind spots where parametric knowledge may be outdated even within reported cutoff dates.

### Claim Classification

Classify claims before researching:

| Type                  | Description                                          | Action                  |
| --------------------- | ---------------------------------------------------- | ----------------------- |
| **Static**            | Facts unlikely to change (math, historical events)   | Parametric knowledge OK |
| **Time-sensitive**    | Facts that change (versions, prices, current events) | RAG retrieval required  |
| **Temporal boundary** | Facts with validity windows (API versions, laws)     | Include effective dates |

### Recognition Triggers

Recognize when knowledge cutoff may affect accuracy:

- Version numbers or release dates
- Current events or recent announcements
- "Latest" or "new" feature discussions
- Pricing, availability, or service status
- API endpoints or configuration options
- Words like "currently", "now", "recent", "latest"

### Strategy

1. **Classify the claim**: Static vs time-sensitive
2. **For time-sensitive: RAG required** - don't rely on training data
3. **Fetch actual sources** - snippets may be outdated too
4. **Include temporal metadata**: publication date, last verified, validity window
5. **Cross-reference fresh sources** for any temporal claims
6. **Flag outdated parametric knowledge** explicitly when detected

### Example

<bad-example>
User: "What's the latest Claude model?"

The latest Claude model is Claude 3 Opus.
(Answering from training data without verification - temporal claim treated as static)
</bad-example>

<good-example>
User: "What's the latest Claude model?"

Classification: Time-sensitive (version info changes)
Action: RAG retrieval required

1. Search: "Anthropic Claude model 2026"
2. Fetch: anthropic.com/claude page
3. Quote: "Claude Opus 4.5 released January 2026"
4. Metadata: Source dated Feb 2026, official documentation
5. Cite: "As of Feb 2026, the latest is Claude Opus 4.5.
   Verify at anthropic.com/claude for current info."
   </good-example>

### Temporal Metadata Template

Include with time-sensitive claims:

```
Claim: [the claim]
Type: Time-sensitive
Source: [URL]
Source date: [publication/last-updated date]
Verified: [date you fetched it]
Validity: [if known, when this fact may change]
```

### Disclosure Template

When research may be affected by knowledge cutoff:

```
"This information is from [source] dated [date]. Given the
rapidly evolving nature of [topic], verify current status at
[official source URL]."
```

### Critical Domains

Extra caution required for:

- **Software versions**: APIs change frequently
- **Security advisories**: Patches and vulnerabilities evolve
- **Pricing/availability**: Services change constantly
- **Legal/regulatory**: Laws and compliance requirements update
- **Medical/scientific**: New research supersedes old

### Temporal Misalignment Warning

Training data may have inconsistent temporal coverage:

- Different sources in training have different effective dates
- Deduplication can cause version mixing
- Always verify time-sensitive facts via RAG even if confident
