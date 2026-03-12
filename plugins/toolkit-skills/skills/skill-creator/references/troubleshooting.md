# Troubleshooting

Common skill development issues and fixes.

## Skill Not Triggering

**Symptom**: Claude does not activate the skill when expected.

**Causes and fixes**:

| Cause | Fix |
|-------|-----|
| Description too vague | Add specific keywords, technology names, and "Use when..." triggers |
| Description too short | Expand to 100-300 characters with domain terms |
| Multi-line description | Run `npx claude-skills-cli doctor <path>` to fix; add `# prettier-ignore` |
| Name/description mismatch | Ensure description accurately reflects skill content |

**Test**: Start a fresh conversation and make a natural request related to the skill domain.

## Skill Triggers Too Often

**Symptom**: Skill activates for unrelated tasks.

**Causes and fixes**:

| Cause | Fix |
|-------|-----|
| Description too broad | Narrow keywords, remove generic terms like "coding" or "development" |
| Overly common keywords | Use domain-specific terms instead of general ones |

**Test**: Make requests outside the skill's domain and verify the skill stays inactive.

## Claude Ignores Skill Instructions

**Symptom**: Skill loads but Claude doesn't follow the documented patterns.

**Causes and fixes**:

| Cause | Fix |
|-------|-----|
| Instructions buried too deep | Move critical rules to top of SKILL.md |
| Passive or vague voice | Rewrite in imperative voice: "Use X" not "You might want to use X" |
| Conflicting instructions | Remove contradictions; one clear rule per concern |
| Too much content in SKILL.md | Move details to references/, keep SKILL.md under 150 lines |

## Claude Doesn't Read References

**Symptom**: Claude answers from general knowledge instead of reading reference files.

**Causes and fixes**:

| Cause | Fix |
|-------|-----|
| No links in SKILL.md | Add explicit links: `See [references/guide.md](references/guide.md)` |
| Links not descriptive | Describe what each reference contains |
| SKILL.md answers the question | If the answer is in SKILL.md, Claude won't dig deeper — move detailed content to references |

## Frontmatter Issues

### Invalid Frontmatter

**Symptom**: CLI validation fails on frontmatter.

**Fixes**:
- Ensure SKILL.md starts with `---` on line 1
- Only use `name` and `description` fields — no other fields are supported
- `name` must be lowercase kebab-case, under 64 characters
- `description` must be under 1024 characters

**Known discrepancy**: Some Anthropic documentation references an `allowed-tools` frontmatter field. This field is **not supported** in Claude Code. Do not use it.

### Multi-Line Description

**Symptom**: Skill not recognized after running Prettier or other formatters.

**Fix**:
```bash
npx claude-skills-cli doctor .claude/skills/my-skill
```

This adds `# prettier-ignore` and reflows the description to a single line.

## Script Issues

### Script Won't Execute

**Causes and fixes**:

| Cause | Fix |
|-------|-----|
| Missing permissions | `chmod +x scripts/my-script.sh` |
| Missing shebang | Add `#!/bin/bash` or `#!/usr/bin/env node` as first line |
| Wrong line endings | Convert to Unix line endings: `dos2unix scripts/my-script.sh` |

### Script Output Too Large

**Symptom**: Script runs but floods the context window.

**Fix**: Modify script to output a summary instead of raw data. Filter or truncate output within the script.

## Validation Errors

### "Description missing trigger keywords"

Add a "Use when..." phrase to the description:

```yaml
# Before
description: Database query patterns

# After
description: Database query patterns for SQLite. Use when writing queries, designing schema, or optimizing database operations.
```

### "SKILL.md body too long"

Move content to reference files:

1. Identify sections that are detailed documentation (not core patterns)
2. Move them to `references/<topic>.md`
3. Replace with a link: `See [references/<topic>.md](references/<topic>.md)`

### "Broken reference link"

A link in SKILL.md points to a file that doesn't exist:

1. Check the path is correct (relative to SKILL.md location)
2. Create the missing file, or remove/update the link

### "Name doesn't match directory"

The `name` field in frontmatter must match the skill's directory name:

```yaml
# Directory: .claude/skills/my-skill/
# Frontmatter must be:
name: my-skill
```

## Platform-Specific Issues

### Claude Code

- Skills must be in `.claude/skills/` (project) or `~/.claude/skills/` (user) or in a plugin's `skills/` directory
- File permissions matter — ensure files are readable
- Symlinks may not be followed in all cases

### Claude.ai

- Upload as zip with SKILL.md at the zip root
- Maximum upload size limits may apply
- Skills are per-user, not org-wide

### Claude API

- Upload via `/v1/skills` endpoint
- Skills are workspace-scoped
- Check API documentation for current size limits

## Getting Help

If issues persist:

1. Run `npx claude-skills-cli validate --strict` and fix all reported issues
2. Review [development-process.md](development-process.md) for the recommended workflow
3. Check [testing-guide.md](testing-guide.md) for systematic testing steps
4. Compare against working examples in [skill-examples.md](skill-examples.md)
