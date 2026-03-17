# Reference: Deep Module Architecture

## Dependency Categories

When analyzing module coupling, classify each dependency into one of four categories:

### 1. Same-process, same-team
Dependencies between modules owned by the same team, running in the same process. These are the easiest to consolidate — merge freely.

**Example**: A `UserValidator` and `UserService` in the same package.

### 2. Same-process, different-team
Dependencies crossing team boundaries but still in-process. Consolidation requires coordination but is technically straightforward.

**Example**: Your service calling a shared auth library maintained by the platform team.

### 3. Cross-process, same-team
Network boundaries you control. The interface is already forced to be explicit (HTTP/gRPC), but you can reshape both sides.

**Example**: Your API gateway calling your own microservice.

### 4. Cross-process, different-team
Network boundaries you don't fully control. You can only design your side of the interface. Use ports & adapters.

**Example**: Calling a third-party payment API.

## How Category Affects Design

| Category | Consolidation strategy | Interface ownership |
|----------|----------------------|-------------------|
| 1 (same/same) | Merge modules directly | Full control |
| 2 (same/diff) | Propose shared interface, coordinate | Negotiated |
| 3 (cross/same) | Deepen behind a facade | Full control |
| 4 (cross/diff) | Ports & adapters pattern | Your side only |

## GitHub Issue RFC Template

Use this template when creating refactor RFC issues in Step 7:

```markdown
## Summary

[1-2 sentence description of what's being consolidated and why]

## Current State

### Modules involved
- `path/to/module-a` — [what it does]
- `path/to/module-b` — [what it does]
- ...

### Coupling evidence
- [Shared types, call patterns, co-change frequency]

### Dependency category
[One of the four categories above]

## Proposed Interface

```[language]
[The chosen interface design from Step 6]
```

### What it hides
- [Implementation details now behind the interface]

### Dependency strategy
- [How external deps are handled — injected, adapted, etc.]

## Test Impact

### Tests replaced by boundary tests
- [List existing tests that become redundant]

### New boundary tests needed
- [List tests against the new interface]

## Migration Plan

1. [ ] Create new module with chosen interface
2. [ ] Implement behind interface, delegating to existing code
3. [ ] Migrate callers one at a time
4. [ ] Remove old modules once all callers migrated
5. [ ] Replace internal tests with boundary tests

## Trade-offs

- [Pros of chosen design]
- [Cons / what we're giving up]
- [Why this trade-off is acceptable]
```
