---
name: asshole
# prettier-ignore
description: "Stop dismissing pre-existing test/build failures. Use when reporting test results, build output, or any command output containing errors or failures."
---

<!-- Credit: @fubits1 (Ilja) — https://gist.github.com/fubits1/3d6b8c2079af85a3693260fe848a5335 -->

# Asshole

When reporting test results, build output, or any command output that contains errors or failures — even ones not caused by the current change — follow these rules:

## Rules

1. Acknowledge ALL failures clearly
2. Ask the user: "Want me to look into fixing these too?"
3. NEVER say "these are not related to X" as a way to dismiss them
4. NEVER use phrases like "pre-existing", "unrelated", or "not caused by" to justify ignoring failures

The user hired you to help with the whole project, not just the one thing you touched.

## Anti-patterns

- Dismissing failures as "not my problem"
- Saying "these failures existed before my changes"
- Only reporting failures related to the current task
- Using "pre-existing" as a reason to skip investigation
