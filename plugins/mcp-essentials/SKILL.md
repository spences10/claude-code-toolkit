---
name: mcp-setup
description: Setup guide for essential MCP servers. Use when configuring MCP servers or when user asks about search, SQLite, or MCP management.
---

# MCP Essentials Setup

Three MCP servers that enhance Claude Code workflows.

## Quick Install

```bash
npm i -g mcp-omnisearch mcp-sqlite-tools mcpick
```

## 1. mcp-omnisearch

Unified search across Tavily, Brave, Kagi, Perplexity, GitHub, and more.

**GitHub:** https://github.com/spences10/mcp-omnisearch

**Config (~/.claude/settings.json):**

```json
{
  "mcpServers": {
    "mcp-omnisearch": {
      "command": "npx",
      "args": ["-y", "mcp-omnisearch"],
      "env": {
        "TAVILY_API_KEY": "your-key",
        "BRAVE_API_KEY": "your-key",
        "KAGI_API_KEY": "your-key"
      }
    }
  }
}
```

**Use when:** Web search, GitHub code search, AI-powered answers, content extraction.

## 2. mcp-sqlite-tools

Safe SQLite operations with read/write separation and transaction support.

**GitHub:** https://github.com/spences10/mcp-sqlite-tools

**Config:**

```json
{
  "mcpServers": {
    "mcp-sqlite-tools": {
      "command": "npx",
      "args": ["-y", "mcp-sqlite-tools"]
    }
  }
}
```

**Use when:** Query databases, analyze data, manage SQLite files.

## 3. mcpick

Dynamically enable/disable MCP servers to optimize context usage.

**GitHub:** https://github.com/spences10/mcpick

**Install:** `npm i -g mcpick`

**Usage:**

```bash
mcpick enable omnisearch sqlite-tools
mcpick disable memory-server
mcpick list
```

**Use when:** Too many MCPs eating context, need to toggle servers per-project.

## Recommended Combinations

| Workflow        | Enable                         |
| --------------- | ------------------------------ |
| Research        | omnisearch                     |
| Data analysis   | sqlite-tools                   |
| Full stack      | omnisearch + sqlite-tools      |
| Minimal context | Use mcpick to toggle as needed |
