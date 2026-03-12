# Slop Patterns

The 10 AI-generated code patterns to detect and remove. Language-agnostic.

## 1. Unnecessary Comments Explaining Obvious Code

Comments that restate what the code already says.

**Bad:**

```python
# Increment the counter
counter += 1

# Return the result
return result
```

**Good:**

```python
counter += 1
return result
```

**Why it's slop:** The code is self-documenting. The comment adds zero information and doubles the visual noise.

## 2. Over-Engineered Error Handling for Impossible Cases

Try/catch or error handling around operations that cannot fail in context, or catching errors that are already handled upstream.

**Bad:**

```typescript
function add(a: number, b: number): number {
  try {
    if (typeof a !== "number" || typeof b !== "number") {
      throw new TypeError("Arguments must be numbers");
    }
    const result = a + b;
    if (!Number.isFinite(result)) {
      throw new RangeError("Result is not finite");
    }
    return result;
  } catch (error) {
    console.error("Error in add function:", error);
    throw error;
  }
}
```

**Good:**

```typescript
function add(a: number, b: number): number {
  return a + b;
}
```

**Why it's slop:** TypeScript already enforces the types. Internal pure functions don't need try/catch. The validation guards against scenarios the type system prevents.

## 3. Verbose Docstrings on Simple Functions

Multi-line doc comments on functions whose name and signature already explain everything.

**Bad:**

```python
def get_user_by_id(user_id: int) -> User:
    """
    Get a user by their ID.

    This function retrieves a user from the database using
    their unique identifier.

    Args:
        user_id: The unique identifier of the user to retrieve.

    Returns:
        User: The user object corresponding to the given ID.

    Raises:
        UserNotFoundError: If no user with the given ID exists.
    """
    return self.db.users.get(user_id)
```

**Good:**

```python
def get_user_by_id(user_id: int) -> User:
    """Raises UserNotFoundError if not found."""
    return self.db.users.get(user_id)
```

**Why it's slop:** The function name says "get user by id". The type hints say it takes an int and returns a User. The only non-obvious info is the exception behavior.

## 4. "Just in Case" Abstractions

Premature helpers, utilities, or wrapper functions used exactly once. Created for hypothetical reuse that never happens.

**Bad:**

```javascript
// utils/stringHelpers.js
export function formatUserName(first, last) {
  return `${first} ${last}`;
}

// component.js
import { formatUserName } from "./utils/stringHelpers";
const name = formatUserName(user.first, user.last);
```

**Good:**

```javascript
// component.js
const name = `${user.first} ${user.last}`;
```

**Why it's slop:** A one-liner used once doesn't need its own function. The abstraction adds indirection without value.

## 5. Redundant Type Annotations That Add No Clarity

Type annotations where the type is already obvious from the value or context.

**Bad:**

```typescript
const name: string = "Alice";
const count: number = 0;
const items: string[] = ["a", "b", "c"];
const isReady: boolean = false;
```

**Good:**

```typescript
const name = "Alice";
const count = 0;
const items = ["a", "b", "c"];
const isReady = false;
```

**Why it's slop:** Type inference handles these. The annotations are visual noise that repeat what the literal values already tell you.

## 6. "Removed" or "Previously" Comments

Comments marking where code used to be, instead of just deleting it.

**Bad:**

```python
# Previously handled authentication here
# Removed: old_auth_check()

class UserService:
    # removed legacy validation
    pass
```

**Good:**

```python
class UserService:
    pass
```

**Why it's slop:** Git history tracks what was removed. These comments are dead weight that accumulates over time.

## 7. Backwards-Compatibility Shims for Unused Code

Re-exports, aliases, or compatibility layers for code that nothing uses anymore.

**Bad:**

```typescript
// Keep old name for backwards compatibility
export const fetchUserData = getUserById;

// Legacy alias
export type UserRecord = User;

// Renamed but keeping old export
const _unusedOldHelper = newHelper;
```

**Good:**

```typescript
// (just delete them — nothing uses the old names)
```

**Why it's slop:** If nothing imports the old name, the shim is dead code. If something does, rename it at the call site.

## 8. Excessive Internal Validation

Validating inputs from trusted internal sources where the contract is already guaranteed by the caller or type system.

**Bad:**

```go
func (s *Service) processOrder(order Order) error {
    if order.ID == "" {
        return fmt.Errorf("order ID cannot be empty")
    }
    if order.Items == nil {
        return fmt.Errorf("order items cannot be nil")
    }
    if len(order.Items) == 0 {
        return fmt.Errorf("order must have at least one item")
    }
    // ... actual logic
}
```

**Good:**

```go
func (s *Service) processOrder(order Order) error {
    // order is validated at API boundary in handleCreateOrder
    // ... actual logic
}
```

**Why it's slop:** Internal functions called from code you control don't need to re-validate what the caller already guarantees. Validate at system boundaries (user input, external APIs), not between your own functions.

## 9. Unnecessary Emoji in Code Comments

Emoji used as decoration in code comments rather than conveying meaning.

**Bad:**

```python
# 🚀 Initialize the application
app = Flask(__name__)

# ✨ Create the database connection
db = Database(config.db_url)

# 🔥 Start processing
process_queue()
```

**Good:**

```python
app = Flask(__name__)
db = Database(config.db_url)
process_queue()
```

**Why it's slop:** Emoji in code comments are visual noise. They don't convey technical information and make code harder to grep.

## 10. Filler Summary Comments at End of Functions or Files

Comments that summarize what the function/block just did, restating the code above.

**Bad:**

```javascript
function processUsers(users) {
  const active = users.filter((u) => u.active);
  const sorted = active.sort((a, b) => a.name.localeCompare(b.name));
  const mapped = sorted.map((u) => ({ id: u.id, name: u.name }));
  return mapped;
  // End of processUsers - filters active users, sorts by name, and maps to simplified objects
}
```

**Good:**

```javascript
function processUsers(users) {
  const active = users.filter((u) => u.active);
  const sorted = active.sort((a, b) => a.name.localeCompare(b.name));
  return sorted.map((u) => ({ id: u.id, name: u.name }));
}
```

**Why it's slop:** The code is right there. A trailing summary adds nothing except maintenance burden when the logic changes.

## Detection Priority

When scanning, check patterns in this order (highest signal first):

1. Unnecessary comments (most common, easiest to spot)
2. "Removed"/"previously" comments (pure noise)
3. Filler summary comments (pure noise)
4. Emoji in comments (pure noise)
5. Verbose docstrings (common, usually safe to trim)
6. Redundant type annotations (common, language-dependent)
7. Over-engineered error handling (needs context)
8. Excessive internal validation (needs context)
9. Backwards-compatibility shims (needs usage check)
10. "Just in case" abstractions (needs usage check)
