# Bug Thread Extraction

Extract actionable reproduction steps from bug reports and threads.

## Extraction Process

### 1. Identify Key Elements

Scan for:

- **Steps to reproduce** - numbered lists, "when I...", "after..."
- **Expected vs actual** - "should", "but instead", "expected"
- **Environment** - versions, OS, browser, config
- **Error output** - stack traces, logs, screenshots

### 2. Filter Noise

Skip:

- Unrelated discussion
- Duplicate reports
- Workarounds (note separately)
- Speculation without evidence

Focus on:

- Original report
- Confirmed reproductions
- Maintainer responses with clarification

### 3. Normalize Steps

Convert prose to concrete steps:

**Before:**

> So I was trying to do X and then clicked the button and it broke

**After:**

```
1. Navigate to /settings
2. Click "Save" button
3. Observe error in console
```

## Common Bug Report Sources

### GitHub Issues

```bash
gh issue view <number>
gh issue view <number> --comments
```

### CI Failure Threads

Look for:

- Failed step name
- Full error output
- Commit that introduced failure

### Slack/Discord Threads

Extract:

- Initial problem statement
- Any shared logs/screenshots
- Resolution if found

## Structured Output Template

```markdown
## Summary

[One-line description]

## Environment

- OS:
- Version:
- Config:

## Steps to Reproduce

1.
2.
3.

## Expected

[What should happen]

## Actual

[What happens instead]

## Error Output
```

[paste logs/trace]

```

## Notes
- [Related issues]
- [Known workarounds]
```

## Verification Checklist

Before fixing:

- [ ] Can reproduce locally
- [ ] Same error as reported
- [ ] Minimal reproduction (no extra steps)
- [ ] Environment matches report

## Red Flags

Watch for:

- "Works on my machine" - environment delta
- "Sometimes fails" - race condition or flaky test
- "Stopped working after update" - check git blame
- Multiple users, different symptoms - multiple bugs
