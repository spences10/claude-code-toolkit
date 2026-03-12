# Deep Module Testing

## The Core Idea

A deep module has a simple interface hiding complex internals. When testing deep modules, test the simple interface — not the complexity underneath.

If your tests break every time you restructure internals, they're coupled to implementation. This makes refactoring terrifying instead of routine.

## Test the Surface, Not the Guts

Think of every module as having two parts:

1. **Surface area** — the public API callers depend on
2. **Internals** — the implementation details that can change freely

Tests should exercise (1) and ignore (2).

### Good: Testing Behavior

```
// Tests what the function promises
expect(parseCSV("name,age\nAlice,30")).toEqual([{ name: "Alice", age: "30" }])
```

### Bad: Testing Internals

```
// Tests how the function works internally
expect(parser._splitLines("a\nb")).toEqual(["a", "b"])
expect(parser._tokenize("a,b")).toEqual(["a", "b"])
```

## The Swap Test

Ask yourself: could I completely rewrite the internals and have my tests still pass? If yes, your tests are at the right level. If no, they're too coupled.

## When Depth Changes

Sometimes a module's interface grows (more parameters, more methods). That's a signal the module may need splitting. When you split, each new module gets its own surface-area tests.

## Private Functions

Private functions exist to support the public interface. Test them through the public interface. If a private function is complex enough that you feel it needs direct tests, it probably deserves to be its own module with its own public interface.
