---
name: session-analytics
description: Query Claude Code session analytics from ccrecall database. Use when user asks about token usage, costs, session history, or wants to analyze their Claude Code usage patterns.
---

# Session Analytics

Query your Claude Code usage data from the ccrecall SQLite database.

## Prerequisites

```bash
# Sync transcripts to SQLite (requires bun)
bun x ccrecall sync
```

Database location: `~/.claude/ccrecall.db`

## CLI Commands

```bash
bun x ccrecall sync      # Import transcripts (incremental)
bun x ccrecall stats     # Show session/message/token counts
bun x ccrecall sessions  # List recent sessions
bun x ccrecall search    # Full-text search across messages
bun x ccrecall tools     # Show most-used tools
bun x ccrecall query     # Execute raw SQL
```

## Quick Queries

### Token usage by model

```sql
SELECT model,
       COUNT(*) as messages,
       SUM(input_tokens) as input_tok,
       SUM(output_tokens) as output_tok
FROM messages
WHERE model IS NOT NULL
GROUP BY model;
```

### Daily usage

```sql
SELECT date(timestamp/1000, 'unixepoch') as day,
       COUNT(*) as msgs,
       SUM(output_tokens) as tokens
FROM messages
GROUP BY day
ORDER BY day DESC
LIMIT 7;
```

### Usage by project

```sql
SELECT s.project_path,
       COUNT(m.uuid) as messages,
       SUM(m.output_tokens) as tokens
FROM sessions s
JOIN messages m ON m.session_id = s.id
GROUP BY s.project_path
ORDER BY tokens DESC
LIMIT 10;
```

### Estimated costs (Opus 4.5)

```sql
SELECT s.project_path,
       SUM(m.input_tokens) / 1000000.0 * 15 +
       SUM(m.output_tokens) / 1000000.0 * 75 +
       SUM(m.cache_read_tokens) / 1000000.0 * 1.5 +
       SUM(m.cache_creation_tokens) / 1000000.0 * 18.75 as cost_usd
FROM sessions s
JOIN messages m ON m.session_id = s.id
WHERE m.model LIKE '%opus%'
GROUP BY s.project_path
ORDER BY cost_usd DESC;
```

### Tool usage

```sql
SELECT tool_name, COUNT(*) as count
FROM tool_calls
GROUP BY tool_name
ORDER BY count DESC;
```

### Search thinking blocks

```sql
SELECT substr(thinking, 1, 200) as preview,
       datetime(timestamp/1000, 'unixepoch') as time
FROM messages
WHERE thinking LIKE '%your search term%'
ORDER BY timestamp DESC
LIMIT 10;
```

## Using with mcp-sqlite-tools

If you have mcp-sqlite-tools configured, Claude can query directly:

1. Open database: `open_database ~/.claude/ccrecall.db`
2. Tables: `sessions`, `messages`, `tool_calls`, `tool_results`, `teams`, `team_members`, `team_tasks`
3. Run queries above or ask Claude to analyze patterns

## GitHub

https://github.com/spences10/ccrecall
