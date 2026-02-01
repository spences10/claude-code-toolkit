# Challenge Prompts

Force Claude out of agreement mode into critical analysis.

## Core Prompts

### "Grill me on these changes"

Triggers adversarial code review. Claude will:

- Question architectural decisions
- Point out edge cases you missed
- Challenge naming/abstraction choices

**Example exchange:**

```
User: [shares PR diff] Grill me on these changes

Claude: Three concerns:
1. This mutex pattern won't survive concurrent writes - line 47 releases before the callback
2. Why a custom retry loop when you have `p-retry` in package.json?
3. `processData` does 4 things - extract the validation into its own function
```

### "What would a 10x engineer do differently"

Surfaces patterns you might not know:

- Better stdlib/library usage
- Idiomatic approaches for the language
- Performance patterns

**Example exchange:**

```
User: [shares function] What would a 10x engineer do differently

Claude: Three changes:
1. Replace the loop with `Object.fromEntries(arr.map(x => [x.id, x]))`
2. This is a textbook case for memoization - add `useMemo` around line 23
3. The early returns are good but consider guard clauses at function entry
```

### "Find 3 ways this could fail"

Adversarial testing mindset:

- Race conditions
- Edge cases (empty, null, huge)
- External dependency failures

**Example exchange:**

```
User: [shares API handler] Find 3 ways this could fail

Claude:
1. No timeout on the fetch - hangs forever if upstream is slow
2. `user.email` accessed without null check after line 12's early return
3. Rate limit response (429) treated as success - will corrupt cache
```

## Combining Patterns

Chain for thorough review:

```
1. "Grill me on these changes"
2. [address feedback]
3. "Find 3 ways this could still fail"
4. [address feedback]
5. "What would a 10x engineer do differently"
```

## When NOT to Use

- Trivial changes (config updates, typo fixes)
- When you need encouragement, not critique
- Time-sensitive fixes (challenge after shipping)
