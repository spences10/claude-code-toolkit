# Structured Outputs

Artifact templates for each phase handoff. Keep artifacts concise — these are checkpoints, not documentation.

## Phase 1: Questions Artifact

```markdown
## Phase 1: Clarifying Questions

### Scope
1. Should X include Y or is that separate?
2. Are we targeting only Z or also W?

### Constraints
3. Any performance requirements?
4. Backward compatibility needed?

### Context
5. Is there existing work on this I should know about?
```

## Phase 2: Research Artifact

```markdown
## Phase 2: Research Findings

### Current State
- `src/auth/middleware.ts` handles token validation (L45-80)
- Sessions stored in Redis via `SessionStore` class

### Dependencies
- `UserService` calls `middleware.validate()` on every request
- 3 test files cover the auth path

### Patterns
- Existing middleware follows the `(req, res, next)` pattern
- Error responses use `ApiError` class from `src/errors.ts`

### Risks
- `SessionStore` has no interface — tightly coupled to Redis
- No integration tests for token refresh flow
```

## Phase 3: Design Discussion Artifact

```markdown
## Phase 3: Design Options

### Option A: Extract Interface + Adapter
- **Approach**: Define `ISessionStore`, wrap Redis in adapter
- **Pros**: Clean separation, testable, swappable backends
- **Cons**: More files, indirection
- **Effort**: Medium

### Option B: Refactor In-Place
- **Approach**: Add methods to existing `SessionStore`, keep Redis direct
- **Pros**: Fewer changes, faster
- **Cons**: Still coupled, harder to test
- **Effort**: Low

### Recommendation
Option A — the interface pays for itself in testability.
```

## Phase 4: Structure Outline Artifact

```markdown
## Phase 4: Structure Outline

### New Files
- `src/auth/session-store.interface.ts` — `ISessionStore` interface
- `src/auth/redis-session-adapter.ts` — Redis implementation
- `tests/auth/mock-session-store.ts` — Test double

### Modified Files
- `src/auth/middleware.ts` — Accept `ISessionStore` via constructor
- `src/auth/index.ts` — Update exports and wiring

### Deleted Files
- None

### Change Order
1. Create interface
2. Create Redis adapter (wraps existing code)
3. Update middleware to use interface
4. Create test double
5. Update existing tests
```

## Phase 5: Plan Artifact

Use the Plan tool. The plan should have concrete steps like:

```
Step 1: Create ISessionStore interface
- File: src/auth/session-store.interface.ts
- Methods: get(key), set(key, value, ttl), delete(key), exists(key)
- Verify: tsc --noEmit passes

Step 2: Create RedisSessionAdapter
- File: src/auth/redis-session-adapter.ts
- Implements ISessionStore, wraps existing Redis calls
- Verify: existing tests still pass (no behavior change)
...
```

## Phase 6: Implement Artifact

No template — this is working code. Report:

```markdown
## Phase 6: Implementation Complete

### Changes Made
- Created `src/auth/session-store.interface.ts` (new)
- Created `src/auth/redis-session-adapter.ts` (new)
- Modified `src/auth/middleware.ts` (dependency injection)

### Verification
- `npm test` — 47 passed, 0 failed
- `tsc --noEmit` — clean
- Manual smoke test of login flow — works
```
