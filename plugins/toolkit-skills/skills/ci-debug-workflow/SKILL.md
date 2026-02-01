# CI Debug Workflow

Debug failing CI pipelines, containers, and reproduce bugs locally.

## Trigger Patterns

- "fix failing CI"
- "debug this pipeline"
- "why is CI red"
- "container won't start"
- "reproduce this bug"

## Workflow

### 1. Gather Context

Read CI logs first. Identify:

- Which step failed
- Error message/stack trace
- Environment differences from local

For bug reports, extract reproduction steps. See [bug-thread-extraction.md](references/bug-thread-extraction.md).

### 2. Reproduce Locally

Never fix blind. Reproduce failure before changing code:

```bash
# Run same commands CI runs
npm ci && npm test

# Or match CI environment
docker build -t debug-image .
docker run --rm debug-image npm test
```

### 3. Identify Root Cause

Common CI failure patterns in [ci-patterns.md](references/ci-patterns.md):

- Dependency version mismatches
- Missing environment variables
- Timing/race conditions
- Platform differences (Linux vs macOS)

Container issues in [docker-debug.md](references/docker-debug.md).

### 4. Apply Fix

Fix the actual issue, not symptoms:

- Pin dependency versions explicitly
- Add missing env vars to CI config
- Fix flaky tests with proper waits
- Use platform-agnostic paths

### 5. Verify

Push fix and confirm CI passes. Do not mark done until green.

```bash
git push && gh run watch
```

## Anti-patterns

- Rerunning CI hoping it passes
- Fixing locally without reproducing CI environment
- Disabling failing tests
- Adding broad `|| true` to mask failures

## References

- [ci-patterns.md](references/ci-patterns.md) - Common CI failure patterns
- [docker-debug.md](references/docker-debug.md) - Container troubleshooting
- [bug-thread-extraction.md](references/bug-thread-extraction.md) - Parse bug reports
