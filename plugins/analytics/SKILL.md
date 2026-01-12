---
name: session-analytics
description: Query Claude Code session analytics from cclog database. Use when user asks about token usage, costs, session history, or wants to analyze their Claude Code usage patterns.
---

# Session Analytics

Query your Claude Code usage data from the cclog SQLite database.

## Prerequisites

```bash
# Install cclog
npm i -g cclog

# Sync transcripts to SQLite
cclog sync
```

Database location: `~/.claude/cclog.db`

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

### Estimated costs (approximate)

```sql
SELECT model,
       SUM(input_tokens) / 1000000.0 * 3.0 as input_cost,
       SUM(output_tokens) / 1000000.0 * 15.0 as output_cost,
       (SUM(input_tokens) / 1000000.0 * 3.0) +
       (SUM(output_tokens) / 1000000.0 * 15.0) as total_cost
FROM messages
WHERE model LIKE '%opus%'
GROUP BY model;
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

If you have mcp-sqlite-tools configured, Claude can query this database directly:

1. Open the database: `open_database ~/.claude/cclog.db`
2. Run any query above
3. Ask Claude to analyze patterns

## GitHub

https://github.com/spences10/cclog
