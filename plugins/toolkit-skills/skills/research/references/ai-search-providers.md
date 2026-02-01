# AI Search Providers

## Provider Selection

| Provider     | Best For                                           | Caveat                          |
| ------------ | -------------------------------------------------- | ------------------------------- |
| perplexity   | Current events, synthesized answers with citations | May not include all sources     |
| kagi_fastgpt | Quick factual answers                              | Less detail than perplexity     |
| exa_answer   | Semantic/conceptual search                         | Synthesized - verify key claims |

## exa_answer Guidance

**When to use:** Questions needing semantic/conceptual understanding, not keyword matching.

| Use Case                           | Tool          |
| ---------------------------------- | ------------- |
| "How does X work conceptually?"    | exa_answer    |
| "Find files containing function Y" | github_search |
| "What's the latest on topic Z?"    | perplexity    |

### Strengths

- Neural search finds conceptually related content
- Returns citations you can verify
- Good for exploratory "how/why" questions

### Limitations

- Synthesized answer = potential for synthesis errors
- Must still verify critical claims against cited sources
- Not a substitute for fetching primary docs

### Workflow Pattern

```
1. Use exa_answer for initial conceptual understanding
2. Extract citations from response
3. Fetch cited URLs with tavily_extract to verify key claims
4. Cross-check against primary sources if available
5. Only present verified information to user
```

### Anti-Patterns

```
❌ Use exa_answer → present synthesized answer as verified fact
❌ Treat exa_answer as standalone tool (it's part of verification workflow)
```

## gh CLI for GitHub Repos

```bash
# Get source files directly
gh api repos/OWNER/REPO/contents/PATH --jq '.content' | base64 -d

# Get repo metadata + version
gh repo view OWNER/REPO --json description,latestRelease
```
