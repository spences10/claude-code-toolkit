# Skill Examples

Real examples showing effective skill patterns.

## Example 1: API Client Skill

### Use Case

Repeatedly making authenticated API requests with TypeScript types and error handling.

### Structure

```
api-client/
├── SKILL.md                    # Core request patterns
├── references/
│   ├── endpoints.md            # Complete API endpoint reference
│   ├── authentication.md       # Auth patterns and token management
│   └── error-handling.md       # Error codes and retry strategies
└── scripts/
    ├── validate-token.js       # Check token validity
    └── test-endpoints.js       # Verify endpoint availability
```

### SKILL.md Excerpt

````markdown
---
name: api-client
description: REST API client with TypeScript types for user and data endpoints. Use when making HTTP requests, handling authentication, managing API errors, or working with async operations.
---

# API Client

## Quick Start

```typescript
import { apiClient } from "./lib/api";

// GET single resource with type safety
const user = await apiClient.get(`/users/${id}`);
```
````

For complete endpoint docs: [references/endpoints.md](references/endpoints.md)

### Why It Works

- Description includes operation keywords for matching
- Quick Start shows most common pattern with types
- Complete API docs in references (not inline)
- Scripts validate connectivity and tokens
- Keyword-rich: "HTTP requests", "authentication", "async operations"

---

## Example 2: Database Patterns

### Use Case

Type-safe database queries with consistent patterns.

### Structure

```
database-patterns/
├── SKILL.md                    # Core patterns and conventions
├── references/
│   ├── schema.md               # Complete database schema
│   ├── query-patterns.md       # Common query examples
│   └── migrations.md           # Migration conventions
└── scripts/
    └── validate-schema.js      # Check schema consistency
```

### SKILL.md Excerpt

````markdown
---
name: database-patterns
description: SQLite database operations with better-sqlite3 for contacts, companies, and interactions. Use when writing SELECT, INSERT, UPDATE, DELETE, or designing database schema.
---

# Database Patterns

## Quick Start

```typescript
import { db } from "./lib/db";

// Query with type safety
const users = db.prepare("SELECT * FROM users WHERE active = ?").all(1);
```
````

### Why It Works

- Mentions specific technology (SQLite, better-sqlite3)
- Lists specific operations (SELECT, INSERT, UPDATE, DELETE)
- Schema details in references, not SKILL.md
- Script validates consistency

---

## Example 3: Component Library

### Use Case

Consistent component styling with project conventions.

### Structure

```
component-library/
├── SKILL.md                    # Core components and patterns
├── references/
│   ├── component-catalog.md    # All available components
│   └── theme-tokens.md         # Color system and usage
└── assets/
    └── templates/
        ├── basic-component.svelte
        └── form-component.svelte
```

### SKILL.md Excerpt

````markdown
---
name: component-library
description: UI component patterns with DaisyUI v5 for cards, forms, buttons, and layouts. Use when styling components, implementing forms, or applying consistent visual design.
---

# Component Library

## Card Pattern

```svelte
<div class="card bg-base-100 shadow-xl">
  <div class="card-body">
    <h2 class="card-title">Title</h2>
    <p>Content</p>
  </div>
</div>
```
````

### Why It Works

- Shows actual classes used in project
- Theme tokens documented
- Templates in assets/ for copying
- Keywords: "cards, forms, buttons, layouts"

---

## Example 4: Project Context

### Use Case

Ensure Claude follows YOUR project's specific patterns, conventions, and architecture decisions consistently across all conversations.

### Why You Need This

Without a project-context skill, Claude:

- Mixes patterns (uses `writable` when you use `$state`)
- Creates files in wrong locations
- Uses wrong libraries (Prisma when you use Drizzle)
- Ignores your naming conventions

With a project-context skill, Claude automatically follows your rules.

### Structure

```
project-context/
├── SKILL.md                    # Stack + critical rules
└── references/
    ├── architecture.md         # System design details
    ├── conventions.md          # Naming, file structure
    └── patterns.md             # Code patterns with examples
```

### SKILL.md Example (SvelteKit + Drizzle + Better-auth)

