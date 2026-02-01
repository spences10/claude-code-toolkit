---
name: techdebt-finder
# prettier-ignore
description: Find technical debt patterns in codebases. Use when asked to find duplicated code, inconsistent patterns, or refactoring opportunities.
allowed-tools: [Read, Grep, Glob, Bash]
---

# Tech Debt Finder

Identify duplicated code, inconsistent patterns, and refactoring opportunities.

## When to Use

- "Find duplicate code"
- "What needs refactoring?"
- "Are there inconsistent patterns?"
- Code review prep
- Pre-refactor analysis

## Detection Process

1. **Scan** - Grep for common debt indicators
2. **Cluster** - Group similar issues
3. **Prioritize** - Rank by frequency × impact
4. **Report** - Show findings with locations

## Quick Patterns

| Debt Type           | Detection Method               |
| ------------------- | ------------------------------ |
| Duplicated code     | Hash-compare function bodies   |
| Similar-but-diff    | Fuzzy match on structure       |
| Inconsistent naming | Regex for mixed conventions    |
| Dead code           | Unreferenced exports/functions |
| TODO/FIXME          | Grep for comment markers       |
| Magic numbers       | Literals outside const/config  |
| Long functions      | Line count > threshold         |
| Deep nesting        | Indentation level analysis     |

## Output Format

```
## Technical Debt Report

### High Priority (fix soon)
- [DUPLICATE] src/utils/format.ts:23 ↔ src/helpers/fmt.ts:45
  Similar: 87% | Impact: High (called 12 places)

### Medium Priority (plan for)
- [INCONSISTENT] Mixed naming: getUserData vs fetch_user
  Files: api.ts, service.ts, handler.ts

### Low Priority (track)
- [TODO] 23 TODO comments, oldest: 2023-01-15
```

## References

- [detection-patterns.md](references/detection-patterns.md) - Pattern matching rules
- [prioritization.md](references/prioritization.md) - Scoring and ranking
- [refactoring-strategies.md](references/refactoring-strategies.md) - Fix suggestions
