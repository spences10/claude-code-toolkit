# Staff Review Prompts

Challenge prompts for reviewing plans as a staff engineer.

## Opening Review

```
Review this implementation plan as a staff engineer.
Your job: find gaps, challenge assumptions, identify risks.
Be critical - better to catch issues now than during implementation.

[plan content]
```

## Challenge Categories

### Scope & Requirements

- What requirements are assumed but not stated?
- What edge cases aren't covered?
- Is scope creep hiding in "nice to haves"?

### Architecture

- Why this approach over alternatives?
- What are the tradeoffs?
- How does this affect existing patterns?
- Will this scale with current growth trajectory?

### Risk Assessment

- What's the blast radius if this fails?
- What's the rollback strategy?
- Are there dependencies that could block this?
- What's the testing strategy?

### Implementation Concerns

- Is the ordering correct?
- Are there hidden dependencies between steps?
- What could cause mid-implementation blocking?
- Is there a simpler approach?

## Targeted Challenges

### For Refactors

```
This refactor touches [N] files. Walk me through:
1. How you'll maintain working state between commits
2. What tests verify behavior didn't change
3. Your strategy if you discover a blocker mid-refactor
```

### For New Features

```
Before building, answer:
1. How will users discover this feature?
2. What happens when it fails?
3. How do we measure if it's working?
```

### For Performance Changes

```
Show me:
1. Current measurements (not assumptions)
2. Target metrics
3. How you'll verify improvement
```

## Review Output Format

After review, structure feedback as:

```
## Must Address (Blocking)
- [issue]: [why it blocks]

## Should Address (Important)
- [issue]: [risk if ignored]

## Consider (Nice to Have)
- [suggestion]: [benefit]

## Approved Aspects
- [what looks good and why]
```

## Iteration Decision

| Blocking issues | Action                           |
| --------------- | -------------------------------- |
| 0               | Proceed to implementation        |
| 1-2             | Address in plan, quick re-review |
| 3+              | Major revision needed            |
