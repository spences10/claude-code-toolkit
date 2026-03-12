---
name: deslop
# prettier-ignore
description: Identify and remove AI-generated code patterns (slop). Use when asked to clean up AI-generated code, remove unnecessary comments, or deslop.
---

# Deslop

Identify and remove AI-generated verbosity patterns from code.

## Trigger Patterns

- "/deslop"
- "clean up AI-generated code"
- "remove slop"
- "too much AI verbosity"
- "remove unnecessary comments"

## What This Is NOT

- **Not techdebt-finder** — techdebt finds structural issues to refactor. Deslop finds AI verbosity to delete.
- **Not simplify** — simplify reviews code for reuse/quality. Deslop targets specific AI generation patterns.

## Scope

Target **recent or staged changes only**, not the whole codebase:

```bash
# Check staged changes
git diff --cached --name-only

# Check recent commits (default: last commit)
git diff HEAD~1 --name-only
```

If the user doesn't specify scope, ask: staged changes or last N commits?

## Workflow

### 1. Determine Scope

Identify which files to scan:

- Staged files (`git diff --cached`)
- Recent commits (`git diff HEAD~N`)
- Specific files if user provides them

Only scan code files. Skip markdown, docs, and config files.

### 2. Scan for Slop Patterns

Read each file in scope. Apply the 10 detection patterns from [slop-patterns.md](references/slop-patterns.md).

For each match, record:

- File and line number
- Pattern type
- The offending code
- Suggested removal/replacement

### 3. Classify Findings

Group by severity:

| Severity | Description | Examples |
| -------- | ----------- | ------- |
| High | Pure noise, safe to remove | Obvious comments, filler summaries |
| Medium | Likely unnecessary, review | Over-engineered error handling, verbose docstrings |
| Low | Possibly intentional, confirm | Extra validation, type annotations |

### 4. Present Findings

Show each finding **one at a time** for user review. Follow the workflow in [review-workflow.md](references/review-workflow.md).

Format:

```
## Finding 1/N — [pattern-type] (severity)
File: src/utils.ts:23-25

Current:
  // This function adds two numbers together and returns the result
  function add(a: number, b: number): number {

Suggested:
  function add(a: number, b: number): number {

Remove? [y/n/skip-all-of-type]
```

### 5. Apply Approved Removals

Only apply changes the user explicitly approves. Never auto-fix.

After all findings reviewed, show summary:

```
## Deslop Summary
- Reviewed: 15 findings
- Removed: 10
- Skipped: 5
- Lines removed: 34
```

## Anti-patterns

- Never auto-fix without user approval
- Never scan entire codebase unprompted
- Never remove comments that explain non-obvious logic
- Never touch markdown or documentation files
- Never remove license headers or legal comments

## References

- [slop-patterns.md](references/slop-patterns.md) - The 10 AI slop detection patterns
- [review-workflow.md](references/review-workflow.md) - Interactive review workflow
