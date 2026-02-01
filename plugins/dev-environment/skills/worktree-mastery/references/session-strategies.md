# Session Strategies

## Recommended Setup: 3-5 Worktrees

Sweet spot for most projects. More adds overhead, fewer limits parallelism.

### Standard Configuration

```
project/              # Main: commits, primary work
project-review/       # Reviews: PRs, code reading
project-refactor/     # Heavy lifting: large changes
project-test/         # Testing: write tests, debug
project-scratch/      # Throwaway: experiments
```

## Session Isolation Benefits

Each Claude session in separate worktree:

- **No conflicts** - Different files, different branches
- **Context preserved** - Each session maintains own state
- **Safe experiments** - Trash one without affecting others
- **Parallel progress** - Review PR while feature develops

## Coordination Patterns

### Primary + Satellites

One main worktree for commits, others for auxiliary work.

```
[main]     ──commits──> origin
[review]   reads from main
[refactor] PRs back to main
```

### Feature Branches

Each worktree on different feature branch.

```
[main]        on main
[feature-a]   on feature-a branch
[feature-b]   on feature-b branch
```

### Review Pipeline

```
[dev]      Write code
[review]   Self-review before PR
[test]     Verify behavior
```

## Communication Between Sessions

Worktrees share git history. Coordinate via commits:

```bash
# Session A: commit work
git add . && git commit -m "WIP: feature progress"

# Session B: pull changes
git fetch && git rebase origin/main
```

## Context Switching

When moving between worktrees:

1. **Don't cd** - Open new terminal in worktree directory
2. **Separate shells** - One terminal per worktree
3. **Name terminals** - Match worktree names for clarity

## When NOT to Use Multiple Worktrees

- Tiny changes (single file edits)
- Sequential tasks (no parallelism benefit)
- Limited disk space (each worktree = full checkout)
