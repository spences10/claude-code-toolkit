# Reset Prompts

Break out of local optima. Force fresh thinking.

## Core Prompts

### "Scrap this and implement the elegant solution"

Abandons sunk cost, starts fresh:

- Forget current approach entirely
- Consider the problem from scratch
- Often finds 10x simpler solution

**Example exchange:**

````
User: [after 3 iterations of patching] Scrap this and implement the elegant solution

Claude: Looking at the actual requirement - you need rate limiting per user.

Delete all of this. Use express-rate-limit with a custom keyGenerator:

```js
const limiter = rateLimit({
  windowMs: 60_000,
  max: 100,
  keyGenerator: (req) => req.user?.id ?? req.ip
});
app.use('/api', limiter);
````

That's it. No custom middleware, no Redis complexity, no cleanup jobs.

```

### "You're overcomplicating this"

Direct simplification pressure:
- Removes unnecessary abstractions
- Cuts features to core need
- Questions each moving part

**Example exchange:**
```

User: You're overcomplicating this

Claude: You're right. Stripped down version:

- Removed the factory pattern (you have one implementation)
- Removed the event emitter (you only need the callback)
- Removed the retry logic (let the caller handle it)

From 145 lines to 23 lines. Same behavior.

```

### "What's the 80/20 version"

Ruthless scope cutting:
- What 20% delivers 80% of value
- Defer complexity to later
- Ship something now

**Example exchange:**
```

User: What's the 80/20 version

Claude: Drop these for v1:

- Custom themes (ship with one good default)
- CSV export (users can copy-paste from table)
- Batch operations (they can do one at a time)

This cuts 70% of the code and you ship this week instead of next month.

```

## Reset Signals

Use reset prompts when:
- You've iterated 3+ times on same code
- The solution keeps growing in complexity
- You feel like you're fighting the code
- Claude is patching patches

## Timing Matters

**Good timing:**
- Before implementation (during design)
- After first attempt fails
- When requirements change

**Bad timing:**
- Mid-implementation (wastes tokens)
- Near completion (sunk cost is real)
- When current approach is working

## Combining Resets

```

1. "Scrap this and implement the elegant solution"
2. [review new approach]
3. "What's the 80/20 version of this"
4. [implement stripped version]
5. "Prove to me this works"

```

## The Nuclear Option

When truly stuck:
```

Forget everything we've discussed. I need [core requirement].
What's the simplest possible implementation?

```

This resets Claude's context bias toward previous approaches.
```
