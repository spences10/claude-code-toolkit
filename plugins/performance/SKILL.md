---
name: file-suggestion
description: Optimizes Claude Code file suggestions using SQLite FTS5 indexing. Provides 9x faster search with intelligent BM25 ranking. Use when setting up Claude Code performance optimizations.
---

# File Suggestion Optimization

Replaces default file suggestion with SQLite FTS5 full-text search.

## Installation

1. Make script executable:

```bash
chmod +x ~/.claude/plugins/cache/performance/file-suggestion.sh
```

2. Add to `~/.claude/settings.json`:

```json
"fileSuggestion": {
  "type": "command",
  "command": "~/.claude/plugins/cache/performance/file-suggestion.sh"
}
```

3. Restart Claude Code

## How It Works

- First query builds FTS5 index (~100ms for 5k files)
- Index cached per-repo in `~/.cache/claude-code/`
- Rebuilds automatically every 5 minutes
- Uses `git ls-files` (respects .gitignore)

## Benchmarks

| Metric      | Before       | After          |
| ----------- | ------------ | -------------- |
| Query time  | 28ms         | 3ms            |
| Ranking     | Alphabetical | BM25 relevance |
| Index build | N/A          | ~100ms         |

## Troubleshooting

**No results?** Check dependencies:

```bash
which sqlite3 python3 jq
```

**Stale index?** Delete and rebuild:

```bash
rm ~/.cache/claude-code/file-index-*.db
```
