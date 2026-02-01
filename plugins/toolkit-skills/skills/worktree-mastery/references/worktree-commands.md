# Worktree Commands

## Create Worktrees

```bash
# Create from current branch
git worktree add ../repo-name-suffix

# Create from specific branch
git worktree add ../repo-review main

# Create with new branch
git worktree add -b feature-x ../repo-feature main

# Create detached (no branch)
git worktree add --detach ../repo-experiment HEAD
```

## List and Inspect

```bash
# List all worktrees
git worktree list

# Verbose output with branch info
git worktree list --porcelain
```

## Lock/Unlock

Prevent accidental removal:

```bash
# Lock a worktree
git worktree lock ../repo-important

# Unlock when done
git worktree unlock ../repo-important

# Lock with reason
git worktree lock --reason "Long-running refactor" ../repo-refactor
```

## Move Worktrees

```bash
# Relocate worktree directory
git worktree move ../old-path ../new-path
```

## Repair

Fix broken worktree references:

```bash
# Repair all worktrees
git worktree repair

# Repair specific path
git worktree repair ../broken-worktree
```

## Common Patterns

### Parallel Feature Development

```bash
git worktree add -b feature-a ../repo-feature-a main
git worktree add -b feature-b ../repo-feature-b main
```

### Quick PR Review

```bash
git worktree add ../repo-pr-123 origin/pr-branch
# Review, then remove
git worktree remove ../repo-pr-123
```

### Experimental Work

```bash
git worktree add --detach ../repo-experiment HEAD
# Experiment freely
# Discard or cherry-pick results
git worktree remove --force ../repo-experiment
```
