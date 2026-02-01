# CI Failure Patterns

## Dependency Issues

### Version Mismatch

```
Error: Cannot find module 'foo'
```

**Cause:** `package-lock.json` out of sync or missing.
**Fix:** Commit lockfile. Run `npm ci` not `npm install`.

### Peer Dependency Conflicts

```
npm WARN peer dep missing
```

**Fix:** Install peer deps explicitly or use `--legacy-peer-deps`.

### Cache Poisoning

**Symptom:** Works after cache clear.
**Fix:** Invalidate CI cache. Add cache key versioning.

## Environment Variables

### Missing Secrets

```
Error: API_KEY is not defined
```

**Fix:** Add secret to CI settings. Check secret name spelling.

### Wrong Environment

**Symptom:** Tests hit production API.
**Fix:** Set `NODE_ENV=test`. Mock external services.

## Timing Issues

### Race Conditions

**Symptom:** Intermittent failures. Passes on retry.
**Fix:** Add explicit waits. Use `waitFor()` in tests. Avoid `sleep()`.

### Timeouts

```
Error: Timeout of 5000ms exceeded
```

**Fix:** Increase timeout or fix slow operation. Check for hanging promises.

## Platform Differences

### Path Separators

```
Error: ENOENT /home/runner/work/foo\bar
```

**Fix:** Use `path.join()` not string concatenation.

### Line Endings

**Symptom:** Git shows all files changed.
**Fix:** Configure `.gitattributes`. Set `core.autocrlf`.

### Case Sensitivity

**Symptom:** Works on macOS, fails on Linux.
**Fix:** Match exact filename case in imports.

## Resource Limits

### Out of Memory

```
FATAL ERROR: CALL_AND_RETRY_LAST Allocation failed
```

**Fix:** Increase `NODE_OPTIONS=--max-old-space-size=4096`.

### Disk Space

```
ENOSPC: no space left on device
```

**Fix:** Clean artifacts between steps. Reduce build output.

## Debugging Commands

```bash
# View CI environment
env | sort

# Check available resources
free -h
df -h

# Verify installed versions
node -v && npm -v

# Test network connectivity
curl -I https://registry.npmjs.org
```
