---
name: orchestration
# prettier-ignore
description: Multi-agent orchestration patterns for Claude Code team mode. Use when coordinating teammates, decomposing complex tasks, or managing shared task lists.
---

# Orchestration

Patterns for coordinating multi-agent work in Claude Code using team mode.

Source: [code.claude.com/docs/en/agent-teams](https://code.claude.com/docs/en/agent-teams)

## Quick Start

Tell the lead what team you want in natural language:

```text
Create an agent team to refactor the auth module. Spawn three teammates:
- One focused on extracting shared utilities
- One migrating tests to the new structure
- One updating documentation
Use Sonnet for each teammate.
```

The lead creates the team, spawns teammates, distributes work via a shared task list, and synthesizes results.

## How It Works

| Component     | Role                                                            |
| ------------- | --------------------------------------------------------------- |
| **Team lead** | Your main session — creates team, spawns teammates, coordinates |
| **Teammates** | Separate Claude Code instances working on assigned tasks        |
| **Task list** | Shared work items teammates claim and complete                  |
| **Messaging** | `SendMessage` for DMs, broadcasts, and shutdown requests        |

Teammates are persistent — they go idle between turns and can be woken up with messages. They can message each other directly.

## Key Behaviours

- **Lead spawns teammates** based on your prompt — you describe the team, the lead creates it
- **Teammates self-claim tasks** from the shared list after finishing work
- **No nested teams** — teammates cannot spawn their own teams or teammates
- **File partitioning** — never assign the same file to multiple teammates
- **3-5 teammates** is the sweet spot for most workflows
- **5-6 tasks per teammate** keeps everyone productive

## When Teams vs Subagents

|                   | Subagents                          | Teams                                      |
| ----------------- | ---------------------------------- | ------------------------------------------ |
| **Communication** | Report back to caller only         | Message each other directly                |
| **Coordination**  | Main agent manages all work        | Shared task list, self-coordination        |
| **Best for**      | Focused tasks, only result matters | Complex work needing collaboration         |
| **Token cost**    | Lower                              | Higher (each teammate = separate instance) |

## References

- [patterns.md](references/patterns.md) - 6 orchestration patterns (fan-out, pipeline, map-reduce, speculative, background, task-graph)
- [domains.md](references/domains.md) - 8 domain-specific decomposition guides
- [task-management.md](references/task-management.md) - Task dependencies, graph walking, file partitioning
