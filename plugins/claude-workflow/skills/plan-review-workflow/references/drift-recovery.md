# Drift Recovery

Patterns for when implementation diverges from plan.

## Detecting Drift

Signs you've drifted:

- "I'll just quickly add this" (scope creep)
- "This approach isn't working, let me try..." (unplanned pivots)
- Lost track of which step you're on
- Files being modified that weren't in plan
- Test strategy abandoned "for now"

## Immediate Response

When drift detected:

1. **Stop** - Don't continue implementation
2. **Commit** - Save current working state
3. **Assess** - How far from plan?

```
git add -A && git commit -m "WIP: checkpoint before reassessing"
```

## Recovery Patterns

### Minor Drift: Update Plan

Current state is fine, just document it:

```
/plan
> Implementation deviated from original plan.
> Original: [approach]
> Current: [what actually happened]
> Update the plan to reflect current state and path forward.
```

### Major Drift: Reset to Plan

Current approach is wrong:

```
/plan
> Implementation isn't working. Current state:
> [describe mess]
>
> Original plan goal: [goal]
>
> Options:
> 1. Reset to last good commit, try plan again
> 2. Salvage current work, new plan
> 3. Abandon approach entirely
>
> Recommend best path.
```

### Scope Creep: Defer

Found something that "should" be fixed:

```
# Don't fix it now. Note it:
echo "TODO: [discovered issue]" >> docs/backlog.md
git add docs/backlog.md
git commit -m "note: discovered issue during auth refactor"

# Continue with plan
```

## Prevention

### Checkpoint Commits

After each plan step:

```bash
git add -A && git commit -m "step N: [description from plan]"
```

### Explicit Step Transitions

Before each step:

```
Starting step 3 of plan: "Add JWT validation middleware"
Files to modify: src/middleware/auth.ts
Expected outcome: [from plan]
```

### Timebox Exploration

When exploring during implementation:

```
Spending 10 minutes to understand [thing].
If not resolved, will return to plan and ask for help.
```

## When to Abandon Plan

Restart planning if:

- Core assumption was wrong
- Discovered blocking constraint
- Scope grew 2x+
- Better approach became obvious

```
/plan
> Abandoning current plan. Learned:
> - [what we discovered]
> - [why original won't work]
>
> New constraints: [updated constraints]
> Create new plan with this knowledge.
```
