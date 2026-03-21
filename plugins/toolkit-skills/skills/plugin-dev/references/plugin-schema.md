# Plugin Schema

Full schema for `.claude-plugin/plugin.json`.

## Required Fields

| Field  | Type   | Description                                                                                                        |
| ------ | ------ | ------------------------------------------------------------------------------------------------------------------ |
| `name` | string | Unique identifier (kebab-case, no spaces). Also the **skill namespace** — skills become `/plugin-name:skill-name`. |

## Metadata Fields

| Field         | Type   | Description                                                                                             |
| ------------- | ------ | ------------------------------------------------------------------------------------------------------- |
| `version`     | string | Semantic version (`MAJOR.MINOR.PATCH`). If also set in marketplace entry, `plugin.json` takes priority. |
| `description` | string | Brief explanation of plugin purpose                                                                     |
| `author`      | object | Author info: `name` (required), `email` (optional), `url` (optional)                                    |
| `homepage`    | string | Documentation URL                                                                                       |
| `repository`  | string | Source code URL                                                                                         |
| `license`     | string | SPDX identifier (MIT, Apache-2.0)                                                                       |
| `keywords`    | array  | Discovery tags                                                                                          |

## Component Path Fields

| Field          | Type          | Default Location   | Description                                          |
| -------------- | ------------- | ------------------ | ---------------------------------------------------- |
| `commands`     | string/array  | `commands/`        | Skill Markdown files (legacy; use `skills/` for new) |
| `agents`       | string/array  | `agents/`          | Custom agent definitions                             |
| `skills`       | string/array  | `skills/`          | Agent Skills with `SKILL.md` files                   |
| `hooks`        | string/object | `hooks/hooks.json` | Hook config paths or inline config                   |
| `mcpServers`   | string/object | `.mcp.json`        | MCP server configs or path                           |
| `lspServers`   | string/object | `.lsp.json`        | LSP server configs or path                           |
| `outputStyles` | string/array  | —                  | Output style files/directories                       |
| `strict`       | boolean       | —                  | Strict validation mode (default: true)               |

## Directory Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json      # Plugin manifest (only file here!)
├── commands/            # Slash commands (.md files) — legacy
├── agents/              # Sub-agents (.md files)
├── skills/              # Skills (SKILL.md in subdirs)
├── hooks/               # Hook definitions (hooks.json)
├── scripts/             # Executable scripts
├── settings.json        # Default settings (only `agent` key supported)
├── .mcp.json            # MCP server definitions
├── .lsp.json            # LSP server configurations
├── LICENSE
└── CHANGELOG.md
```

**Critical**: Do NOT put `commands/`, `agents/`, `skills/`, or `hooks/` inside `.claude-plugin/`. Only `plugin.json` goes there.

## Default Settings

Plugins can ship a `settings.json` at plugin root. Currently only `agent` key is supported — activates a custom agent as the main thread:

```json
{
  "agent": "security-reviewer"
}
```

## Environment Variables

Use `${CLAUDE_PLUGIN_ROOT}` in hooks, MCP configs, and scripts to reference the plugin's installed location:

```json
{
  "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format-code.sh"
}
```

## Auto-Discovery

Claude Code automatically discovers:

- `commands/*.md` → Slash commands
- `agents/*.md` → Sub-agents
- `skills/*/SKILL.md` → Skills
- `hooks/hooks.json` → Hooks
- `.mcp.json` → MCP servers
- `.lsp.json` → LSP servers

Override with explicit paths in plugin.json if needed.

## Examples

Minimal plugin.json:

```json
{
  "name": "code-review"
}
```

Recommended plugin.json:

```json
{
  "name": "code-review",
  "description": "Adds code review commands and agents",
  "version": "1.0.0",
  "author": {
    "name": "Your Name",
    "url": "https://github.com/yourname"
  },
  "keywords": ["review", "code-quality"],
  "license": "MIT"
}
```

Full plugin.json with component paths:

```json
{
  "name": "enterprise-tools",
  "version": "2.1.0",
  "description": "Enterprise workflow automation",
  "author": {
    "name": "Enterprise Team",
    "email": "dev@example.com"
  },
  "homepage": "https://docs.example.com/plugin",
  "repository": "https://github.com/company/plugin",
  "license": "MIT",
  "keywords": ["enterprise", "workflow"],
  "commands": ["./custom/commands/"],
  "agents": ["./agents/security-reviewer.md"],
  "skills": "./custom/skills/",
  "hooks": "./config/hooks.json",
  "mcpServers": "./mcp-config.json",
  "lspServers": "./.lsp.json",
  "outputStyles": "./styles/"
}
```

## Installation Scopes

| Scope     | Settings file                 | Use case                                 |
| --------- | ----------------------------- | ---------------------------------------- |
| `user`    | `~/.claude/settings.json`     | Personal plugins, all projects (default) |
| `project` | `.claude/settings.json`       | Team plugins shared via VCS              |
| `local`   | `.claude/settings.local.json` | Project-specific, gitignored             |
| `managed` | Managed settings              | Read-only, update only                   |

```bash
# Install to specific scope
claude plugin install formatter@marketplace --scope project
```

## Not Supported

These fields are **not currently implemented** (feature requests exist):

| Field           | Status                                                                      |
| --------------- | --------------------------------------------------------------------------- |
| `postInstall`   | Requested in [#9394](https://github.com/anthropics/claude-code/issues/9394) |
| `postUpdate`    | Requested in [#9394](https://github.com/anthropics/claude-code/issues/9394) |
| `postUninstall` | Requested in [#9394](https://github.com/anthropics/claude-code/issues/9394) |

## Official Resources

- [Create plugins](https://code.claude.com/docs/en/plugins)
- [Plugins reference](https://code.claude.com/docs/en/plugins-reference)
- [Anthropic skills repo](https://github.com/anthropics/skills)
