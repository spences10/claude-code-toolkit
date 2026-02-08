---
name: orchestration
# prettier-ignore
description: Multi-agent orchestration patterns for Claude Code team mode. Use when spawning teams, coordinating agents, decomposing complex tasks, or choosing between subagents and full teammates.
---

# Orchestration

Patterns for coordinating multi-agent work in Claude Code.

> Inspired by [claude-sneakpeek](https://github.com/mikekelly/claude-sneakpeek) orchestration skill. Thanks to [Mike Kelly](https://github.com/mikekelly) for the original concepts.

## Quick Start

Spawn parallel background agents with model selection:

```
Task(subagent_type="general-purpose", model="haiku", run_in_background=true,
  prompt="CONTEXT: You are a WORKER agent. Complete ONLY this task.
  Do NOT spawn sub-agents. Report results with absolute paths.
  TASK: Read src/auth/ and summarize the authentication approach.")
```

## Two Modes

| Mode | Use When |
|------|----------|
| **Subagents** (`Task` tool) | Independent work, no peer communication needed |
| **Teams** (`TeamCreate`) | Agents need to message each other, long-running |

Default to subagents. Escalate to teams when agents must collaborate.

## Core Concepts

- **Conductor pattern**: Decompose, delegate, synthesize. Never execute yourself.
- **Model selection**: haiku (fetching/lookup), sonnet (implementation), opus (architecture)
- **Worker preamble**: Always include "do not spawn sub-agents" in agent prompts
- **File partitioning**: Never assign same file to multiple agents

## References

- [patterns.md](references/patterns.md) - 6 orchestration patterns (fan-out, pipeline, map-reduce, speculative, background, task-graph)
- [domains.md](references/domains.md) - 8 domain-specific decomposition guides
- [task-management.md](references/task-management.md) - Task dependencies, graph walking, file partitioning
