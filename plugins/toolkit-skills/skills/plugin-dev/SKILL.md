---
name: plugin-dev
description: "Validate, test, and distribute Claude Code plugins and marketplaces. Use when developing plugins, debugging validation errors, or preparing for distribution."
---

# Plugin Development

Develop and distribute Claude Code plugins and marketplaces.

## Quick Commands

```bash
# Validate marketplace/plugin
claude plugin validate .

# Test local install
/plugin marketplace add ./path/to/marketplace
/plugin install my-plugin@marketplace-name

# Check installed plugins
/plugin list
```

## Marketplace Schema

Required fields in `.claude-plugin/marketplace.json`:

```json
{
  "name": "marketplace-name",
  "owner": { "name": "Your Name" },
  "plugins": [
    {
      "name": "plugin-name",
      "source": "./plugins/plugin-name",
      "description": "What it does"
    }
  ]
}
```

## Plugin Schema

Required field in `.claude-plugin/plugin.json` (only `name` is required):

```json
{
  "name": "plugin-name",
  "description": "What it does",
  "version": "1.0.0"
}
```

The `name` is also the **skill namespace** — skills become `/plugin-name:skill-name`.

## Development

```bash
# Test plugin locally without installing
claude --plugin-dir ./my-plugin

# Reload after changes (inside Claude Code)
/reload-plugins
```

## Common Errors

| Error                               | Fix                                              |
| ----------------------------------- | ------------------------------------------------ |
| `owner: expected object`            | Add `"owner": { "name": "..." }`                 |
| `plugins.0: expected object`        | Change string array to object array              |
| `source: Invalid input`             | Use `./path/to/plugin` format                    |
| Components inside `.claude-plugin/` | Move `commands/`, `skills/`, etc. to plugin root |

## References

- [marketplace-schema.md](references/marketplace-schema.md) - Full marketplace fields
- [plugin-schema.md](references/plugin-schema.md) - Full plugin fields
- [validation-guide.md](references/validation-guide.md) - Debugging validation errors
- [distribution.md](references/distribution.md) - Publishing, versioning, and release channels
