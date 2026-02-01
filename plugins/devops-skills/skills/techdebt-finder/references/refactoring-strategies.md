# Refactoring Strategies

Fix patterns for common technical debt types.

## Duplication Fixes

### Extract Shared Function

Before:

```typescript
// file1.ts
function processUserA(user) {
  validate(user);
  normalize(user.name);
  save(user);
}

// file2.ts
function processUserB(user) {
  validate(user);
  normalize(user.name);
  save(user);
}
```

After:

```typescript
// shared/user-processing.ts
export function processUser(user) {
  validate(user);
  normalize(user.name);
  save(user);
}
```

### Parameterize Variations

When duplicates differ slightly:

```typescript
// Before: 3 similar functions
function fetchUsers() {
  return fetch("/users");
}
function fetchPosts() {
  return fetch("/posts");
}
function fetchComments() {
  return fetch("/comments");
}

// After: one parameterized
function fetchResource(type: "users" | "posts" | "comments") {
  return fetch(`/${type}`);
}
```

### Template Method

For process variations:

```typescript
abstract class DataProcessor {
  process(data) {
    this.validate(data); // shared
    this.transform(data); // varies
    this.save(data); // shared
  }

  abstract transform(data); // subclass implements
}
```

## Inconsistency Fixes

### Naming Standardization

1. Choose convention (document in style guide)
2. Find all variants: `grep -rn "getUserData\|fetch_user\|loadUser"`
3. Pick canonical name
4. Global rename (IDE or sed)
5. Update imports

### Pattern Consolidation

```typescript
// Before: mixed error handling
try {
} catch (e) {
  console.log(e);
}
try {
} catch (e) {
  throw new Error(e);
}
try {
} catch (e) {
  return null;
}

// After: consistent approach
try {
} catch (e) {
  logger.error(e);
  throw new AppError(e.message, { cause: e });
}
```

## Dead Code Removal

### Safe Deletion Process

1. **Verify unused**: Search all references
2. **Check dynamic usage**: Grep for string references
3. **Review git history**: Why was it added?
4. **Delete in stages**: Comment first, delete next sprint
5. **Monitor**: Watch for errors post-deploy

### Unused Export Pattern

```bash
# Find export, count usages
export_name="unusedHelper"
usages=$(grep -r "$export_name" --include="*.ts" | wc -l)
# If usages == 1 (just the export), safe to remove
```

## Long Function Fixes

### Extract Method

```typescript
// Before: 80-line function
function processOrder(order) {
  // 20 lines: validate
  // 30 lines: calculate
  // 30 lines: persist
}

// After: composed
function processOrder(order) {
  validateOrder(order);
  const totals = calculateTotals(order);
  persistOrder(order, totals);
}
```

### Extract Class

When function has too many responsibilities:

```typescript
// Before: function with 10 helpers
function handlePayment(payment) { ... }
function validateCard() { ... }
function checkFraud() { ... }
// ...

// After: cohesive class
class PaymentProcessor {
  handle(payment) { ... }
  private validateCard() { ... }
  private checkFraud() { ... }
}
```

## Magic Number Fixes

```typescript
// Before
if (retries > 3) { ... }
setTimeout(fn, 30000);

// After
const MAX_RETRIES = 3;
const TIMEOUT_MS = 30_000;

if (retries > MAX_RETRIES) { ... }
setTimeout(fn, TIMEOUT_MS);
```

### Config Extraction

```typescript
// config/limits.ts
export const LIMITS = {
  maxRetries: 3,
  timeoutMs: 30_000,
  maxFileSize: 10_485_760,
} as const;
```

## Deep Nesting Fixes

### Early Return

```typescript
// Before
function process(x) {
  if (x) {
    if (x.valid) {
      if (x.ready) {
        return doWork(x);
      }
    }
  }
  return null;
}

// After
function process(x) {
  if (!x) return null;
  if (!x.valid) return null;
  if (!x.ready) return null;
  return doWork(x);
}
```

### Extract Conditions

```typescript
// Before
if (user.role === 'admin' && user.active && !user.suspended) { ... }

// After
const canAccess = user.role === 'admin' && user.active && !user.suspended;
if (canAccess) { ... }

// Or
function canAccess(user) {
  return user.role === 'admin' && user.active && !user.suspended;
}
```

## Safe Refactoring Checklist

Before refactoring:

- [ ] Tests exist for affected code
- [ ] Understand all callers
- [ ] Check for reflection/dynamic usage
- [ ] Plan rollback strategy

During:

- [ ] Small commits (one change per commit)
- [ ] Run tests after each step
- [ ] Keep behavior identical (no features)

After:

- [ ] All tests pass
- [ ] Review for missed references
- [ ] Update documentation if needed
- [ ] Monitor prod for regressions
