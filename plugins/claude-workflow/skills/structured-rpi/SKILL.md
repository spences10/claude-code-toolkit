---
name: structured-rpi
# prettier-ignore
description: Enhanced Research-Plan-Implement workflow with structured phase gates. Use when tackling complex tasks that benefit from a phased approach with user checkpoints.
---

# Structured RPI (Research-Plan-Implement)

A 6-phase workflow that decomposes complex tasks into gated stages, each producing a markdown artifact the user approves before advancing.

## Quick Start

```text
Use structured RPI to refactor the authentication module.
```

The workflow walks through six phases sequentially. Each phase produces a concise markdown artifact. You must get user approval before moving to the next phase.

## Phases

| #   | Phase              | Artifact                    | Purpose                              |
| --- | ------------------ | --------------------------- | ------------------------------------ |
| 1   | **Questions**      | Clarifying questions list   | Surface unknowns and ambiguity       |
| 2   | **Research**       | Findings summary            | Gather context from code and docs    |
| 3   | **Design Discussion** | Design options + tradeoffs | Explore approaches with the user     |
| 4   | **Structure Outline** | Component/file outline     | Agree on shape before details        |
| 5   | **Plan**           | Implementation plan (Plan tool) | Concrete steps with acceptance criteria |
| 6   | **Implement**      | Working code + verification | Execute the plan                     |

## How It Works

1. **Announce the phase** — State which phase you're entering and what it produces
2. **Do the work** — Research, analyze, design, or implement as appropriate
3. **Present the artifact** — Output a markdown artifact with a clear heading
4. **Gate** — Ask the user to approve, request changes, or skip ahead
5. **Advance** — Only move to the next phase after explicit user approval

### Phase Gate Format

After each artifact, present:

```text
Phase N complete. Ready to proceed to Phase N+1 (Name)?
Options: [approve] [request changes] [skip to phase N+X] [abort]
```

## Key Rules

- **Always gate** — Never advance without user approval
- **Phase 5 uses the Plan tool** — Create a structured plan, not just prose
- **Artifacts are markdown** — Clean, scannable, no JSON blobs
- **Keep artifacts concise** — Prefer bullet points and tables over walls of text
- **Self-contained** — This workflow runs in a single session, no delegation

## When to Use

| Situation | Use Structured RPI? |
| --- | --- |
| Complex refactor spanning multiple files | Yes |
| New feature with unclear requirements | Yes |
| Bug fix with known cause | No — just fix it |
| One-file change | No — overkill |
| User says "plan this out" or "let's think through this" | Yes |

## When to Skip Phases

- **User already provided requirements** — Skip Phase 1 (Questions)
- **Small scope, well-understood** — Skip Phase 2 (Research)
- **Single obvious approach** — Compress Phase 3 (Design) into Phase 4 (Outline)
- **User says "just do it"** — Jump to Phase 6 with a lightweight plan

## References

- [phase-details.md](references/phase-details.md) - Detailed phase descriptions, inputs/outputs, done criteria
- [structured-outputs.md](references/structured-outputs.md) - Artifact templates for each phase
- [exit-conditions.md](references/exit-conditions.md) - When to skip, go back, or exit the workflow
