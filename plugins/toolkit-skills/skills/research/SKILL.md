---
name: research
# prettier-ignore
description: Research topics by verifying actual source content. Use when asked to research or study links and documentation.
# prettier-ignore
allowed-tools: WebFetch, Read, Grep, Bash(gh:*), Task, mcp__mcp-omnisearch__web_search, mcp__mcp-omnisearch__tavily_extract_process, mcp__mcp-omnisearch__kagi_summarizer_process, mcp__mcp-omnisearch__ai_search, mcp__mcp-omnisearch__github_search
---

# Verified Research

## Tool Priority (try in order)

1. **GitHub repos** → `gh api` or `gh repo` via Bash
2. **Doc pages** → `tavily_extract_process` with URL array
3. **Quick answers** → `ai_search` (perplexity/kagi_fastgpt)
4. **Discovery** → `web_search` or `github_search`
5. **Fallback** → Clone repo via subagent

## Core Rule

**Never present findings without examining actual source content.**

If fetch returns partial/summary → try next tool. Report failures explicitly.

## gh CLI for GitHub Repos

```bash
# Get source files directly
gh api repos/OWNER/REPO/contents/PATH --jq '.content' | base64 -d

# Get repo metadata + version
gh repo view OWNER/REPO --json description,latestRelease
```

## When Fetch Returns Partial Data

Partial success ≠ success. If tool returns summary instead of full content:

1. **STOP** - don't proceed with incomplete data
2. **Try next tool** - use priority list above
3. **Report** - tell user what succeeded/failed
4. **Ask** - if all fail, get user decision

**Never substitute sources without user consent.**

## References

- [references/verification-patterns.md](references/verification-patterns.md)
- [references/repo-cloning-pattern.md](references/repo-cloning-pattern.md)
- [references/partial-data-failures.md](references/partial-data-failures.md)
