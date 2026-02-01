---
name: research
# prettier-ignore
description: Verify sources before presenting findings. Use when asked to research links or documentation.
# prettier-ignore
allowed-tools: WebFetch, Read, Grep, Bash(gh:*), Task, mcp__mcp-omnisearch__web_search, mcp__mcp-omnisearch__tavily_extract_process, mcp__mcp-omnisearch__kagi_summarizer_process, mcp__mcp-omnisearch__ai_search, mcp__mcp-omnisearch__github_search
---

# Verified Research

## Quick Start

1. Fetch actual source content (don't trust snippets)
2. Verify claims before presenting
3. Report failures explicitly

## Tool Priority

1. **GitHub repos** → `gh api` via Bash
2. **Doc pages** → `tavily_extract_process`
3. **Quick answers** → `ai_search` (perplexity/kagi_fastgpt/exa_answer)
4. **Discovery** → `web_search` or `github_search`
5. **Fallback** → Clone repo via subagent

## Core Rules

- **Never present unverified findings** - fetch actual content first
- **Partial data ≠ success** - try next tool, report failures
- **No source substitution** without user consent
- **Flag contradictions** - don't silently pick one source

## References

- [verification-patterns.md](references/verification-patterns.md) - Source conflicts, cutoff handling
- [ai-search-providers.md](references/ai-search-providers.md) - exa_answer, perplexity, kagi usage
- [hallucination-prevention.md](references/hallucination-prevention.md) - CoVe, atomic facts
- [repo-cloning-pattern.md](references/repo-cloning-pattern.md) - Subagent clone workflow
- [partial-data-failures.md](references/partial-data-failures.md) - Rate limits, fallbacks
