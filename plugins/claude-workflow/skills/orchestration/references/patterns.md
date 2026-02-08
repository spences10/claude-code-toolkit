# Orchestration Patterns

Detailed examples for each coordination pattern.

> Patterns inspired by [claude-sneakpeek](https://github.com/mikekelly/claude-sneakpeek) by Mike Kelly. Thanks to Mike for the original orchestration concepts.

## Fan-Out

Spawn N independent agents for parallel work. No communication between them.

```
Orchestrator
├── Agent A (security review)
├── Agent B (performance review)
├── Agent C (correctness review)
└── Agent D (style review)
```

**When**: Tasks are independent, results aggregated by orchestrator.

**Example**: PR review from multiple angles.

```
1. TaskCreate("Security review of auth changes")
2. TaskCreate("Performance review of query changes")
3. TaskCreate("Correctness review of business logic")
4. Spawn haiku agent per task with run_in_background=true
5. Collect results, synthesize into unified review
```

**Model choice**: haiku for simple reviews, sonnet for nuanced analysis.

## Pipeline

Sequential agents where output feeds the next stage.

```
Research Agent → Planning Agent → Implementation Agent → Review Agent
```

**When**: Each stage depends on the previous stage's output.

**Example**: Feature implementation.

```
1. TaskCreate("Research existing auth patterns") → haiku
2. TaskCreate("Plan JWT migration", blockedBy: [1]) → opus
3. TaskCreate("Implement JWT auth", blockedBy: [2]) → sonnet
4. TaskCreate("Review implementation", blockedBy: [3]) → sonnet
```

Wait for each stage. Pass results via task description or file references.

## Map-Reduce

Distribute work across N agents, then aggregate.

```
Orchestrator splits work
├── Agent A (files 1-5)
├── Agent B (files 6-10)
├── Agent C (files 11-15)
└── Orchestrator merges results
```

**When**: Same operation on many items, need unified output.

**Example**: Codebase-wide type audit.

```
1. List all files needing audit
2. Partition into chunks (5-10 files per agent)
3. Spawn sonnet agents per chunk: "Audit these files for type safety issues"
4. Collect per-chunk reports
5. Merge into single prioritized report
```

**Key**: Partition files cleanly. Never assign same file to multiple agents.

## Speculative

Run competing approaches in parallel, pick the best.

```
Orchestrator
├── Agent A (approach: functional)
├── Agent B (approach: OOP)
└── Agent C (approach: procedural)
→ Compare outputs, select winner
```

**When**: Uncertain which approach is best. Budget allows parallel exploration.

**Example**: Algorithm optimization.

```
1. Spawn 3 sonnet agents with different strategies
2. Each writes solution to separate branch/file
3. Run benchmarks on each
4. Select best performer, discard others
```

**Cost warning**: Expensive pattern. Use only when approach uncertainty is high.

## Background

Fire-and-forget for long tasks while continuing foreground work.

```
Orchestrator continues working
└── Background Agent (long-running task)
    → Notifies when done
```

**When**: Task is independent and non-blocking.

**Example**: Generate test suite while implementing feature.

```
1. Spawn sonnet agent: "Generate tests for the auth module" with run_in_background=true
2. Continue implementing feature in foreground
3. Check background task output when ready to integrate
```

## Task Graph (DAG)

Most flexible pattern. Define tasks with dependency edges.

```
     ┌── B ──┐
A ───┤       ├── D ── E
     └── C ──┘
```

**When**: Complex projects with partial ordering.

**Example**: Full feature implementation.

```
TaskCreate("Research API requirements")           # Task 1
TaskCreate("Design database schema")              # Task 2
TaskCreate("Implement API endpoints", blockedBy: [1, 2])  # Task 3
TaskCreate("Write integration tests", blockedBy: [3])     # Task 4
TaskCreate("Update documentation", blockedBy: [3])        # Task 5 (parallel with 4)
```

Walk the graph:
1. Spawn agents for all unblocked tasks
2. When a task completes, check for newly unblocked tasks
3. Spawn agents for those
4. Repeat until all tasks resolved

**This is the foundation pattern.** All other patterns are special cases of a task graph.
