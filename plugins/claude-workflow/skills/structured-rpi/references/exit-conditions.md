# Exit Conditions

When to skip phases, go back, or exit the workflow entirely.

## When to Skip Phases

| Phase | Skip When |
| --- | --- |
| 1 - Questions | User's request is specific and unambiguous |
| 2 - Research | You already have full context (small scope, familiar code) |
| 3 - Design | Only one viable approach exists |
| 4 - Outline | Change is a single file or the plan is simple enough to imply structure |
| 5 - Plan | User says "just do it" — create a minimal mental plan and proceed |

When skipping, briefly state what you're skipping and why:

```text
Skipping Phase 1 (Questions) — requirements are clear from your description.
Moving to Phase 2 (Research).
```

## When to Go Back

Return to a previous phase when:

- **New information invalidates a decision** — e.g., research reveals a constraint that changes the design
- **User changes requirements** — re-enter at the earliest affected phase
- **Implementation hits a wall** — go back to Design (Phase 3) if the approach doesn't work

When going back, state what changed and which phase you're re-entering:

```text
Returning to Phase 3 (Design) — the chosen approach won't work because X.
```

## When the Workflow Doesn't Apply

Don't use Structured RPI for:

- **Simple bug fixes** — Known cause, known fix. Just do it.
- **One-line changes** — No phases needed.
- **Pure questions** — User asking "how does X work?" doesn't need a workflow.
- **Exploratory tasks** — "Look around and tell me what you find" is research, not RPI.
- **Urgent hotfixes** — Speed matters more than process.

## When to Abort

Stop the workflow if:

- User says "stop" or "abort" or "never mind"
- The task turns out to be trivial mid-workflow
- Requirements change so fundamentally that restarting is better than continuing

When aborting, summarize what was learned so the context isn't lost:

```text
Aborting workflow. Key findings so far:
- X depends on Y
- The main risk is Z
```

## Compressing the Workflow

For medium-complexity tasks, compress phases:

- **Phases 1+2** — Ask questions while researching (present findings + remaining questions together)
- **Phases 3+4** — Present design and outline together when there's one clear approach
- **Phases 5+6** — For small implementations, the plan can be "here's what I'll do" followed immediately by doing it (with user approval)
