# CLAUDE.md Hierarchy

Two levels, both loaded on every request.

## File Locations

| Location              | Scope        | Loaded       |
| --------------------- | ------------ | ------------ |
| `~/.claude/CLAUDE.md` | All projects | Always       |
| `.claude/CLAUDE.md`   | Current repo | In that repo |

Both concatenated into context. Project file shown after global.

## What Goes Where

### Global (`~/.claude/CLAUDE.md`)

Personal preferences across all projects:

```markdown
# Global Preferences

## Style

- Be extremely concise, sacrifice grammar
- No emojis unless requested
- Show file paths as absolute

## Workflow

- Ask before creating new files
- Prefer editing over rewriting
```

### Project (`.claude/CLAUDE.md`)

Repo-specific rules:

```markdown
# my-app

SvelteKit app with Prisma + PostgreSQL.

## Commands

- `pnpm dev` - start dev server
- `pnpm db:push` - sync schema

## Conventions

- Use `$state()` rune for reactive state
- API routes in `src/routes/api/`
```

## Conflict Resolution

When rules conflict, project wins:

**Global:**

```markdown
- Use tabs for indentation
```

**Project:**

```markdown
- Use 2 spaces (project standard)
```

Result: 2 spaces used in this project.

## Commit Decisions

| File    | Commit? | Reason               |
| ------- | ------- | -------------------- |
| Global  | No      | Personal preferences |
| Project | Usually | Team conventions     |

Exception: Don't commit if contains:

- Personal tool paths
- Local environment specifics
- Controversial preferences

## Common Patterns

**Split by concern:**

```
~/.claude/CLAUDE.md     → How I work
.claude/CLAUDE.md       → How this project works
```

**Avoid duplication:**
Don't repeat global rules in project file. They're already loaded.

**Reference, don't repeat:**

```markdown
## Detailed Conventions

See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.
```
