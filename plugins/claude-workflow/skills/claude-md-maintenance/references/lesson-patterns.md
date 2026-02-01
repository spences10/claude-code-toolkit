# Writing Effective Lessons

Rules that stick vs rules that waste tokens.

## Good Rule Anatomy

```markdown
- Don't X (actually Y because Z)
```

Three parts:

1. **What not to do** - the mistake
2. **What to do instead** - the fix
3. **Why** - brief context (optional but helpful)

## Examples

### Effective Rules

```markdown
- Don't use `any` type (use `unknown` for truly unknown values)
- Import db from `$lib/server/db`, not `$lib/db` (server-only)
- Run `pnpm generate` after schema changes (creates types)
```

### Ineffective Rules

```markdown
- Be careful with types
- Make sure imports are correct
- Remember to generate things
```

Too vague. No actionable fix.

## When to Add Rules

**Add after:**

- Correction: "No, use X instead"
- Second occurrence of same mistake
- Discovery: "This actually works because..."

**Don't add:**

- One-time fixes unlikely to recur
- Generic best practices (Claude knows)
- Rules requiring judgment calls

## Rule Lifecycle

```
Mistake → Add rule → Time passes → Review → Keep/Remove
```

**Remove when:**

- Dependency/API changed
- You internalized it (don't need reminder)
- Turned out to be wrong

## Specificity Spectrum

```
Too specific          Just right              Too vague
     |                    |                       |
"Fix line 42"     "Use X for auth"     "Be secure"
```

Aim for middle: specific enough to act on, general enough to apply.

## Grouping Related Rules

Bad:

```markdown
- Don't use `let` when `const` works
- Remember to handle null
- Use `??` not `||` for defaults
- Check array length before accessing
```

Better:

```markdown
## Type Safety

- Prefer `const`, use `let` only when reassigning
- Use `??` for nullish coalescing (`||` catches falsy values)
- Check array length before index access
```
