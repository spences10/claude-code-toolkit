# Validation Guide

Debugging plugin and marketplace validation errors.

## Run Validation

```bash
# From marketplace root
claude plugin validate .

# Or inside Claude Code
/plugin validate .
```

## Common Errors

### Missing Owner

```
owner: Invalid input: expected object, received undefined
```

**Fix**: Add owner object:

```json
{
  "owner": {
    "name": "Your Name"
  }
}
```

### Plugins as Strings

```
plugins.0: Invalid input: expected object, received string
```

**Fix**: Change from strings to objects:

```json
// Wrong
"plugins": ["my-plugin", "other-plugin"]

// Correct
"plugins": [
  { "name": "my-plugin", "source": "./plugins/my-plugin" },
  { "name": "other-plugin", "source": "./plugins/other-plugin" }
]
```

### Invalid Source Path

```
plugins.0.source: Invalid input
```

**Fix**: Use `./` prefix for relative paths:

```json
// Wrong
"source": "plugins/my-plugin"

// Correct
"source": "./plugins/my-plugin"
```

### Path Traversal

```
plugins.0.source: Path traversal not allowed
```

**Fix**: Don't use `..` in paths. Restructure so plugin is inside marketplace.

### Duplicate Plugin Names

```
Duplicate plugin name "x" found in marketplace
```

**Fix**: Give each plugin a unique `name` value.

### Missing plugin.json

```
Plugin source must contain plugin.json
```

**Fix**: Either:

1. Create `.claude-plugin/plugin.json` in plugin directory
2. Set `"strict": false` in marketplace entry

## Warnings (Non-blocking)

| Warning                               | Meaning                    |
| ------------------------------------- | -------------------------- |
| `Marketplace has no plugins defined`  | Add plugins to array       |
| `No marketplace description provided` | Add `metadata.description` |
| `npm source not fully implemented`    | Use github or local paths  |

## Debugging Steps

1. **Check JSON syntax**: Missing commas, unquoted strings
2. **Verify paths exist**: `ls ./plugins/my-plugin`
3. **Check plugin.json exists**: `ls ./plugins/my-plugin/.claude-plugin/`
4. **Compare to working example**: Check svelte-skills-kit or official demos
