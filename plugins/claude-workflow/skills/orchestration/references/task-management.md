# Task Management Patterns

Effective use of TaskCreate/TaskUpdate/TaskList for orchestration.

> Task management patterns inspired by [claude-sneakpeek](https://github.com/mikekelly/claude-sneakpeek) by Mike Kelly.

## Task Lifecycle

```
pending → in_progress → completed
                      → deleted (if no longer needed)
```

- Set `in_progress` BEFORE spawning an agent for the task
- Set `completed` only when agent reports success
- Use `deleted` for tasks superseded by changed requirements

## Dependency Patterns

### Linear Chain

```
Task 1 → Task 2 → Task 3
```

```
TaskCreate("Step 1")  # id: 1
TaskCreate("Step 2")  # id: 2
TaskUpdate(id: 2, addBlockedBy: [1])
TaskCreate("Step 3")  # id: 3
TaskUpdate(id: 3, addBlockedBy: [2])
```

### Diamond

```
    ┌── B ──┐
A ──┤       ├── D
    └── C ──┘
```

```
TaskCreate("A: Research")      # id: 1
TaskCreate("B: Frontend")      # id: 2, blockedBy: [1]
TaskCreate("C: Backend")       # id: 3, blockedBy: [1]
TaskCreate("D: Integration")   # id: 4, blockedBy: [2, 3]
```

### Fan-Out (no merge)

```
A ──┬── B
    ├── C
    └── D
```

All of B, C, D depend on A but not on each other. No final merge step.

## Task Descriptions

Write task descriptions as self-contained agent prompts:

**Good**:
```
Implement JWT token validation middleware in src/middleware/auth.ts.
Read the existing session-based auth in src/auth/session.ts for context.
Use jsonwebtoken package (already in package.json).
Export validateToken middleware function.
Write tests in src/middleware/__tests__/auth.test.ts.
```

**Bad**:
```
Do the JWT stuff we discussed.
```

Include:
- What to do (specific action)
- Where (file paths)
- Context (what to read first)
- Constraints (packages, patterns to follow)
- Deliverables (what files to create/modify)

## Walking the Graph

Orchestrator loop:

```
1. TaskList → find tasks with status=pending, no blockedBy
2. For each unblocked task:
   a. TaskUpdate(status: in_progress, owner: agent-name)
   b. Spawn agent with task description
3. When agent completes → TaskUpdate(status: completed)
4. TaskList → check for newly unblocked tasks
5. Repeat until all tasks completed
```

## Partitioning Files

When multiple agents work in parallel, partition files to avoid conflicts:

- **By module**: Agent A owns `src/auth/`, Agent B owns `src/api/`
- **By layer**: Agent A owns models, Agent B owns routes
- **By feature**: Agent A owns user flow, Agent B owns admin flow

State the partition explicitly in each agent's prompt:

```
You own these files exclusively: src/auth/jwt.ts, src/auth/middleware.ts
Do NOT modify any files outside this list.
```

## Comments and Progress

Use task descriptions for context. When updating tasks:

- Update description to append progress notes if needed
- Create new follow-up tasks rather than overloading one task
- Keep task subjects short and scannable for TaskList output

## Team Cleanup

When using teams with ccrecall for analytics:

- **Sync before delete**: Run `bunx ccrecall sync` BEFORE `TeamDelete`. Team config files at `~/.claude/teams/{name}/config.json` are ephemeral — `TeamDelete` removes them, and ccrecall reads from those files to capture team members and their models.
- **Order**: Shutdown teammates → sync ccrecall → delete team
- **If you skip sync**: Team members, model assignments, and task data won't be recorded in ccrecall.db

## Team vs Subagent Decision

| Factor | Subagents | Teams |
|--------|-----------|-------|
| Need peer communication | No | Yes |
| Session duration | Short (single task) | Long (multiple tasks) |
| Shared state needed | No | Yes (shared task list) |
| Cost sensitivity | Lower | Higher (full instance each) |
| Complexity | Simple coordination | Complex collaboration |
