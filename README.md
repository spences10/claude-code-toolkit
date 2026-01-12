# claude-code-toolkit

Performance, productivity, and ecosystem tools for Claude Code.

## Quick Start

```bash
# Add marketplace
/plugin marketplace add spences10/claude-code-toolkit

# Install plugins
/plugin install performance
/plugin install mcp-essentials
/plugin install analytics
```

## Plugins

### performance

Optimizes file suggestions using SQLite FTS5 indexing.

- **9x faster** file search (28ms → 3ms)
- **Smart ranking** with BM25 algorithm
- **Auto-indexing** - rebuilds every 5 minutes

### mcp-essentials

Setup guide for recommended MCP servers:

| Server                                                            | Purpose                                           |
| ----------------------------------------------------------------- | ------------------------------------------------- |
| [mcp-omnisearch](https://github.com/spences10/mcp-omnisearch)     | Unified search (Tavily, Kagi, GitHub, Perplexity) |
| [mcp-sqlite-tools](https://github.com/spences10/mcp-sqlite-tools) | Safe SQLite operations                            |
| [mcpick](https://github.com/spences10/mcpick)                     | Toggle MCP servers dynamically                    |

### analytics

Query Claude Code usage from [cclog](https://github.com/spences10/cclog) database:

- Token usage by model/project/day
- Estimated costs
- Session history
- Thinking block search

## Skills

### ecosystem-guide

Decision tree for choosing the right tool:

| Need               | Tool                                                                |
| ------------------ | ------------------------------------------------------------------- |
| Web/GitHub search  | mcp-omnisearch                                                      |
| Database queries   | mcp-sqlite-tools                                                    |
| Reduce MCP context | mcpick                                                              |
| Usage analytics    | cclog + mcp-sqlite-tools                                            |
| Svelte development | [svelte-skills-kit](https://github.com/spences10/svelte-skills-kit) |

## Ecosystem

Part of the [@spences10](https://github.com/spences10) Claude Code ecosystem:

| Repo                                                                      | Stars | Description              |
| ------------------------------------------------------------------------- | ----- | ------------------------ |
| [mcp-omnisearch](https://github.com/spences10/mcp-omnisearch)             | 260+  | Unified search MCP       |
| [svelte-claude-skills](https://github.com/spences10/svelte-claude-skills) | 130+  | Svelte/SvelteKit skills  |
| [claude-skills-cli](https://github.com/spences10/claude-skills-cli)       | 58+   | CLI for creating skills  |
| [mcpick](https://github.com/spences10/mcpick)                             | 43+   | Dynamic MCP toggling     |
| [cclog](https://github.com/spences10/cclog)                               | -     | Transcript → SQLite sync |
| [mcp-sqlite-tools](https://github.com/spences10/mcp-sqlite-tools)         | -     | SQLite operations MCP    |

## Local Development

```bash
git clone git@github.com:spences10/claude-code-toolkit.git ~/repos/claude-code-toolkit

# Add local marketplace
/plugin marketplace add ~/repos/claude-code-toolkit

# Install plugin
/plugin install performance
```

## Releasing Updates

```bash
# 1. Make your changes

# 2. Bump version (updates all plugin.json files)
./scripts/bump-version.sh 0.0.2

# 3. Update CHANGELOG.md

# 4. Commit and push
git add -A && git commit -m "chore: bump to 0.0.2" && git push
```

Users with auto-update enabled get updates on Claude Code startup.
Others can run `/plugin update plugin-name@spences10-claude-code-toolkit`.

## Documentation

- [File Suggestion Research](docs/file-suggestion-research.md) - FTS5 analysis and benchmarks
