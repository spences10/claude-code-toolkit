# CLAUDE.md Structure Guide

Organize for scannability. Claude reads this every request.

## Recommended Sections

### 1. Project Overview (Required)

```markdown
# Project Name

One-line purpose. Tech stack if non-obvious.
```

### 2. Key Commands

Most-used commands only:

```markdown
## Key Commands

- `pnpm dev` - start dev server
- `pnpm test` - run tests
- `pnpm build` - production build
```

Skip obvious ones (`git commit`, `npm install`).

### 3. Conventions

Project-specific patterns:

```markdown
## Conventions

- Components in `src/components/`, one per file
- Use `$state()` rune, not `writable()`
- API routes return `{ data, error }` shape
```

### 4. Architecture Notes

Only if non-obvious:

```markdown
## Architecture

- Auth handled by Clerk middleware
- DB queries go through `src/lib/db.ts`
- Feature flags in `src/config/flags.ts`
```

### 5. Mistakes to Avoid

Hard-won lessons:

```markdown
## Mistakes to Avoid

- Don't import from `$app/server` in client code
- Remember: `load` runs on both server and client
- Check `locals.user` exists before accessing properties
```

## Anti-Patterns

**Too verbose:**

```markdown
## Testing

When writing tests, make sure to use the Jest testing framework.
We use React Testing Library for component tests. Always import
from '@testing-library/react'. Remember to wrap async operations...
```

**Better:**

```markdown
## Testing

- Jest + React Testing Library
- Wrap state changes in `act()`
```

## Section Order

1. Overview (what is this)
2. Commands (how to run it)
3. Conventions (how to write code)
4. Architecture (where things live)
5. Mistakes (what to avoid)

Put most-referenced sections first.
