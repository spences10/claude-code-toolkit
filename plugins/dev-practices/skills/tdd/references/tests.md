# Test Structure and Patterns

## Test Naming

Test names should describe the behavior being verified, not the implementation being exercised.

### Good Names

```
"returns empty array when no items match filter"
"throws ValidationError when email is missing"
"applies discount before calculating tax"
```

### Bad Names

```
"test filter function"
"test error"
"test calculateTotal"
```

A good name answers: *what should happen* and *under what conditions*.

## Test Structure: Arrange-Act-Assert

Every test has three parts:

```
// Arrange — set up the scenario
const cart = createCart([{ item: "book", price: 10 }])

// Act — perform the action
const total = cart.checkout({ discount: 0.1 })

// Assert — verify the outcome
expect(total).toBe(9)
```

Keep these sections visually distinct. Avoid mixing arrange and act or act and assert.

## One Behavior Per Test

Each test should verify one thing. Multiple assertions are fine if they all verify aspects of the same behavior. But testing two separate behaviors in one test makes failures ambiguous.

### Good

```
"applies percentage discount to subtotal"
"rejects discount codes that have expired"
```

### Bad

```
"applies discount and rejects expired codes"
```

## Test Independence

Every test must pass or fail regardless of which other tests run, or in what order. No test should depend on state left behind by a previous test.

- Reset shared state in setup/teardown hooks
- Create fresh instances in each test
- Never rely on test execution order

## Assertion Patterns

### Be Specific

```
// Good — exact expectation
expect(result).toEqual({ status: "ok", count: 3 })

// Bad — too loose
expect(result).toBeTruthy()
expect(result).toBeDefined()
```

### Test Error Cases Explicitly

```
expect(() => divide(1, 0)).toThrow("Cannot divide by zero")
```

Don't just test that *something* throws — verify the right error with the right message.

### Avoid Snapshot Tests for Logic

Snapshots are useful for UI rendering. They're harmful for business logic because they encourage approving changes without understanding them.

## Test Hygiene

- **Fast** — each test under 100ms where possible. Slow tests get skipped.
- **Deterministic** — same input, same result, every time. No random data, no current time, no network.
- **Self-contained** — everything needed to understand the test is visible in the test body. Minimize indirection.
- **No logic in tests** — no if/else, no loops, no try/catch in test bodies. Tests should be straight-line code.

## Describe/Context Grouping

Group related tests to reduce duplication and improve readability:

```
describe("UserService.create", () => {
  describe("with valid input", () => {
    test("creates user and returns id", ...)
    test("sends welcome email", ...)
  })

  describe("with invalid input", () => {
    test("rejects missing email", ...)
    test("rejects duplicate username", ...)
  })
})
```

## Test Data

Use minimal test data. Only include fields relevant to the behavior being tested. Use factory functions or builders for complex objects.

```
const user = buildUser({ role: "admin" })  // only role matters for this test
```
