---
name: claude-md-maintenance
# prettier-ignore
description: Maintain CLAUDE.md files effectively. Use when adding lessons learned, updating conventions, or restructuring project instructions.
allowed-tools: [Read, Write, Edit, Grep, Glob]
---

# CLAUDE.md Maintenance

Keep CLAUDE.md files lean, accurate, and useful.

## Core Pattern

After mistakes or discoveries:

```
"Update CLAUDE.md so you don't make that mistake again"
```

This captures learnings before context resets.

## When to Update

**Add rules when:**

- Same mistake happens twice
- Non-obvious convention discovered
- Critical project constraint identified

**Remove rules when:**

- Rule no longer applies (deps changed, pattern evolved)
- Duplicate or redundant with other rules
- Too specific (one-time fix, not pattern)

## Structure Template

```markdown
# Project Name

Brief purpose (1-2 lines).

## Key Commands

- `npm test` - run tests
- `npm run build` - production build

## Conventions

- Use X pattern for Y
- Always Z before committing

## Mistakes to Avoid

- Don't assume X (actually Y)
- Remember to check Z first
```

## Hierarchy

Two levels, both loaded:

| File                  | Scope        | Use For                               |
| --------------------- | ------------ | ------------------------------------- |
| `~/.claude/CLAUDE.md` | All projects | Personal preferences, global patterns |
| `.claude/CLAUDE.md`   | This repo    | Project conventions, tech stack rules |

Project-level overrides global when conflicting.

## Size Guideline

Keep under 500 lines. Claude scans on every request.

**Too long?** Extract to references:

```markdown
## API Patterns

See [api-patterns.md](docs/api-patterns.md) for details.
```

## References

- [structure-guide.md](references/structure-guide.md) - Section organization
- [lesson-patterns.md](references/lesson-patterns.md) - Writing effective rules
- [hierarchy.md](references/hierarchy.md) - Global vs project scope
