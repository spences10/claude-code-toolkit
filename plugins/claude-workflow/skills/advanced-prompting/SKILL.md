---
name: advanced-prompting
# prettier-ignore
description: High-leverage prompts that challenge Claude's defaults. Use for "grill me", "prove it works", "scrap this", "what would 10x engineer do", "find ways this fails".
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
---

# Advanced Prompting Patterns

## Quick Start

Use these when Claude's first response feels safe/generic:

1. **Challenge** - "Grill me on these changes"
2. **Verify** - "Prove to me this works"
3. **Reset** - "Scrap this and implement the elegant solution"

## Pattern Categories

### Challenge Prompts

Force Claude to critique rather than accept:

- "Grill me on these changes" - Get pushback on your approach
- "What would a 10x engineer do differently" - Surface better patterns
- "Find 3 ways this could fail" - Adversarial review

### Verification Prompts

Demand evidence over assertions:

- "Prove to me this works" - Request test output, diffs
- "Show me the before/after" - Force concrete comparison
- "Walk through this line by line" - Prevent hand-waving

### Reset Prompts

Break out of local optima:

- "Scrap this and implement the elegant solution" - Fresh approach
- "You're overcomplicating this" - Simplification pressure
- "What's the 80/20 version" - Cut scope ruthlessly

## When to Use

| Situation                      | Prompt Pattern       |
| ------------------------------ | -------------------- |
| Code review feels shallow      | Challenge prompts    |
| Implementation seems fragile   | Verification prompts |
| Solution feels hacky           | Reset prompts        |
| Claude is agreeing too readily | "Push back on this"  |

## Anti-Patterns

- Don't use reset prompts mid-implementation (waste tokens)
- Challenge prompts need context (share the code first)
- Verification prompts pointless for trivial changes

## References

- [challenge-prompts.md](references/challenge-prompts.md) - Critique and adversarial review
- [verification-prompts.md](references/verification-prompts.md) - Evidence and proof patterns
- [reset-prompts.md](references/reset-prompts.md) - Fresh starts and simplification