```markdown
---
name: project-context
description: Project patterns for [your-app]. Use before any development work to ensure consistent implementation.
---

# Project Context

## Stack

- **Framework**: SvelteKit 2 with Svelte 5
- **Database**: SQLite + Drizzle ORM
- **Auth**: Better-auth
- **UI**: Tailwind + shadcn-svelte
- **Forms**: Superforms + Zod

## Critical Rules

1. **State**: Use `$state`, `$derived`, `$effect` - never `writable`/`$:`
2. **Routes**: App routes in `src/routes/(app)/` - requires auth
3. **DB queries**: Always through `src/lib/server/db/queries/` - never import drizzle directly in routes
4. **Forms**: Superforms with Zod schemas from `src/lib/schemas/`
5. **Auth**: Use `auth.api` helpers - never modify `src/lib/server/auth.ts` directly

## File Patterns

| Type         | Location                      | Naming               |
| ------------ | ----------------------------- | -------------------- |
| Routes       | `src/routes/(app)/[feature]/` | `+page.svelte`       |
| Components   | `src/lib/components/`         | `PascalCase.svelte`  |
| Server utils | `src/lib/server/`             | `kebab-case.ts`      |
| Schemas      | `src/lib/schemas/`            | `[entity].schema.ts` |

## References

- [architecture.md](references/architecture.md) - System design
- [conventions.md](references/conventions.md) - All naming rules
- [patterns.md](references/patterns.md) - Code examples
```

### Why It Works

- **Specific stack** - Names exact versions and libraries
- **Critical rules first** - Most important patterns immediately visible
- **Actionable** - "never do X" is clearer than "prefer Y"
- **File locations** - Claude knows where to create things
- **Details in references** - Keeps SKILL.md scannable

### Creating Your Own

1. List your stack (framework, db, auth, ui)
2. Identify top 5 mistakes Claude makes in your project
3. Write rules that prevent those mistakes
4. Add file location patterns
5. Move detailed docs to references/

### Key Insight

A project-context skill is NOT a template you distribute - it's unique to YOUR project. Create one in your repo's `.claude/skills/` or as a local plugin.

---

## Pattern: Description Keywords

Good descriptions include:

- **Technology names**: "TypeScript", "REST API", "React", "Node.js"
- **Operations**: "HTTP requests", "OAuth flow", "async/await"
- **Data types**: "users, posts, comments", "API responses"
- **Triggers**: "Use when...", "Use for...", "Use to..."

### Before (Vague)

```yaml
description: Helps with API stuff
```

### After (Specific)

```yaml
description: REST API client with TypeScript types for user and data endpoints. Use when making HTTP requests, handling authentication, managing API errors, or working with async operations.
```

---

## Pattern: Progressive Disclosure

### Level 1: Metadata (Always)

```yaml
name: api-client
description: [50-100 words with keywords]
```

**Token cost**: ~100 tokens

### Level 2: SKILL.md Body (When Triggered)

- Quick Start example
- 3-5 core patterns
- Links to references
- Script descriptions

**Token cost**: ~3-5k tokens

### Level 3: Resources (As Needed)

- references/endpoints.md (complete API docs)
- references/examples.md (20+ examples)
- scripts/validate-token.js (runs without loading)

**Token cost**: Only what's accessed

---

## Pattern: Scripts for Efficiency

### Without Script

```markdown
Claude generates validation code every time:
"Check that all timestamps are valid..."
[Claude writes 50 lines of JavaScript]
```

**Cost**: ~500 tokens each time

### With Script

```bash
node scripts/validate_timestamps.js
```

**Cost**: ~50 tokens (just output)

### Script Types

- **Validation**: Check data consistency
- **Generation**: Create boilerplate
- **Analysis**: Parse and report
- **Testing**: Verify configuration

---

## Pattern: Assets for Templates

### Without Assets

```markdown
"Create a basic component..."
[Claude writes boilerplate each time]
```

### With Assets

```bash
cp assets/templates/basic-component.svelte \
  src/lib/components/new-component.svelte
# Modify as needed
```

### Asset Types

- Component templates (.svelte, .tsx)
- SQL schemas (.sql)
- Configuration files (.json)
- Images and logos (.png, .svg)

---

## Anti-Patterns to Avoid

### Generic Description

```yaml
description: Database helper tool
```

**Fix**: Include table names, operations, when to use

### Everything Inline

```markdown
# Database Skill

## Complete Schema (1000 lines)

## All Queries (500 lines)
```

**Fix**: Move to references/schema.md

### Second Person

```markdown
You should use prepared statements...
```

**Fix**: "Use prepared statements for all queries"

### Missing Keywords

```yaml
description: Helps with frontend stuff
```

**Fix**: "React components with hooks, TypeScript, forms"

---

## Quick Checklist

Before considering a skill "done":

- [ ] Description includes keywords and "when to use"
- [ ] Quick Start shows most common pattern
- [ ] Core patterns (3-5) in SKILL.md
- [ ] Detailed docs in references/
- [ ] Scripts for repeated code
- [ ] Assets for templates
- [ ] Validated with `npx claude-skills-cli validate`
- [ ] Tested in real conversations
- [ ] No TODO placeholders
- [ ] Imperative voice throughout
