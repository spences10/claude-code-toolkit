# Testing Guide

Structured testing methodology for Claude Skills.

## Manual Testing Workflow

### Step 1: Structural Validation

Run the CLI validator first to catch structural issues:

```bash
npx claude-skills-cli validate .claude/skills/my-skill
npx claude-skills-cli validate .claude/skills/my-skill --strict
```

Fix all errors before proceeding. See [cli-reference.md](cli-reference.md) for validation details.

### Step 2: Trigger Testing

Test that the skill activates when expected:

1. Start a fresh conversation (no prior context)
2. Make a request that should trigger the skill — use natural language, do not name the skill directly
3. Verify Claude loads the skill (check if the skill's instructions are being followed)
4. Make a request that should NOT trigger the skill — verify it stays inactive

**Common trigger issues**:
- Skill triggers too broadly → Make description more specific
- Skill never triggers → Add keyword-rich trigger phrases ("Use when...")
- Skill triggers for wrong tasks → Narrow the domain terms in description

### Step 3: Instruction Following

Once triggered, verify Claude follows the skill's instructions:

1. Ask Claude to perform a core task the skill covers
2. Check the output against skill instructions — are patterns followed?
3. Ask for a task that requires reference files — does Claude read them?
4. Run any scripts the skill includes — do outputs match expectations?

### Step 4: Edge Case Testing

Test boundary conditions:

- What happens with minimal input?
- What happens with conflicting instructions (skill says X, user says Y)?
- Does the skill handle missing context gracefully?
- Do reference links resolve correctly?

## Validation Checklist

### Metadata (Level 1)

- [ ] `name` is lowercase kebab-case, under 64 characters
- [ ] `name` matches the directory name
- [ ] `description` is under 1024 characters
- [ ] `description` includes "Use when..." trigger phrase
- [ ] `description` contains domain-specific keywords
- [ ] No unsupported frontmatter fields (only `name` and `description` are valid)

### Instructions (Level 2)

- [ ] SKILL.md body under 5k words
- [ ] Imperative voice throughout (no "you should")
- [ ] Quick Start section with a working example
- [ ] 3-5 core patterns documented
- [ ] Links to references/ for detailed content
- [ ] No TODO placeholders
- [ ] No stale or incorrect examples

### Resources (Level 3)

- [ ] All referenced files exist (no broken links)
- [ ] Scripts are executable (`chmod +x`)
- [ ] Scripts have shebang lines (`#!/bin/bash` or `#!/usr/bin/env node`)
- [ ] No empty directories
- [ ] Reference files have clear headings and structure

### Integration

- [ ] Skill triggers from natural language requests
- [ ] Skill does NOT trigger for unrelated requests
- [ ] Claude follows skill instructions correctly
- [ ] Scripts produce expected output
- [ ] Reference files are accessed when needed

## Testing Script Template

Create a simple test script to validate skill structure programmatically:

```bash
#!/bin/bash
# scripts/test-skill.sh
SKILL_DIR="${1:-.claude/skills/my-skill}"

echo "Testing skill at: $SKILL_DIR"

# Check SKILL.md exists
if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
  echo "FAIL: SKILL.md not found"
  exit 1
fi

# Check frontmatter
if ! head -1 "$SKILL_DIR/SKILL.md" | grep -q "^---"; then
  echo "FAIL: Missing YAML frontmatter"
  exit 1
fi

# Check for broken reference links
grep -oP '\[.*?\]\((references/[^)]+)\)' "$SKILL_DIR/SKILL.md" | \
  grep -oP 'references/[^)]+' | while read -r ref; do
    if [ ! -f "$SKILL_DIR/$ref" ]; then
      echo "FAIL: Broken link to $ref"
      exit 1
    fi
  done

echo "PASS: Basic structure checks passed"
```

## Iteration After Testing

When tests reveal issues, apply these fixes:

| Symptom | Fix |
|---------|-----|
| Skill triggers too often | Make description more specific, remove broad keywords |
| Skill never triggers | Add trigger keywords, expand description |
| Claude ignores instructions | Move critical rules higher in SKILL.md, use imperative voice |
| Claude doesn't read references | Add explicit links in SKILL.md body |
| Scripts fail | Check shebang, permissions, and dependencies |
| Too much context loaded | Move content from SKILL.md to references/ |

See [development-process.md](development-process.md) for the full iteration workflow.
See [troubleshooting.md](troubleshooting.md) for common issues and fixes.
