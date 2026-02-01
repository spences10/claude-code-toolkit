# Plan Mode Commands

Quick reference for plan mode operations.

## Entering Plan Mode

| Method            | Description       |
| ----------------- | ----------------- |
| `/plan`           | Slash command     |
| `shift+tab`       | Keyboard shortcut |
| "enter plan mode" | Natural language  |

## Exiting Plan Mode

| Method           | Description                   |
| ---------------- | ----------------------------- |
| `/implement`     | Exit and start implementation |
| `shift+tab`      | Toggle back                   |
| "exit plan mode" | Natural language              |

## Plan Mode Behavior

While in plan mode, Claude will:

- Gather context and analyze codebase
- Ask clarifying questions
- Propose approaches without executing
- Never modify files
- Never run commands with side effects

## Exporting Plans

Save plan to file for review:

```
Save this plan to docs/plans/auth-refactor-2024-01.md
```

Or copy from conversation for Session B review.

## Plan Structure

Good plans include:

```markdown
# [Change Title]

## Context

- Current state
- Why change needed
- Constraints

## Approach

1. Step with rationale
2. Step with rationale
   ...

## Files Affected

- path/to/file.ts - what changes

## Risks

- Risk: mitigation

## Testing Strategy

- How to verify

## Open Questions

- Unresolved decisions
```

## Common Patterns

### Incremental Planning

```
/plan
> Let's plan the database migration in phases.
> Phase 1 only - schema changes.
```

### Comparison Planning

```
/plan
> Compare two approaches for the cache layer:
> 1. Redis
> 2. In-memory with persistence
> Pros/cons for each, then recommend.
```

### Constraint-First Planning

```
/plan
> Refactor payments module.
> Constraints: zero downtime, no API changes, must be reviewable in <500 line PRs.
```
