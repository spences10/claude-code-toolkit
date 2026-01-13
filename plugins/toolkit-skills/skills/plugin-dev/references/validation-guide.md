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

## Hook Validation Errors

### Schema validation failed: ok expected boolean

```
Stop hook error: Schema validation failed: [{"expected": "boolean", "path": ["ok"]}]
```

**Cause**: Docs show `{decision, reason}` schema but internal schema is `{ok: boolean, reason?: string}`.

**Fix**: Use natural language, don't mention JSON. Add `model: sonnet`:

```json
{
  "type": "prompt",
  "model": "sonnet",
  "prompt": "Evaluate if the task is complete. If more work needed, condition is NOT met."
}
```

**Why this works**: Claude Code wraps your prompt with an internal evaluation prompt that forces the correct schema. Asking for JSON in your prompt conflicts with this.

**Key points**:

- Don't ask for JSON output in your prompt
- Must use `model: sonnet` (haiku unreliable)
- Internal schema: `{"ok": true}` or `{"ok": false, "reason": "why"}`
- `$ARGUMENTS` already prepended - don't need to specify

See [GitHub Issue #11947](https://github.com/anthropics/claude-code/issues/11947) for details.

### Hook not discovered

**Cause**: `hooks.json` placed inside skill directory instead of plugin root.

**Fix**: Move hooks to plugin root:

```
// Wrong
my-plugin/skills/my-skill/hooks/hooks.json

// Correct
my-plugin/hooks/hooks.json
```

Auto-discovery expects `hooks/hooks.json` at plugin root level.

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
