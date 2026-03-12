# Review Workflow

How to present deslop findings interactively.

## Pre-Review Summary

Before presenting individual findings, show an overview:

```
## Deslop Scan Results

Scoped to: staged changes (or: last 2 commits, specific files)
Files scanned: 8
Findings: 15

By severity:
  High:   7 (safe to remove)
  Medium: 5 (likely unnecessary)
  Low:    3 (confirm with user)

By pattern:
  Unnecessary comments:      5
  Verbose docstrings:        3
  Redundant type annotations: 3
  Over-engineered errors:    2
  Filler summaries:          2

Proceed with review? [y/n]
```

## Presentation Order

Present findings grouped by file, ordered by severity within each file:

1. **High severity first** — builds trust by showing clear wins
2. **Medium severity** — user sees the value, more willing to review
3. **Low severity last** — requires most judgment

Within the same file, present findings in line-number order so the user can follow the code flow.

## Individual Finding Format

Each finding must include:

```
## Finding 3/15 — Unnecessary Comment (High)
File: src/services/auth.ts:42

Current (lines 42-43):
│ // Check if the user is authenticated
│ if (!req.user) {

Suggested:
│ if (!req.user) {

Remove? [y/n/skip-type]
```

### Required elements:

- **Counter** (3/15) — progress indicator
- **Pattern name** — which slop pattern matched
- **Severity** — High/Medium/Low
- **File and line** — exact location
- **Current code** — the slop in context (show 1-2 surrounding lines)
- **Suggested code** — what it looks like after removal
- **Action prompt** — user chooses what to do

## User Actions

| Input | Meaning |
| ----- | ------- |
| y | Remove this instance |
| n | Keep this instance |
| skip-type | Skip all remaining findings of this pattern type |
| stop | End review, apply approved changes so far |

## Context Rules

### Show enough context

Always show at least 1 line above and below the slop so the user can judge whether the comment/code is actually unnecessary in context.

### Borderline cases

For Medium and Low severity findings, add a brief note explaining why it was flagged:

```
## Finding 8/15 — Excessive Validation (Medium)
File: src/handlers/order.ts:15-22

Note: This validation duplicates the schema check in middleware (line 8).

Current (lines 15-22):
│ if (!order.id) {
│   throw new Error("Order ID required");
│ }
│ if (!order.items?.length) {
│   throw new Error("Order must have items");
│ }

Suggested:
│ (remove — validated by orderSchema middleware)

Remove? [y/n/skip-type]
```

### Multi-line removals

For findings spanning multiple lines (verbose docstrings, error handling blocks), show the full block being removed and the simplified replacement.

## Applying Changes

After review completes (or user says "stop"):

1. Apply all approved removals in reverse line-number order (bottom-up) to avoid line number shifts
2. Show summary of what was changed

## Post-Review Summary

```
## Deslop Complete

Files modified: 5
Findings reviewed: 15
  Approved: 10
  Skipped: 3
  Skip-type: 2 (redundant type annotations)
Lines removed: 34

Modified files:
  src/services/auth.ts (-8 lines)
  src/handlers/order.ts (-12 lines)
  src/utils/format.ts (-6 lines)
  src/models/user.ts (-4 lines)
  src/config/database.ts (-4 lines)
```

## Language-Agnostic Approach

The patterns apply across languages. When scanning:

- Adapt comment syntax detection to the file's language (// vs # vs /* */ vs --)
- Adapt type annotation detection to the language's type system
- Adapt docstring detection to language conventions (JSDoc, Python docstrings, Go doc comments, Javadoc)
- Don't flag patterns that are idiomatic in a specific language (e.g., Go error handling is verbose by design, not slop)
