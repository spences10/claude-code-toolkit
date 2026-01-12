# Marketplace Schema

Full schema for `.claude-plugin/marketplace.json`.

## Required Fields

| Field     | Type   | Description                         |
| --------- | ------ | ----------------------------------- |
| `name`    | string | Marketplace identifier (kebab-case) |
| `owner`   | object | Maintainer info                     |
| `plugins` | array  | List of plugin entries              |

### Owner Fields

| Field   | Required | Description     |
| ------- | -------- | --------------- |
| `name`  | Yes      | Maintainer name |
| `email` | No       | Contact email   |

## Optional Metadata

| Field                  | Description                        |
| ---------------------- | ---------------------------------- |
| `metadata.description` | Brief marketplace description      |
| `metadata.version`     | Marketplace version                |
| `metadata.pluginRoot`  | Base dir for relative source paths |

## Plugin Entries

### Required

| Field    | Type          | Description                    |
| -------- | ------------- | ------------------------------ |
| `name`   | string        | Plugin identifier (kebab-case) |
| `source` | string/object | Where to fetch plugin          |

### Optional

| Field         | Description                          |
| ------------- | ------------------------------------ |
| `description` | Brief plugin description             |
| `version`     | Plugin version                       |
| `author`      | Object with `name`, optional `email` |
| `homepage`    | Documentation URL                    |
| `repository`  | Source code URL                      |
| `license`     | SPDX identifier (MIT, Apache-2.0)    |
| `keywords`    | Discovery tags                       |
| `category`    | Organization category                |
| `strict`      | If `false`, no plugin.json needed    |

## Source Formats

### Relative Path

```json
{ "source": "./plugins/my-plugin" }
```

### GitHub

```json
{
  "source": {
    "source": "github",
    "repo": "owner/repo"
  }
}
```

### Git URL

```json
{
  "source": {
    "source": "url",
    "url": "https://gitlab.com/team/plugin.git"
  }
}
```

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
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./plugins/my-plugin",
      "description": "Does something useful",
      "version": "1.0.0",
      "author": { "name": "Your Name" },
      "category": "productivity",
      "keywords": ["utility", "workflow"]
    }
  ]
}
```

## Reserved Names

Cannot use: `claude-code-marketplace`, `claude-code-plugins`, `claude-plugins-official`, `anthropic-marketplace`, `anthropic-plugins`, `agent-skills`, `life-sciences`
