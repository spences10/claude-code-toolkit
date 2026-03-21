# Quick Start Guide

## Creating Your First Skill

1. **Create the skill directory**

   ```bash
   mkdir -p .claude/skills/my-skill
   ```

2. **Create SKILL.md with frontmatter**

   ```markdown
   ---
   name: my-skill
   description: Brief description of what this skill does
   ---

   # My Skill

   Core instructions go here...
   ```

3. **Test in conversation**

   - Invoke the skill using the Skill tool
   - Verify it loads and provides correct guidance

4. **Iterate and expand**
   - Add references/ directory for detailed documentation
   - Add scripts/ for executable operations
   - Add assets/ for templates and files

## Skill Structure Details

### Directory Layout

```
my-skill/
├── SKILL.md          # Core instructions + YAML frontmatter
├── references/       # Detailed documentation (loaded as needed)
│   ├── guide.md
│   └── examples.md
├── scripts/          # Executable shell scripts or programs
│   └── setup.sh
└── assets/           # Templates, images, configuration files
    └── template.yaml
```

### SKILL.md Anatomy

```markdown
---
name: skill-name # Unique identifier (kebab-case, max 64 chars)
description: What it does and when to use it. Use when [triggers].
---

# Skill Title

Brief overview of what this skill does.

## Section 1

Core patterns and instructions...

## Section 2

More essential guidance...
```

## Frontmatter Requirements

### `name` field

- Max 64 characters
- Lowercase letters, numbers, and hyphens only
- Cannot contain "anthropic" or "claude" (reserved words)
- Cannot contain XML tags (`<` or `>`)
- Prefer **gerund form**: `processing-pdfs`, `analyzing-data`, `managing-databases`
- Acceptable alternatives: `pdf-processing`, `process-pdfs`
- Avoid generic names: `helper`, `utils`, `tools`, `data`

### `description` field

- Max 1024 characters, min ~50 characters
- Cannot contain XML tags
- Write in **third person** (description is injected into system prompt)
- Include both what the skill does AND when to use it
- Include searchable keywords and trigger phrases

### No README.md

Do not include a README.md inside the skill folder. All documentation goes in SKILL.md or references/.

## Progressive Disclosure Strategy

### Level 1: Metadata (Always Loaded)

- YAML frontmatter only
- CLI recommended: <200 chars, ~27 tokens (optimal for many skills)
- Anthropic max: 1024 chars, ~100 tokens
- Used for: Skill discovery and triggering

### Level 2: Instructions (Loaded When Triggered)

- SKILL.md body content
- CLI recommended: <50 lines, <1000 words (optimal for context efficiency)
- Anthropic max: 500 lines, ~5k tokens
- Use `npx claude-skills-cli validate` to check (default strict, `--loose` for official limits)
- Contains: Core patterns, essential rules, reference links

### Level 3: Resources (Loaded On Demand)

- references/ scripts/ assets/ directories
- Size: Unlimited
- Contains: Detailed docs, code, templates
- Keep references **one level deep** from SKILL.md (avoid nesting references that link to other references)
- For reference files over 100 lines, include a **table of contents** at the top

## Tips for Effective Skills

- **Start minimal**: Begin with just SKILL.md
- **Iterate**: Add references/ as complexity grows
- **Link clearly**: Use relative links to reference files
- **Test often**: Validate with `pnpx claude-skills-cli validate`
- **Stay focused**: One skill = one clear purpose
- **Evaluate first**: Create evaluations BEFORE writing extensive documentation
