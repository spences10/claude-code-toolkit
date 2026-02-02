---
name: reflect
# prettier-ignore
description: Analyze session history for learnings and persist to skills. Solves "memory zero" - correct once, never again.
# sqlite tools optional - falls back to in-context analysis
allowed-tools: [Read, Write, Edit, Grep, Glob]
---

# Reflect

Extract learnings from sessions and persist to skill files.

## When to Reflect

Run `/reflect` after sessions with:

- **Corrections** - "actually use X", "no, do it this way"
- **Discoveries** - patterns that worked well
- **Failures** - approaches that didn't work

## Usage

```
/reflect              # Analyze current session, suggest skill updates
/reflect skill-name   # Target specific skill for updates
```

**Note:** This is manual-only. Run before ending sessions with learnings.

## Why Manual-Only?

Auto-detection via Stop hooks doesn't work reliably:

| Issue  | Problem                                        |
| ------ | ---------------------------------------------- |
| #16227 | Stop hook output is silent (not shown to user) |
| #10412 | Plugin Stop hooks fail with exit code 2        |
| #10875 | Plugin JSON output not captured                |
| #3656  | Blocking functionality partially removed       |

Stop hooks fire but can't communicate back - making them useless for reminders. Other self-improving skill implementations (autoskill, reflect-skill) also use manual triggering for this reason.

## Process

1. **Source** - Determine conversation source (see Data Sources below)
2. **Analyze** - Find corrections, successes, patterns
3. **Classify** - High/Medium/Low confidence learnings
4. **Propose** - Show suggested skill updates
5. **Approve** - Wait for user confirmation before writing

## Data Sources

Try sources in order, use first available:

### 1. ccrecall.db (Full History)

If user has [ccrecall](https://github.com/spences10/ccrecall) + mcp-sqlite-tools:

```sql
SELECT timestamp, role, content FROM messages
WHERE session_id = (SELECT MAX(session_id) FROM sessions)
ORDER BY timestamp DESC LIMIT 100;
```

### 2. In-Context (Current Session)

Fallback when ccrecall unavailable:

- Analyze conversation visible in current context window
- Limited to ~100k tokens of recent history
- Still effective for single-session learnings

**Note which mode is active:**

```
[reflect] Using: ccrecall.db (full history)
-- or --
[reflect] Using: in-context (current session only)
```

## Destination Logic

- In repo with `.claude-plugin/` → update skill in-place
- Otherwise → prompt: project `.claude/skills/` or global `~/.claude/skills/`

## References

- [analysis-patterns.md](references/analysis-patterns.md) - Pattern detection rules
