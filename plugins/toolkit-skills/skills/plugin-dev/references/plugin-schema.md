# Plugin Schema

Full schema for `.claude-plugin/plugin.json`.

## Required Fields

| Field         | Type   | Description                    |
| ------------- | ------ | ------------------------------ |
| `name`        | string | Plugin identifier (kebab-case) |
| `description` | string | What the plugin does           |
| `version`     | string | Semantic version               |

## Optional Fields

| Field        | Type   | Description                           |
| ------------ | ------ | ------------------------------------- |
| `author`     | object | `name` (required), `email` (optional) |
| `homepage`   | string | Documentation URL                     |
| `repository` | string | Source code URL                       |
| `license`    | string | SPDX identifier                       |
| `keywords`   | array  | Discovery tags                        |

## Component Configuration

| Field        | Type          | Description             |
| ------------ | ------------- | ----------------------- |
| `commands`   | string/array  | Custom command paths    |
| `agents`     | string/array  | Custom agent paths      |
| `hooks`      | string/object | Hooks config or path    |
| `mcpServers` | string/object | MCP server configs      |
| `lspServers` | string/object | LSP server configs      |
| `skills`     | array         | Skill paths (see below) |
| `strict`     | boolean       | Strict validation mode  |

### Skills Field

If specified, must be an array of **paths** (not names):

```json
{
  "skills": ["./skills/my-skill", "./skills/other-skill"]
}
```

**Recommended:** Omit this field and rely on auto-discovery instead.

## Directory Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json      # Plugin manifest
├── commands/            # Slash commands (.md files)
├── agents/              # Sub-agents (.md files)
├── skills/              # Skills (SKILL.md in subdirs)
├── hooks/               # Hook definitions
└── scripts/             # Executable scripts
```

## Example

Minimal plugin.json (recommended):

```json
{
  "name": "code-review",
  "description": "Adds code review commands and agents",
  "version": "1.0.0"
}
```

With optional metadata:

```json
{
  "name": "code-review",
  "description": "Adds code review commands and agents",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  },
  "keywords": ["review", "code-quality"]
}
```

## Auto-Discovery

Claude Code automatically discovers:

- `commands/*.md` → Slash commands
- `agents/*.md` → Sub-agents
- `skills/*/SKILL.md` → Skills
- `hooks/hooks.json` → Hooks

Override with explicit paths in plugin.json if needed.

## Not Supported

These fields are **not currently implemented** (feature requests exist):

| Field           | Status                                                                      |
| --------------- | --------------------------------------------------------------------------- |
| `postInstall`   | Requested in [#9394](https://github.com/anthropics/claude-code/issues/9394) |
| `postUpdate`    | Requested in [#9394](https://github.com/anthropics/claude-code/issues/9394) |
| `postUninstall` | Requested in [#9394](https://github.com/anthropics/claude-code/issues/9394) |

## Sources

- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference)
- [Anthropic skills repo](https://github.com/anthropics/skills)
