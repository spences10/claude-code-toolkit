# claude-code-toolkit

Performance and productivity tools for Claude Code.

## Quick Start

```bash
# 1. Add marketplace (one-time)
/plugin marketplace add spences10/claude-code-toolkit

# 2. Install plugin
/plugin install performance
```

> **Note:** Marketplace = catalog. Plugin = what you install from it.

## Plugins

### performance

Optimizes Claude Code file suggestions using SQLite FTS5 indexing.

- **9x faster** file search (28ms → 3ms)
- **Smart ranking** with BM25 algorithm
- **Auto-indexing** - rebuilds every 5 minutes

| Before                          | After                             |
| ------------------------------- | --------------------------------- |
| Alphabetical results            | Relevance-ranked results          |
| `apps/a.../Button.svelte` first | `packages/ui/button.svelte` first |

## Local Development

```bash
# Clone marketplace
git clone git@github.com:spences10/claude-code-toolkit.git ~/repos/claude-code-toolkit

# 1. Add marketplace
/plugin marketplace add ~/repos/claude-code-toolkit

# 2. Install plugin
/plugin install performance
```

**Note:** Plugin files are cached at `~/.claude/plugins/cache/`. After editing source files, reinstall or manually sync cache.

## Benchmarks

Tested on xo-monorepo (5,491 git-tracked files):

| Method                 | Time    | Ranking  |
| ---------------------- | ------- | -------- |
| Default (git + grep)   | 28ms    | None     |
| **FTS5 (this plugin)** | **3ms** | **BM25** |

Larger codebases see bigger improvements (TikTok reported 8s → 200ms with 100k+ files).

## Documentation

- [File Suggestion Research](docs/file-suggestion-research.md) - Full analysis, benchmarks, and alternative approaches
