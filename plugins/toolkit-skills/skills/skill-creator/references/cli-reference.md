# claude-skills-cli Reference

Complete command-line reference for the `claude-skills-cli` tool.

## Installation

### Global Installation

```bash
npm install -g claude-skills-cli
claude-skills-cli --version
```

### Using npx (No Installation)

```bash
npx claude-skills-cli <command>
```

### Using pnpm

```bash
pnpx claude-skills-cli <command>
```

### As Dev Dependency

```bash
npm install --save-dev claude-skills-cli

# Use via package.json scripts
{
  "scripts": {
    "skill:init": "claude-skills-cli init",
    "skill:validate": "claude-skills-cli validate",
    "skill:package": "claude-skills-cli package"
  }
}
```

---

## Commands

### `init` - Create New Skill

Create a new skill directory with standard structure.

#### Syntax

```bash
claude-skills-cli init [options]
```

#### Options

| Option                 | Type   | Required | Description                                          |
| ---------------------- | ------ | -------- | ---------------------------------------------------- |
| `--name <name>`        | string | Yes\*    | Skill name (kebab-case, lowercase)                   |
| `--description <desc>` | string | No       | Skill description (default: "TODO: Add description") |
| `--path <path>`        | string | No       | Custom path (mutually exclusive with --name)         |

\*Either `--name` or `--path` must be provided

#### Examples

```bash
# Create skill with default location (.claude/skills/)
npx claude-skills-cli init --name my-skill

# With description
npx claude-skills-cli init --name my-skill \
  --description "SQLite queries. Use when writing database operations"

# Custom path
npx claude-skills-cli init --path /custom/path/my-skill
```

#### Created Structure

```
.claude/skills/my-skill/
├── SKILL.md        # Main skill instructions
└── references/     # Level 3 detailed documentation
```

#### Name Validation

- Must be lowercase
- Must be kebab-case (alphanumeric with hyphens)
- No spaces or special characters
- Example valid names: `database-queries`, `auth-patterns`, `ui-components`

---

### `validate` - Validate Skill Structure

Validate skill structure and progressive disclosure compliance.

#### Syntax

```bash
claude-skills-cli validate <skill-path> [options]
```

#### Options

| Option     | Type    | Description                            |
| ---------- | ------- | -------------------------------------- |
| `--strict` | boolean | Treat warnings as errors (exit code 1) |

#### Examples

```bash
# Validate skill
npx claude-skills-cli validate .claude/skills/my-skill

# Strict mode (warnings = errors)
npx claude-skills-cli validate .claude/skills/my-skill --strict
```

#### Validation Checks

**Level 1 (Metadata):**

- Description length: <200 chars (optimal), <300 chars (warning), <1024 chars (max)
- Description includes trigger keywords ("Use when...", "Use for...", "Use to...")
- Name format (lowercase, kebab-case)
- Name length (<64 chars)
- Name matches directory name

**Level 2 (SKILL.md Body):**

- Line count: ~50 (optimal), <80 (good), <150 (warning)
- Word count: <1000 (optimal), <5000 (max)
- Code blocks: 1-2 (optimal), ≤3 (good), >3 (warning)
- Sections: 3-5 (optimal), ≤8 (good), >8 (warning)
- "Quick Start" section present
- Links to references/ when body is long (>60 lines)
- No TODO placeholders

**Level 3 (References):**

- Referenced files exist (errors on broken links)
- No empty directories (warnings)
- Scripts are executable (warnings)
- Scripts have shebang (#!)

#### Exit Codes

| Code | Meaning                                       |
| ---- | --------------------------------------------- |
| 0    | Valid (no errors)                             |
| 1    | Invalid (has errors)                          |
| 1    | Valid but has warnings (only with `--strict`) |

---

### `doctor` - Fix Common Issues

Automatically fix common skill issues.

#### Syntax

```bash
claude-skills-cli doctor <skill-path>
```

#### What It Fixes

**Multi-line Descriptions:**
When formatters like Prettier wrap descriptions across multiple lines, Claude Code cannot recognize the skill. The doctor command:

1. Detects multi-line descriptions in YAML frontmatter
2. Adds `# prettier-ignore` comment before the description field
3. Reflows the description to a single line

#### Examples

```bash
# Fix multi-line description
npx claude-skills-cli doctor .claude/skills/my-skill

# Common workflow after formatting
npx prettier --write .claude/skills/my-skill/SKILL.md
npx claude-skills-cli doctor .claude/skills/my-skill
npx claude-skills-cli validate .claude/skills/my-skill
```

---

### `package` - Create Distribution Zip

Package skill into a zip file for distribution.

#### Syntax

```bash
claude-skills-cli package <skill-path> [options]
```

#### Options

| Option              | Type    | Description                         |
| ------------------- | ------- | ----------------------------------- |
| `--output <dir>`    | string  | Output directory (default: `dist/`) |
| `--skip-validation` | boolean | Skip validation before packaging    |

#### Examples

```bash
# Package skill (validates first)
npx claude-skills-cli package .claude/skills/my-skill

# Custom output directory
npx claude-skills-cli package .claude/skills/my-skill --output builds/
```

#### Distribution

The created zip can be:

1. Uploaded to Claude.ai (Settings > Features > Skills)
2. Uploaded via API (`/v1/skills` endpoint)
3. Shared with team members

---

## Common Workflows

### Create and Validate New Skill

```bash
# 1. Create skill
npx claude-skills-cli init --name database-queries \
  --description "SQLite queries. Use when writing SELECT, INSERT, UPDATE"

# 2. Edit SKILL.md
vim .claude/skills/database-queries/SKILL.md

# 3. Add references
vim .claude/skills/database-queries/references/schema.md

# 4. Validate
npx claude-skills-cli validate .claude/skills/database-queries

# 5. Package
npx claude-skills-cli package .claude/skills/database-queries
```

### Strict Validation in CI

```bash
# package.json
{
  "scripts": {
    "test:skills": "claude-skills-cli validate .claude/skills/* --strict"
  }
}

# Run in CI
npm run test:skills
```

### Batch Validate All Skills

```bash
# Bash script to validate all skills
for skill in .claude/skills/*/; do
  echo "Validating $skill"
  npx claude-skills-cli validate "$skill" || exit 1
done
```

---

## Resources

- [GitHub Repository](https://github.com/spences10/claude-skills-cli)
- [Anthropic Skills Documentation](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
- [Anthropic Skills Repository](https://github.com/anthropics/skills)
