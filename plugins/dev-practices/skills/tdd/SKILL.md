---
name: tdd
# prettier-ignore
description: Test-Driven Development workflow with red-green-refactor cycle. Use only when explicitly asked for TDD, not for general test writing.
---

# Test-Driven Development

Drive implementation through tests using the red-green-refactor cycle.

> Adapted from [Matt Pocock's TDD skill](https://github.com/mattpocock/skills)

## Trigger Patterns

- "use TDD"
- "TDD this feature"
- "red-green-refactor"
- "test-driven"
- "write tests first"

**Do not activate** for general "write tests for X" or "add test coverage" requests. This skill is specifically for the TDD workflow where tests lead implementation.

## Philosophy

Test behavior, not implementation. Every test should verify what the code *does* from the outside, not how it works inside. See [deep-modules.md](references/deep-modules.md) for the reasoning behind this.

Good tests act as a contract: they define what the module promises to its callers. If you can swap the internals completely and your tests still pass, they're testing the right thing.

## Workflow

### 1. Plan the Interface

Before writing any code, decide the public surface area:

- What functions/methods/endpoints will exist?
- What are the inputs and outputs?
- What are the edge cases and error conditions?

Design for the caller, not the implementation. See [interface-design.md](references/interface-design.md).

### 2. Write a Tracer Bullet Test

Start with one test that exercises the simplest meaningful path through the feature. This test should:

- Call the public API as a real consumer would
- Assert the most basic expected output
- **Fail** — because the implementation doesn't exist yet

```
RED: test exists, code does not
```

Run the test. Confirm it fails for the right reason (missing function, wrong return value — not a syntax error).

### 3. Make It Green

Write the **minimum** code to pass that one test. Do not write more than what the test demands. Hardcode return values if that's all it takes. The goal is a green test suite, not elegant code.

```
GREEN: test passes with minimal implementation
```

### 4. Refactor Under Green

With the test passing, clean up. Remove duplication, improve names, extract helpers — but only while tests stay green. See [refactoring.md](references/refactoring.md).

```
REFACTOR: improve code quality, tests still pass
```

### 5. Repeat

Add the next test. Pick the next simplest behavior that isn't covered. Follow the same cycle:

1. Write a failing test
2. Make it pass with minimal code
3. Refactor while green

Build up complexity incrementally. Each cycle should take minutes, not hours.

### 6. Handle Edge Cases

After the core behavior works, add tests for:

- Invalid inputs and error conditions
- Boundary values
- Empty/null/undefined cases
- Concurrent access if relevant

### 7. Final Refactor

Once all behavior is covered, do a final pass:

- Look for patterns across tests — consolidate setup with helpers
- Check that test names clearly describe the behavior being verified
- Ensure no test depends on another test's state
- Review implementation for unnecessary complexity

## When to Mock

Use real dependencies when practical. Mock only at system boundaries — network calls, databases, file systems, clocks. See [mocking.md](references/mocking.md) for detailed guidance.

## Test Quality

Write tests that are readable, independent, and fast. See [tests.md](references/tests.md) for patterns on naming, structure, and assertion style.

## Anti-patterns

- Writing implementation before the test (defeats the purpose)
- Writing multiple tests before making any pass (too much red)
- Skipping the refactor step (accumulates mess)
- Testing private methods or internal state
- Making tests pass by weakening assertions
- Mocking everything instead of testing real behavior

## References

- [deep-modules.md](references/deep-modules.md) - Why to test surface area, not internals
- [interface-design.md](references/interface-design.md) - Contract-first design
- [mocking.md](references/mocking.md) - When and how to use test doubles
- [refactoring.md](references/refactoring.md) - Safe refactoring under green tests
- [tests.md](references/tests.md) - Test structure, naming, and assertions
