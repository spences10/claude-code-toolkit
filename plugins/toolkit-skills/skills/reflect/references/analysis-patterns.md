# Analysis Patterns

Rules for detecting learnings in conversation history.

## Correction Patterns (High Confidence)

Direct user corrections indicate wrong assumptions:

| Pattern    | Example                      | Learning Type       |
| ---------- | ---------------------------- | ------------------- |
| "actually" | "actually, use pnpm not npm" | Tool preference     |
| "no, "     | "no, that file is in src/"   | Path knowledge      |
| "instead"  | "use X instead of Y"         | Approach preference |
| "don't"    | "don't add comments"         | Style rule          |
| Reverts    | User undoes Claude's change  | Wrong approach      |

## Success Patterns (Medium Confidence)

Indicators of good approaches:

| Pattern              | Example                            | Learning Type      |
| -------------------- | ---------------------------------- | ------------------ |
| "perfect"            | "perfect, that's what I wanted"    | Validated approach |
| "yes" after proposal | Claude proposes, user approves     | Confirmed pattern  |
| Tests pass           | Build/test succeeds after change   | Working solution   |
| No correction        | Multi-step task completes smoothly | Valid workflow     |

## Context Patterns (Low Confidence)

Project-specific context worth noting:

| Pattern     | Example                        | Learning Type     |
| ----------- | ------------------------------ | ----------------- |
| File paths  | User references specific files | Project structure |
| Tool names  | User mentions specific tools   | Toolchain         |
| Conventions | Naming patterns, structures    | Code style        |

## Data Source Detection

Check for ccrecall availability first:

```
1. Check if mcp-sqlite-tools is available
2. Try to open ~/.claude/ccrecall.db
3. If success → use ccrecall mode
4. If fail → use in-context mode
```

### ccrecall Query Template

```sql
SELECT timestamp, role, content
FROM messages
WHERE session_id = (SELECT MAX(session_id) FROM sessions)
ORDER BY timestamp DESC
LIMIT 100;
```

### In-Context Analysis

When ccrecall unavailable, scan the current conversation context for:

- User messages containing correction patterns
- Assistant messages that were subsequently corrected
- Sequences showing: proposal → correction → revision

## Classification Rules

### High Confidence

- Explicit correction with clear alternative
- User uses strong language ("always", "never", "must")
- Same correction repeated in session

### Medium Confidence

- Implicit preference (user chooses one option)
- Success without explicit praise
- Pattern works but not explicitly validated

### Low Confidence

- Context mentioned but not corrected
- Single occurrence
- Ambiguous preference

## Output Format

When proposing updates:

```markdown
## Proposed Learning

**Confidence**: High/Medium/Low
**Source**: [quote from conversation]
**Learning**: [extracted rule]
**Target Skill**: [skill name or "new skill"]

### Suggested Addition

[markdown to add to skill file]
```
