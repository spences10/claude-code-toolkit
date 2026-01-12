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

| Field        | Type          | Description                                  |
| ------------ | ------------- | -------------------------------------------- |
| `commands`   | string/array  | Custom command paths                         |
| `agents`     | string/array  | Custom agent paths                           |
| `hooks`      | string/object | Hooks config or path                         |
| `mcpServers` | string/object | MCP server configs                           |
| `lspServers` | string/object | LSP server configs                           |
| `skills`     | array         | Skill names (auto-discovered from `skills/`) |

## Post-Install Message

```json
{
  "postInstall": {
    "message": "Plugin installed! Run /my-command to get started."
  }
}
```

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

```json
{
  "name": "code-review",
  "description": "Adds code review commands and agents",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  },
  "keywords": ["review", "code-quality"],
  "postInstall": {
    "message": "Run /review to review code changes."
  }
}
```

## Auto-Discovery

Claude Code automatically discovers:

- `commands/*.md` → Slash commands
- `agents/*.md` → Sub-agents
- `skills/*/SKILL.md` → Skills
- `hooks/hooks.json` → Hooks

Override with explicit paths in plugin.json if needed.
