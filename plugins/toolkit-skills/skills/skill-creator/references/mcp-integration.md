# MCP Server Integration

Patterns for integrating MCP (Model Context Protocol) servers with skills.

## When to Use MCP vs Direct Tools

### Use Direct Tools When

- Reading/writing files on the local filesystem
- Running shell commands
- Searching code with grep/glob
- Standard development operations

### Use MCP When

- Accessing external services (databases, APIs, SaaS platforms)
- The operation requires a specialized protocol or authentication
- You need structured resource access beyond filesystem reads
- Bridging Claude to tools that don't have native support

## MCP in Skills Context

Skills and MCP servers are complementary:

- **Skills** provide context, instructions, and domain knowledge
- **MCP servers** provide tool access to external systems
- A skill can instruct Claude on *when* and *how* to use MCP tools

### Example: Database Skill + MCP

A skill provides query patterns and schema knowledge. An MCP server provides the actual database connection tool.

```markdown
# In SKILL.md
## Database Queries

Use the `mcp__db__query` tool for all read operations.
Use the `mcp__db__execute` tool for write operations.

Always use parameterized queries:
- Read: `mcp__db__query` with `sql` and `params` parameters
- Write: `mcp__db__execute` with `sql` and `params` parameters
```

### Example: External API Skill + MCP

```markdown
# In SKILL.md
## Fetching Data

Use `mcp__api__request` for all external API calls.
Include the authorization header from the environment config.
```

## Patterns

### Pattern 1: Skill as MCP Tool Guide

The skill documents which MCP tools to use, when, and with what parameters. The skill content acts as a usage manual for available MCP tools.

```markdown
## Available Tools

- `mcp__service__list_items` - Fetch items with optional filters
- `mcp__service__create_item` - Create new item (requires `name`, `type`)
- `mcp__service__delete_item` - Delete by ID (irreversible)

## Workflows

### Adding a new item
1. Check for duplicates with `mcp__service__list_items`
2. Create with `mcp__service__create_item`
3. Verify with `mcp__service__list_items`
```

### Pattern 2: Skill Scripts That Call MCP Indirectly

Scripts in a skill cannot call MCP tools directly. Instead, scripts handle data preparation, and the skill instructs Claude to pass script output to MCP tools.

```markdown
## Data Import Workflow

1. Run `node scripts/transform-csv.js input.csv` to normalize data
2. Pass each row from the output to `mcp__db__execute` for insertion
```

### Pattern 3: Resource-Aware Skills

If an MCP server exposes resources (read-only data), a skill can reference them:

```markdown
## Configuration

Read the current config from `mcp__config__read_resource` before making changes.
Compare against the schema in [references/config-schema.md](references/config-schema.md).
```

## Limitations

- Skills cannot directly invoke MCP tools — only Claude can
- MCP servers must be configured separately from skills (in Claude settings or project config)
- Skills should document MCP tool names but cannot guarantee they are available
- Add a fallback note: "If `mcp__X__Y` is not available, use [alternative approach]"

## Checklist

- [ ] Skill documents which MCP tools to use and when
- [ ] Parameter requirements are specified for each MCP tool reference
- [ ] Fallback approaches documented for when MCP tools are unavailable
- [ ] Scripts handle data prep, Claude handles MCP tool invocation
- [ ] MCP tool names match the actual configured server naming
