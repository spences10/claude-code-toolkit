# Cleanup

## Remove Worktrees

```bash
# Remove worktree (fails if uncommitted changes)
git worktree remove ../repo-review

# Force remove (discards changes)
git worktree remove --force ../repo-scratch
```

## Prune Stale References

After manually deleting worktree directories:

```bash
# Clean up stale worktree metadata
git worktree prune

# Dry run first
git worktree prune --dry-run

# Verbose output
git worktree prune -v
```

## Full Cleanup Script

```bash
#!/bin/bash
# cleanup-worktrees.sh

# List current worktrees
echo "Current worktrees:"
git worktree list

# Remove all non-main worktrees
for wt in $(git worktree list --porcelain | grep "^worktree" | cut -d' ' -f2); do
  if [[ "$wt" != "$(pwd)" ]]; then
    echo "Removing: $wt"
    git worktree remove --force "$wt" 2>/dev/null || true
  fi
done

# Prune stale references
git worktree prune -v

echo "Remaining:"
git worktree list
```

## Cleanup Checklist

Before removing worktrees:

- [ ] Commit or stash valuable changes
- [ ] Push branches you want to keep
- [ ] Check for untracked files worth saving

## Disk Space Recovery

Worktrees share `.git` but duplicate working files.

```bash
# Check worktree sizes
du -sh ../project-*

# After removal, git gc for full cleanup
git gc --prune=now
```

## Troubleshooting

### "worktree is locked"

```bash
git worktree unlock ../locked-worktree
git worktree remove ../locked-worktree
```

### "not a valid worktree"

Directory deleted manually. Prune metadata:

```bash
git worktree prune
```

### Branch still exists after removal

Worktree removal doesn't delete branches:

```bash
# Delete local branch after worktree removal
git branch -d feature-branch

# Force delete if unmerged
git branch -D feature-branch
```
