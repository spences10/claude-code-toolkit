# Mocking Guidance

## The Rule

Use real dependencies when you can. Mock at system boundaries when you must.

## What to Mock

- **Network calls** — HTTP APIs, gRPC services, WebSocket connections
- **Databases** — unless you have a fast local instance for integration tests
- **File system** — when tests would create real files with side effects
- **Time** — when behavior depends on current time, timers, or delays
- **Randomness** — when you need deterministic output
- **Third-party services** — payment processors, email providers, auth services

## What NOT to Mock

- **Your own code** — if you mock your own modules, you're testing wiring not behavior
- **Data transformations** — pure functions that take input and return output
- **Utility functions** — these are fast and deterministic already
- **Standard library** — trust the language runtime

## Types of Test Doubles

### Stubs

Return canned responses. Use when you need a dependency to return specific data.

```
const getUser = stub().returns({ id: 1, name: "Alice" })
```

### Spies

Record calls while executing real behavior. Use when you want to verify something was called without changing behavior.

```
const spy = spyOn(logger, "warn")
doThing()
expect(spy).toHaveBeenCalledWith("deprecation notice")
```

### Fakes

Simplified working implementations. Use for complex dependencies where stubs are insufficient. Example: an in-memory database that supports basic queries.

### Mocks

Doubles with built-in assertions about how they're called. Use sparingly — they couple tests to implementation details.

## Mock Pitfalls

- **Mock drift** — the mock stops matching the real dependency's behavior. Periodically run integration tests against the real thing.
- **Over-mocking** — every dependency mocked means you're testing your test setup, not your code. If a test has more mock setup than assertions, reconsider.
- **Mocking what you don't own** — wrap third-party APIs in your own adapter, then mock the adapter. This gives you a stable interface to mock.

## Integration vs Unit

Not every test needs to be a fast unit test. A small number of integration tests with real dependencies catches the gaps that unit tests with mocks miss. Balance speed with confidence.
