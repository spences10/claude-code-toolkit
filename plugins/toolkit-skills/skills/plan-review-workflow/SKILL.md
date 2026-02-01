---
name: plan-review-workflow
# prettier-ignore
description: Two-session plan review workflow. Use when complex changes need staff-level review before implementation.
---

# Plan Review Workflow

Separate planning from implementation using two sessions.

## When to Use

- Complex refactors affecting multiple files
- Architectural decisions with tradeoffs
- Changes requiring domain expertise validation
- When implementation keeps drifting from intent

## The Two-Session Pattern

### Session A: Planning

1. Enter plan mode: `/plan` or shift+tab
2. Describe the change, gather context
3. Claude produces detailed implementation plan
4. Export plan to markdown file

```
/plan
> Refactor auth to use JWT. Currently session-based in auth.ts.
```

Plan stays in plan mode until explicitly exited.

### Session B: Staff Review

Start fresh session. Load plan as context:

```
Review this plan as a staff engineer. Challenge assumptions,
identify risks, suggest alternatives.

[paste or reference plan file]
```

Use challenge prompts from [staff-review.md](references/staff-review.md).

## Decision: Iterate or Implement

After review:

| Signal                | Action                           |
| --------------------- | -------------------------------- |
| Major gaps identified | Return to Session A, revise plan |
| Minor clarifications  | Note in plan, proceed            |
| Plan approved         | Exit plan mode, implement        |

## Drift Recovery

When implementation diverges from plan:

1. Stop implementation
2. Re-enter plan mode: `/plan`
3. Compare current state to original plan
4. Update plan or reset approach

See [drift-recovery.md](references/drift-recovery.md) for patterns.

## Commands Reference

See [plan-commands.md](references/plan-commands.md) for full command list.

## References

- [staff-review.md](references/staff-review.md) - Review prompts and criteria
- [plan-commands.md](references/plan-commands.md) - Plan mode commands
- [drift-recovery.md](references/drift-recovery.md) - Handling implementation drift
