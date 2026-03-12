# Refactoring Under Green Tests

## The Safety Net

Refactoring means changing code structure without changing behavior. Green tests prove behavior is preserved. Never refactor with failing tests — you won't know if you broke something or if it was already broken.

## When to Refactor

Refactor during the "refactor" step of red-green-refactor, specifically:

- **After making a test green** — clean up the code you just wrote
- **Before starting a new test** — if existing code is messy enough to slow you down
- **At the end of a TDD session** — final cleanup pass

## What to Refactor

### Remove Duplication

If the same logic appears in multiple places after a few TDD cycles, extract it. But wait until you have at least three instances — premature extraction creates the wrong abstraction.

### Improve Names

After understanding the domain better through TDD cycles, rename variables, functions, and modules to reflect what you now know.

### Simplify Conditionals

Nested if/else chains that grew during TDD can often be simplified into guard clauses, lookup tables, or polymorphism.

### Extract Functions

When a function does too many things, extract focused helpers. Each helper should be testable through the parent's public interface.

### Consolidate Test Setup

After several tests, you'll see repeated setup. Extract shared fixtures or builder functions. But keep each test's unique setup visible in the test itself.

## What NOT to Refactor

- Code that isn't related to what you're currently building
- Tests that are passing and readable (don't over-engineer test infrastructure)
- Performance optimizations (profile first, optimize later, separate from TDD)

## The Refactoring Loop

1. Run tests — confirm green
2. Make one structural change
3. Run tests — confirm still green
4. Repeat or stop

Keep changes small. If tests go red, undo immediately — the change was wrong.

## Knowing When to Stop

Refactoring has diminishing returns. Stop when:
- Code reads clearly to someone new
- There's no obvious duplication
- Functions have single responsibilities
- You're about to add a feature nobody asked for
