# Marketplace Schema

Full schema for `.claude-plugin/marketplace.json`.

## Required Fields

| Field     | Type   | Description                                                                                                  |
| --------- | ------ | ------------------------------------------------------------------------------------------------------------ |
| `name`    | string | Marketplace identifier (kebab-case). Public-facing: users see it in `/plugin install tool@your-marketplace`. |
| `owner`   | object | Maintainer info                                                                                              |
| `plugins` | array  | List of plugin entries                                                                                       |

### Owner Fields

| Field   | Required | Description     |
| ------- | -------- | --------------- |
| `name`  | Yes      | Maintainer name |
| `email` | No       | Contact email   |

## Optional Metadata

| Field                  | Description                                                                                                                                           |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `metadata.description` | Brief marketplace description                                                                                                                         |
| `metadata.version`     | Marketplace version                                                                                                                                   |
| `metadata.pluginRoot`  | Base dir prepended to relative source paths (e.g., `"./plugins"` lets you write `"source": "formatter"` instead of `"source": "./plugins/formatter"`) |

## Plugin Entries

Each entry in `plugins` can include any field from the plugin manifest schema (description, version, author, commands, hooks, etc.) plus marketplace-specific fields.

### Required

| Field    | Type          | Description                                                                        |
| -------- | ------------- | ---------------------------------------------------------------------------------- |
| `name`   | string        | Plugin identifier (kebab-case). Public-facing: `/plugin install name@marketplace`. |
| `source` | string/object | Where to fetch plugin (see [Source Formats](#source-formats))                      |

### Optional

| Field         | Type    | Description                                                      |
| ------------- | ------- | ---------------------------------------------------------------- |
| `description` | string  | Brief plugin description                                         |
| `version`     | string  | Plugin version. `plugin.json` takes priority if both set.        |
| `author`      | object  | `name` (required), `email` (optional), `url` (optional)          |
| `homepage`    | string  | Documentation URL                                                |
| `repository`  | string  | Source code URL                                                  |
| `license`     | string  | SPDX identifier (MIT, Apache-2.0)                                |
| `keywords`    | array   | Discovery tags                                                   |
| `category`    | string  | Organization category                                            |
| `tags`        | array   | Tags for searchability                                           |
| `strict`      | boolean | Controls plugin.json authority (see [Strict Mode](#strict-mode)) |

### Component Override Fields

These can also appear in marketplace entries:

| Field        | Type          | Description          |
| ------------ | ------------- | -------------------- |
| `commands`   | string/array  | Custom command paths |
| `agents`     | string/array  | Custom agent paths   |
| `hooks`      | string/object | Hooks config or path |
| `mcpServers` | string/object | MCP server configs   |
| `lspServers` | string/object | LSP server configs   |

## Source Formats

All sources are cached to `~/.claude/plugins/cache` on install.

### Relative Path

```json
{ "source": "./plugins/my-plugin" }
```

Must start with `./`. No `../` path traversal allowed. Relative to the marketplace root (where `.claude-plugin/marketplace.json` lives).

### GitHub

```json
{
  "source": {
    "source": "github",
    "repo": "owner/repo"
  }
}
```

With version pinning:

```json
{
  "source": {
    "source": "github",
    "repo": "owner/repo",
    "ref": "v2.0.0",
    "sha": "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0"
  }
}
```

| Field  | Type   | Description                                          |
| ------ | ------ | ---------------------------------------------------- |
| `repo` | string | Required. GitHub `owner/repo` format                 |
| `ref`  | string | Optional. Branch or tag (defaults to default branch) |
| `sha`  | string | Optional. Full 40-char commit SHA for exact pinning  |

### Git URL

```json
{
  "source": {
    "source": "url",
    "url": "https://gitlab.com/team/plugin.git"
  }
}
```

Supports `ref` and `sha` like GitHub. The `.git` suffix is optional (Azure DevOps, AWS CodeCommit URLs work).

### Git Subdirectory (Monorepos)

```json
{
  "source": {
    "source": "git-subdir",
    "url": "https://github.com/acme-corp/monorepo.git",
    "path": "tools/claude-plugin"
  }
}
```

Clones sparsely to minimize bandwidth. Supports `ref` and `sha`.

| Field  | Type   | Description                                  |
| ------ | ------ | -------------------------------------------- |
| `url`  | string | Required. Git URL, `owner/repo`, or SSH URL  |
| `path` | string | Required. Subdirectory containing the plugin |
| `ref`  | string | Optional. Branch or tag                      |
| `sha`  | string | Optional. Commit SHA for exact pinning       |

### npm Package

```json
{
  "source": {
    "source": "npm",
    "package": "@acme/claude-plugin",
    "version": "^2.0.0"
  }
}
```

| Field      | Type   | Description                                              |
| ---------- | ------ | -------------------------------------------------------- |
| `package`  | string | Required. Package name (e.g., `@org/plugin`)             |
| `version`  | string | Optional. Version or range (`2.1.0`, `^2.0.0`, `~1.5.0`) |
| `registry` | string | Optional. Custom npm registry URL                        |

## Strict Mode

| Value            | Behavior                                                                                                                      |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `true` (default) | `plugin.json` is authority. Marketplace supplements with additional components. Both merged.                                  |
| `false`          | Marketplace entry is entire definition. If plugin also has `plugin.json` with components, it **conflicts and fails to load**. |

Use `strict: false` when:

- Plugin has no `plugin.json` (set `"strict": false` in marketplace entry to skip validation)
- Marketplace defines all components inline

## Example

```json
{
  "name": "my-marketplace",
  "owner": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "metadata": {
    "description": "My awesome plugins",
    "version": "1.0.0",
    "pluginRoot": "./plugins"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./plugins/my-plugin",
      "description": "Does something useful",
      "version": "1.0.0",
      "author": { "name": "Your Name" },
      "category": "productivity",
      "keywords": ["utility", "workflow"],
      "tags": ["automation"]
    },
    {
      "name": "external-plugin",
      "source": {
        "source": "github",
        "repo": "company/plugin",
        "ref": "stable"
      },
      "description": "From external repo with pinned branch"
    }
  ]
}
```

## Reserved Names

Cannot use as marketplace name:

`claude-code-marketplace`, `claude-code-plugins`, `claude-plugins-official`, `anthropic-marketplace`, `anthropic-plugins`, `agent-skills`, `knowledge-work-plugins`, `life-sciences`, `official-claude-plugins`, `anthropic-tools-v2`

## Official Resources

- [Create and distribute a marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
- [Plugins reference](https://code.claude.com/docs/en/plugins-reference)
