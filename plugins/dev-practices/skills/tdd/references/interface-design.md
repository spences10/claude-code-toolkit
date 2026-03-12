# Designing Testable Interfaces

## Contract-First Thinking

Before writing code, define the contract: what does this module accept, return, and guarantee?

A contract is:
- **Inputs** — what the caller provides (types, constraints, defaults)
- **Outputs** — what the caller gets back (shape, guarantees, invariants)
- **Errors** — what can go wrong and how the caller is told

Write your first test against this contract. The test documents the contract better than any comment.

## Design for the Caller

Ask "how do I want to call this?" before asking "how will I implement this?"

### Good: Caller-Friendly

```
const result = await sendEmail({ to: "user@example.com", subject: "Hello", body: "Hi there" })
// result: { sent: true, messageId: "abc-123" }
```

### Bad: Implementation-Leaking

```
const transport = new SmtpTransport({ host: "...", port: 587 })
const message = transport.createMessage()
message.setHeader("To", "user@example.com")
message.setHeader("Subject", "Hello")
message.setBody("text/plain", "Hi there")
const result = await transport.send(message)
```

## Keep Interfaces Narrow

Accept only what you need. Return only what the caller needs. Every extra parameter or return field is a commitment you have to maintain.

## Options Objects Over Long Parameter Lists

When a function needs more than 2-3 arguments, use an options object. This makes tests more readable and lets you add optional parameters without breaking existing callers.

```
// Clear what's being tested
processOrder({ items: [...], shipping: "express", coupon: "SAVE10" })

// vs. positional mystery
processOrder([...], "express", null, null, "SAVE10")
```

## Idempotency

Where possible, design operations that produce the same result when called multiple times. Idempotent operations are dramatically easier to test — you don't need to worry about test ordering or cleanup.

## Error Design

Decide early: does this function throw, return an error value, or use a Result type? Be consistent within a module. Tests for error cases should be as explicit as tests for happy paths.
