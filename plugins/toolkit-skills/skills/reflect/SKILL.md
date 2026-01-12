---
name: reflect
# prettier-ignore
description: Analyze session history for learnings and persist to skills. Solves "memory zero" - correct once, never again.
---

# Reflect

Extract learnings from sessions and persist to skill files.

## When to Reflect

Run `/reflect` after sessions with:

- **Corrections** - "actually use X", "no, do it this way"
- **Discoveries** - patterns that worked well
- **Failures** - approaches that didn't work

## Usage

### Manual Mode

```
/reflect              # Analyze current session, suggest skill updates
/reflect skill-name   # Target specific skill for updates
```

### Automatic Mode

Enable Stop hook to auto-reflect on session completion (see hooks/).

## Process

1. **Query** - Read recent conversation from cclog.db
2. **Analyze** - Find corrections, successes, patterns
3. **Classify** - High/Medium/Low confidence learnings
4. **Propose** - Show suggested skill updates
5. **Approve** - Wait for user confirmation before writing

## Destination Logic

- In repo with `.claude-plugin/` → update skill in-place
- Otherwise → prompt: project `.claude/skills/` or global `~/.claude/skills/`

## References

- [analysis-patterns.md](references/analysis-patterns.md) - Pattern detection rules
