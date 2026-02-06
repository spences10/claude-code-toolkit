# claude-code-toolkit

Productivity and ecosystem tools for Claude Code.

## Quick Start

```bash
# Add marketplace
/plugin marketplace add spences10/claude-code-toolkit

# Install plugins
/plugin install mcp-essentials
/plugin install analytics
```

## Plugins

### mcp-essentials

Setup guide for recommended MCP servers:

| Server                                                            | Purpose                                           |
| ----------------------------------------------------------------- | ------------------------------------------------- |
| [mcp-omnisearch](https://github.com/spences10/mcp-omnisearch)     | Unified search (Tavily, Kagi, GitHub, Perplexity) |
| [mcp-sqlite-tools](https://github.com/spences10/mcp-sqlite-tools) | Safe SQLite operations                            |
| [mcpick](https://github.com/spences10/mcpick)                     | Toggle MCP servers dynamically                    |

### analytics

Query Claude Code usage from [ccrecall](https://github.com/spences10/ccrecall) database:

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
| Usage analytics    | ccrecall + mcp-sqlite-tools                                         |
| Svelte development | [svelte-skills-kit](https://github.com/spences10/svelte-skills-kit) |

### research

Verified source research patterns:

- Always fetch and verify actual sources before presenting findings
- Clone repos via subagent for source-level research
- Explicit uncertainty when sources can't be verified

### skill-creator

Design and create Claude Skills using progressive disclosure:

- 3-level loading system (metadata → instructions → resources)
- Writing guide with voice, structure, and description patterns
- CLI reference for `claude-skills-cli`
- Official Anthropic best practices

### reflect

Solve "memory zero" - extract learnings from sessions and persist to skills:

- **Manual mode**: `/reflect` analyzes current session, proposes skill updates
- **Auto mode**: Stop hook suggests reflection on sessions with corrections/discoveries
- **Smart destination**: Updates marketplace skills in-place, or prompts for location

Patterns detected:

| Type        | Examples                                   |
| ----------- | ------------------------------------------ |
| Corrections | "actually use X", "no, do it this way"     |
| Successes   | "perfect", tests passing, approved changes |
| Context     | File paths, tool preferences, conventions  |

## Ecosystem

Part of a connected suite of tools for Claude Code power users. These projects work together to give Claude Code persistent memory, better search, framework expertise, and self-improving skills.

### Skills & Plugins

Create, share, and use Claude Code skills with reliable activation.

| Project                                                                   | What it does                                                                  |
| ------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| [claude-code-toolkit](https://github.com/spences10/claude-code-toolkit)   | Productivity skills, and this ecosystem guide                                 |
| [svelte-skills-kit](https://github.com/spences10/svelte-skills-kit)       | Production-ready Svelte 5 & SvelteKit skills (90%+ verified accuracy)         |
| [claude-skills-cli](https://github.com/spences10/claude-skills-cli)       | Create skills with progressive disclosure validation and 84% activation hooks |
| [svelte-claude-skills](https://github.com/spences10/svelte-claude-skills) | Original Svelte skills collection - now consolidated into svelte-skills-kit   |

### MCP Servers & Tools

Extend Claude Code's capabilities with MCP servers for search, databases, and usage tracking.

| Project                                                           | What it does                                                          |
| ----------------------------------------------------------------- | --------------------------------------------------------------------- |
| [mcp-omnisearch](https://github.com/spences10/mcp-omnisearch)     | Unified search across Tavily, Brave, Kagi, Perplexity, and GitHub     |
| [mcp-sqlite-tools](https://github.com/spences10/mcp-sqlite-tools) | Safe SQLite operations with schema inspection and query building      |
| [mcpick](https://github.com/spences10/mcpick)                     | Toggle MCP servers on/off without restarting - reduce context bloat   |
| [ccrecall](https://github.com/spences10/ccrecall)                 | Sync Claude Code transcripts to SQLite for usage analytics and search |

## Local Development

```bash
git clone git@github.com:spences10/claude-code-toolkit.git ~/repos/claude-code-toolkit

# Add local marketplace
/plugin marketplace add ~/repos/claude-code-toolkit

# Install plugin
/plugin install mcp-essentials
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

