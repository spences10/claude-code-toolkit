# Anthropic Resources - Official Guidance

Key insights from Anthropic's official Agent Skills documentation.

**Sources**:

- [Agent Skills Overview](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
- [Engineering Blog](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [Product Announcement](https://www.anthropic.com/news/skills)

---

## The Progressive Disclosure System

**Core Design Principle**: Skills load information in stages as needed, rather than consuming context upfront.

### The 3-Level Loading System

| Level  | File                                           | Context Window             | Token Budget | When Loaded   |
| ------ | ---------------------------------------------- | -------------------------- | ------------ | ------------- |
| **1**  | SKILL.md Metadata (YAML)                       | Always loaded              | ~100 tokens  | At startup    |
| **2**  | SKILL.md Body (Markdown)                       | Loaded when skill triggers | <5k tokens   | When relevant |
| **3+** | Bundled files (references/, scripts/, assets/) | Loaded as needed by Claude | Unlimited\*  | On-demand     |

\*No practical limit - files only load when accessed

### Why This Matters

> "Like a well-organized manual that starts with a table of contents, then specific chapters, and finally a detailed appendix, skills let Claude load information only as needed."
>
> — Anthropic Engineering Blog

**Benefits**:

- Install many skills without context penalty
- Claude only knows each skill exists and when to use it (Level 1)
- Detailed content doesn't consume tokens until needed
- Effectively unbounded context per skill (via Level 3)

---

## How Skills Work

### Skill Discovery and Loading

1. **Startup**: Claude pre-loads `name` and `description` of every installed skill into system prompt
2. **User request**: User makes a request that might need a skill
3. **Skill matching**: Claude scans available skills to find relevant matches
4. **Skill loading**: If relevant, Claude reads SKILL.md from filesystem via bash
5. **On-demand access**: Claude reads additional files (references/, scripts/) as needed

### The Filesystem Architecture

Skills run in a code execution environment where Claude has:

- **Filesystem access**: Skills exist as directories on a virtual machine
- **Bash commands**: Claude uses bash to read files and execute scripts
- **Code execution**: Scripts run without loading code into context

**Key insight**: Script code never enters the context window. Only the output does. This makes scripts far more token-efficient than generating equivalent code on the fly.

---

## Official Best Practices

### 1. Start with Evaluation

> "Identify specific gaps in your agents' capabilities by running them on representative tasks and observing where they struggle or require additional context. Then build skills incrementally to address these shortcomings."

**Process**:

- Use Claude on real tasks
- Notice where it struggles
- Create skills to fill gaps
- Test and iterate

### 2. Structure for Scale

> "When the SKILL.md file becomes unwieldy, split its content into separate files and reference them."

**Guidelines**:

- Keep SKILL.md under ~5k words
- Split mutually exclusive contexts into separate files
- Use code for both execution and documentation
- Make it clear whether Claude should run or read scripts

### 3. Think from Claude's Perspective

> "Monitor how Claude uses your skill in real scenarios and iterate based on observations: watch for unexpected trajectories or overreliance on certain contexts."

**Key areas**:

- `name` and `description` drive skill triggering
- Claude decides whether to use the skill based on metadata
- Observe actual usage patterns, not assumed ones

### 4. Iterate with Claude

> "As you work on a task with Claude, ask Claude to capture its successful approaches and common mistakes into reusable context and code within a skill."

**Workflow** (Claude A creates, Claude B tests):

1. Complete a task with Claude A using normal prompting
2. Identify reusable patterns from the conversation
3. Ask Claude A to create a skill capturing those patterns
4. Review for conciseness — remove what Claude already knows
5. Test with Claude B (fresh instance with skill loaded) on similar tasks
6. If Claude B struggles, return to Claude A with specifics to refine

> "Claude models understand the Skill format and structure natively. You don't need special system prompts or a 'writing skills' skill to get Claude to help create Skills."

### 5. Set Appropriate Degrees of Freedom

> Match the level of specificity to the task's fragility and variability.

- **High freedom** (text instructions): Output varies by context, Claude's judgment adds value
- **Medium freedom** (pseudocode/scripts with params): Process is consistent but details vary
- **Low freedom** (exact scripts): Exact execution matters — migrations, compliance, deployments

### 6. Test with All Models

> "Skills act as additions to models, so effectiveness depends on the underlying model."

What works for Opus may need more detail for Haiku. If using across models, aim for instructions that work with all of them.

---

## Writing for Claude

### Skills as "Onboarding Guides"

> "Building a skill for an agent is like putting together an onboarding guide for a new hire."
>
> — Anthropic Engineering Blog

**What this means**:

- Focus on procedural knowledge ("how to do X")
- Include workflows, not just facts
- Provide examples of actual usage
- Capture organizational context

### Skills Transform General → Specialized Agents

> "Skills extend Claude's capabilities by packaging your expertise into composable resources for Claude, transforming general-purpose agents into specialized agents that fit your needs."

**Examples**:

- General Claude + Database skill = Database specialist
- General Claude + Auth skill = Security specialist
- General Claude + UI skill = Frontend specialist

---

## The Skill Anatomy

### Required Structure

Every skill must have:

```
skill-name/
└── SKILL.md          # Required
```

SKILL.md must have:

```markdown
---
name: skill-name
description: What it does and when to use it
---

# Skill content...
```

### Frontmatter Limits

| Field         | Limit           | Required |
| ------------- | --------------- | -------- |
| `name`        | 64 characters   | Yes      |
| `description` | 1024 characters | Yes      |

Only `name` and `description` are required and universally supported. No other YAML fields are recognized in Claude Code.

**Name restrictions**:

- Lowercase letters, numbers, and hyphens only
- Cannot contain "anthropic" or "claude" (reserved words)
- Cannot contain XML tags (`<` or `>`)
- Prefer gerund form: `processing-pdfs`, `analyzing-spreadsheets`

**Description restrictions**:

- Cannot contain XML tags
- Write in **third person** (injected into system prompt)

**Known discrepancy**: Some Anthropic documentation references `allowed-tools`, `license`, `compatibility`, and `metadata` frontmatter fields. These fields are **not supported** in Claude Code and will be ignored. The Complete Guide PDF mentions them for API/claude.ai contexts only.

### Optional Bundled Content

```
skill-name/
├── SKILL.md                    # Level 2: Instructions
├── references/                 # Level 3: Documentation
│   ├── detailed-guide.md
│   └── api-reference.md
├── scripts/                    # Level 3: Executable code
│   ├── validate.js
│   └── generate.sh
└── assets/                     # Level 3: Resources
    ├── template.json
    └── diagram.png
```

---

## Code Execution in Skills

### Why Include Scripts

> "Large language models excel at many tasks, but certain operations are better suited for traditional code execution. For example, sorting a list via token generation is far more expensive than simply running a sorting algorithm."
>
> — Anthropic Engineering Blog

**When to use scripts**:

- **Efficiency**: Operations that are cheaper to execute than generate
- **Determinism**: Tasks requiring consistent, repeatable results
- **Complexity**: Algorithms better suited to code than token generation

### Script Execution Model

```bash
# Claude runs script
bash: node scripts/validate_form.js form.pdf

# Output (only this enters context)
✅ All form fields valid
Found 12 fillable fields
```

**Context consumed**: ~20 tokens (just the output)
**Alternative (Claude generates validation code)**: ~500 tokens

**50x more efficient**

---

## Security Considerations

### Trusted Sources Only

> "We strongly recommend using Skills only from trusted sources: those you created yourself or obtained from Anthropic."

**Risk**: Malicious skills can:

- Direct Claude to invoke tools in harmful ways
- Execute code with unintended effects
- Exfiltrate data to external systems
- Compromise system security

### Auditing Third-Party Skills

If you must use untrusted skills:

1. **Review all files**: SKILL.md, scripts, images, bundled resources
2. **Check for unusual patterns**:
   - Unexpected network calls
   - File access beyond skill scope
   - Operations not matching stated purpose
3. **Examine external sources**: Skills fetching from URLs are risky
4. **Verify dependencies**: Check code dependencies and imports

### Runtime Constraints

Runtime constraints vary by platform:

- **Claude API**: No network access, no runtime package installation, sandboxed execution
- **Claude.ai**: Varying network access depending on user/admin settings
- **Claude Code**: Full network access (same as any program on the user's machine), but global package installation is discouraged

---

## Skills are Composable

> "Skills stack together. Claude automatically identifies which skills are needed and coordinates their use."
>
> — Anthropic Product Announcement

### Example: Multi-Skill Task

**User request**: "Create a GitHub contact card with database-backed favorites"

**Skills activated**:

1. `github-integration` - Fetch profile data
2. `database-patterns` - Query favorites table
3. `ui-components` - Build card component
4. `styling-patterns` - Apply CSS/styles

**Result**: Skills work together naturally, each handling its domain.

---

## Where Skills Work

### Claude.ai

- **Pre-built Skills**: PowerPoint, Excel, Word, PDF (automatic)
- **Custom Skills**: Upload as zip (Settings > Capabilities > Skills)
- **Sharing**: Individual user only (not org-wide, no central admin management)

### Claude API

- **Pre-built Skills**: Reference by `skill_id` (e.g., `pptx`, `xlsx`)
- **Custom Skills**: Upload via `/v1/skills` endpoints
- **Sharing**: Workspace-wide
- **Requires beta headers**: `code-execution-2025-08-25`, `skills-2025-10-02`, `files-api-2025-04-14`

### Claude Code

- **Custom Skills only**: Filesystem-based (`.claude/skills/` or `~/.claude/skills/`)
- **Sharing**: Via git/version control or Claude Code Plugins

### Claude Agent SDK

- **Custom Skills**: Filesystem-based in `.claude/skills/`
- Enable by including `"Skill"` in `allowed_tools` configuration

**Important**: Custom Skills do not sync across surfaces. Upload separately for each platform.

---

## Key Quotes

### On Progressive Disclosure

> "Progressive disclosure is the core design principle that makes Agent Skills flexible and scalable."

### On Simplicity

> "Skills are a simple concept with a correspondingly simple format. This simplicity makes it easier for organizations, developers, and end users to build customized agents and give them new capabilities."

### On Filesystem Architecture

> "Agents with a filesystem and code execution tools don't need to read the entirety of a skill into their context window when working on a particular task. This means that the amount of context that can be bundled into a skill is effectively unbounded."

### On Purpose

> "Think of Skills as custom onboarding materials that let you package expertise, making Claude a specialist on what matters most to you."

---

## Official Resources

### Documentation

- [Agent Skills Overview](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
- [Quickstart Tutorial](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/quickstart)
- [Best Practices](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices)
- [API Skills Guide](https://docs.claude.com/en/build-with-claude/skills-guide)
- [Skills in Claude Code](https://code.claude.com/docs/en/skills)
- [Skills in Agent SDK](https://docs.claude.com/en/agent-sdk/skills)
- [Agent Skills Standard](https://agentskills.io/)

### Guides

- [The Complete Guide to Building Skills for Claude](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf) (PDF)
- [Skills Cookbook](https://platform.claude.com/cookbook/skills-notebooks-01-skills-introduction)

### Examples

- [Skills Repository](https://github.com/anthropics/skills)

### Articles

- [Product Announcement](https://www.anthropic.com/news/skills)
- [Engineering Blog](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)

---

## Skill Categories

Skills generally fall into these categories:

### Domain Knowledge Skills

Encode expertise about a specific domain, technology, or codebase:
- Project context and conventions
- API documentation and patterns
- Database schema and query patterns

### Workflow Skills

Guide Claude through multi-step processes:
- Code review checklists
- Deployment procedures
- Testing workflows
- Data migration steps

### Tool Integration Skills

Bridge Claude to external tools and systems:
- MCP server usage patterns (see [mcp-integration.md](mcp-integration.md))
- CLI tool documentation
- Service-specific workflows

### Generator Skills

Create or transform content:
- Code scaffolding with scripts
- Document generation from templates
- Data transformation pipelines

---

## Workflow Patterns

### Linear Workflow

Skill guides Claude through ordered steps:

```markdown
## Deployment Process
1. Run validation: `node scripts/validate.js`
2. Build the project
3. Run tests
4. Deploy to staging
5. Verify staging
6. Deploy to production
```

### Decision Tree Workflow

Skill provides branching logic based on conditions:

```markdown
## Error Handling
- If HTTP 401 → Re-authenticate, retry once
- If HTTP 429 → Wait and retry with backoff
- If HTTP 5xx → Log error, alert, do not retry
```

### Iterative Workflow

Skill defines a loop for refinement:

```markdown
## Review Cycle
1. Run linter
2. Fix reported issues
3. Run tests
4. If failures remain, return to step 2
5. Submit for review
```

---

## Anti-Patterns (Official)

### Avoid Deeply Nested References

> Keep references one level deep from SKILL.md. Claude may partially read files when they're referenced from other referenced files.

### Avoid Too Many Options

> Provide a default with an escape hatch, not a menu of choices.

### Avoid Time-Sensitive Information

> Use "Old patterns" sections with `<details>` instead of date-conditional instructions.

### Avoid Windows-Style Paths

> Always use forward slashes. Unix paths work everywhere; Windows paths fail on Unix.

### No README.md in Skill Folder

> All documentation goes in SKILL.md or references/. Repository-level README is separate.

---

## Official Workflow Patterns

### Checklist Pattern

Provide a checklist Claude copies and tracks through multi-step tasks.

### Feedback Loop Pattern

Run validator → fix errors → repeat until passing. Greatly improves output quality.

### Plan-Validate-Execute Pattern

For complex tasks: create structured plan file → validate with script → execute. Catches errors before they propagate.

### Template Pattern

Provide output templates. Match strictness to requirements — "ALWAYS use this exact structure" vs "sensible default, use judgment."

### Examples Pattern

Input/output pairs for output-quality-dependent skills. Examples communicate style and detail better than descriptions.

### Conditional Workflow Pattern

Guide Claude through decision points with branching logic.

---

## Summary: The Anthropic Philosophy

**Skills are**:

- Composable (stack together)
- Portable (same format everywhere)
- Efficient (only load what's needed)
- Powerful (include executable code)

**Build like**:

- Onboarding guides (procedural knowledge)
- Specialized tools (domain expertise)
- Reference manuals (progressive detail)

**Optimize for**:

- Token efficiency (3-level loading)
- Claude's perspective (discovery via metadata)
- Real usage (iterate based on observation)
- Scalability (split when too large)
