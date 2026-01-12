# File Suggestion Optimization Research

Research into optimizing Claude Code file suggestions for large codebases.

## Background

A TikTok engineer shared their optimization that reduced file search from 8s to 200ms:

> Today I did an exploration and reduced the file search time in TikTok's codebase from almost 8s to less than 200ms. Mentioning any file in Claude is practically instantaneous now.
>
> The default fast filesystem traversal configuration is good for smaller projects, but for large-scale projects, a proprietary indexing system is recommended.
>
> Claude lets you customize this configuration through settings.json:
>
> ```json
> {
>   "fileSuggestion": {
>     "type": "command",
>     "command": "~/.claude/file-suggestion.sh"
>   }
> }
> ```
>
> My script does a quick indexing on startup, caches it in table form, and I added some invalidation and update mechanisms in case new files are added.
>
> In summary, I use FTS5 (full-text search) to perform the search in the table and use the ranking system to filter relevant results for R&D.

## Alternative Approaches

### ripgrep + fzf (not implemented)

Another approach using ripgrep and fzf was shared by [@thayto_dev](https://x.com/thayto_dev/status/2009401734213554494):

```bash
#!/bin/bash
QUERY=$(jq -r '.query // ""')
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
cd "$PROJECT_DIR" || exit 1

{
  rg --files --follow --hidden . 2>/dev/null
} | sort -u | fzf --filter "$QUERY" | head -15
```

**Trade-offs:**

- Simpler setup
- Always fresh (no index)
- Slower (~55ms vs 3ms)
- Requires fzf installation

### SQLite FTS5 (implemented)

We chose FTS5 because:

- Fastest query time (3ms)
- Best ranking with BM25 algorithm
- No additional dependencies beyond sqlite3/python3

## Benchmarks

### Test Environment

| Metric                           | Value       |
| -------------------------------- | ----------- |
| Repository                       | xo-monorepo |
| Git-tracked files                | 5,491       |
| Total files (incl. node_modules) | 130,463     |

### Search Performance Comparison

| Method              | Time  | Notes                                      |
| ------------------- | ----- | ------------------------------------------ |
| grep (baseline)     | 9ms   | Simple substring match, no ranking         |
| SQLite FTS5         | 3ms   | **3x faster**, with intelligent ranking    |
| FTS5 + BM25 ranking | 4ms   | Best results first based on term frequency |
| ripgrep + fzf       | ~55ms | Requires fzf install                       |
| git ls-files + grep | 28ms  | Git's built-in index                       |

### Index Build Time

| Approach            | Time     | Notes                |
| ------------------- | -------- | -------------------- |
| Line-by-line insert | 69 sec   | Naive implementation |
| Bulk Python insert  | **96ms** | Production approach  |

### Ranking Quality Example

Search: "button"

| Rank | FTS5 Result                                       | Why it ranks higher         |
| ---- | ------------------------------------------------- | --------------------------- |
| 1    | `packages/ui/src/button/button.svelte`            | "button" appears 2x in path |
| 2    | `apps/xoos-sveltekit/.../ui/button/button.svelte` | "button" appears 2x         |
| 8    | `apps/xoos-sveltekit/.../reusable/Button.svelte`  | "button" appears 1x         |

Without FTS5, results are alphabetical - `apps/agent-assist.../Button.svelte` would appear first instead of the more relevant shared UI component.

### Scalability Comparison

| Metric              | TikTok        | XO Monorepo   |
| ------------------- | ------------- | ------------- |
| Before optimization | ~8 seconds    | ~9ms          |
| After optimization  | ~200ms        | ~3ms          |
| Improvement         | **40x**       | **3x**        |
| Files (estimated)   | 100k+ tracked | 5,491 tracked |

FTS5 benefits increase with codebase size: O(log n) vs O(n).

## Key Findings

1. **Speed**: 3-9x faster file search depending on baseline
2. **Ranking**: BM25 algorithm puts most relevant files first
3. **Scalability**: Larger codebases see bigger improvements
4. **Build cost**: One-time ~100ms index build, refreshed every 5 minutes
5. **Dependencies**: Only requires sqlite3, python3, jq (commonly available)

## Implementation Decision

**Chose SQLite FTS5** over ripgrep + fzf because:

| Factor          | FTS5             | rg + fzf    |
| --------------- | ---------------- | ----------- |
| Query speed     | 3ms              | ~55ms       |
| Ranking         | BM25 (smart)     | fzf score   |
| Dependencies    | sqlite3, python3 | rg, fzf, jq |
| Index staleness | 5-min refresh    | None        |
| Complexity      | Medium           | Simple      |

For most codebases, FTS5 provides the best balance of speed and ranking quality.

## References

- Original TikTok optimization tweet (source unavailable)
- Alternative fzf approach: https://x.com/thayto_dev/status/2009401734213554494
- SQLite FTS5 documentation: https://www.sqlite.org/fts5.html
- BM25 ranking algorithm: https://en.wikipedia.org/wiki/Okapi_BM25
