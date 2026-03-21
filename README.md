# claude-code-toolkit

Productivity and ecosystem tools for Claude Code.

## Quick Start

```bash
# Add marketplace
/plugin marketplace add spences10/claude-code-toolkit

# Install plugins
/plugin install mcp-essentials
/plugin install analytics
/plugin install toolkit-skills
/plugin install claude-workflow
/plugin install dev-environment
/plugin install devops-skills
/plugin install dev-practices
```

## Plugins

### mcp-essentials

Setup guide for recommended MCP servers:

| Server                                                            | Purpose                                           |
| ----------------------------------------------------------------- | ------------------------------------------------- |
| [mcp-omnisearch](https://github.com/spences10/mcp-omnisearch)     | Unified search (Tavily, Kagi, GitHub, Perplexity) |
| [mcp-sqlite-tools](https://github.com/spences10/mcp-sqlite-tools) | Safe SQLite operations                            |
| [mcpick](https://github.com/spences10/mcpick)                     | Manage MCP servers, plugins, cache, and profiles  |

Skills: **mcp-setup** — setup guide for configuring MCP servers

### analytics

Query Claude Code usage from [ccrecall](https://github.com/spences10/ccrecall) database:

- Token usage by model/project/day
- Session history
- Thinking block search

Skills: **analytics** — query token usage and session history

### toolkit-skills

Core skills for the toolkit ecosystem.

| Skill               | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| **ecosystem-guide** | Guide to choosing the right tool across the ecosystem        |
| **research**        | Verify sources before presenting findings                    |
| **skill-creator**   | Design and create Claude Skills using progressive disclosure |
| **reflect**         | Extract learnings from sessions and persist to skills        |
| **plugin-dev**      | Validate, test, and distribute Claude Code plugins           |

### claude-workflow

Claude Code workflow patterns.

| Skill                     | Description                                                           |
| ------------------------- | --------------------------------------------------------------------- |
| **advanced-prompting**    | High-leverage prompts that challenge Claude's defaults                |
| **claude-md-maintenance** | Maintain CLAUDE.md files effectively                                  |
| **orchestration**         | Multi-agent orchestration patterns for team mode                      |
| **structured-rpi**        | Enhanced Research-Plan-Implement workflow with structured phase gates |

### dev-environment

Development environment setup.

| Skill                     | Description                                                |
| ------------------------- | ---------------------------------------------------------- |
| **terminal-optimization** | Terminal setup for Claude Code (Ghostty, statusline, tmux) |
| **worktree-mastery**      | Git worktree patterns for parallel Claude sessions         |

### devops-skills

DevOps patterns.

| Skill                 | Description                                                                |
| --------------------- | -------------------------------------------------------------------------- |
| **ci-debug-workflow** | Debug failing CI pipelines and reproduce bugs locally                      |
| **techdebt-finder**   | Find duplicated code, inconsistent patterns, and refactoring opportunities |
| **deslop**            | Identify and remove AI-generated code patterns (slop)                      |
| **improve-codebase-architecture** | Find architectural improvement opportunities and deepen shallow modules |

### dev-practices

Development practice skills.

| Skill   | Description                                                    |
| ------- | -------------------------------------------------------------- |
| **tdd** | Test-Driven Development workflow with red-green-refactor cycle |

## Ecosystem

Related projects for Claude Code power users.

| Project                                                             | What it does                                                                  |
| ------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| [svelte-skills-kit](https://github.com/spences10/svelte-skills-kit) | Production-ready Svelte 5 & SvelteKit skills (90%+ verified accuracy)         |
| [claude-skills-cli](https://github.com/spences10/claude-skills-cli) | Create skills with progressive disclosure validation and 84% activation hooks |
| [mcpick](https://github.com/spences10/mcpick)                       | Manage MCP servers, plugins, cache, and profiles from the CLI                 |
| [ccrecall](https://github.com/spences10/ccrecall)                   | Sync Claude Code transcripts to SQLite for usage analytics and search         |

## Local Development

```bash
git clone git@github.com:spences10/claude-code-toolkit.git ~/repos/claude-code-toolkit

# Add local marketplace
/plugin marketplace add ~/repos/claude-code-toolkit

# Install plugin
/plugin install mcp-essentials
```

## Releasing Updates

Version lives in one place: `.claude-plugin/marketplace.json`. Bump all
`"version"` values there, commit, and push. Users with auto-update get
changes on startup. Others run `/plugin update plugin-name@spences10-claude-code-toolkit`.
