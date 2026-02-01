# Verification Prompts

Demand evidence over assertions. Prevent hand-waving.

## Core Prompts

### "Prove to me this works"

Forces Claude to demonstrate, not claim:

- Run tests and show output
- Show diffs with before/after
- Execute and capture results

**Example exchange:**

```
User: Prove to me this works

Claude: Running the test suite:
$ npm test -- --grep "auth"
✓ redirects unauthenticated users (23ms)
✓ preserves return URL in redirect (18ms)
✓ handles expired tokens (31ms)

Here's the actual diff in behavior:
Before: 401 response, no redirect
After: 302 to /login?return=/dashboard
```

### "Show me the before/after"

Concrete comparison prevents vague claims:

- Code diffs
- Output diffs
- Behavior differences

**Example exchange:**

````
User: Show me the before/after

Claude:
**Before (line 45-52):**
```js
const data = await fetch(url);
const json = await data.json();
return json;
````

**After:**

```js
const data = await fetch(url, {
  signal: AbortSignal.timeout(5000),
});
if (!data.ok) throw new HttpError(data.status);
return data.json();
```

**Behavior change:** Timeout after 5s instead of hanging. Non-2xx now throws.

```

### "Walk through this line by line"

Prevents skipped complexity:
- Forces explanation of each step
- Exposes assumptions
- Catches logic errors

**Example exchange:**
```

User: Walk through this line by line

Claude:

- L1: `const cache = new Map()` - In-memory cache, cleared on restart
- L2: `const TTL = 60_000` - 60 second expiry, might be too short for your use case
- L3: `function get(key)` - Synchronous lookup, blocks if slow
- L4: `const entry = cache.get(key)` - Returns undefined if missing
- L5: `if (!entry) return null` - Caller must handle null, not undefined
- L6: `if (Date.now() > entry.exp)` - Clock skew could cause issues

```

## Verification Triggers

Use when Claude says:
- "This should work" → "Prove it"
- "This handles edge cases" → "Show me which ones"
- "This is more efficient" → "Show me the benchmark"
- "This fixes the bug" → "Show me before/after"

## Combining with Tests

```

User: Prove to me this works

Claude: I'll add a test and run it:
[writes test]
[runs test]
[shows passing output]

The existing tests also pass:
[shows test output]

```

## Anti-Pattern: Premature Verification

Don't demand proof for:
- Obvious changes (renaming, formatting)
- Standard library usage
- Changes you can verify yourself in 10 seconds
```
