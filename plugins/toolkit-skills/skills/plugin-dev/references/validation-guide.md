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

## Hook Reliability by Type

Not all hooks work reliably. Known issues as of Jan 2026:

| Hook             | From Plugins | From settings.json | Notes                           |
| ---------------- | ------------ | ------------------ | ------------------------------- |
| UserPromptSubmit | ✓ Works      | ✓ Works            | Most reliable                   |
| Stop             | ✗ Silent     | ✓ Fires but silent | Can't communicate back (#16227) |
| PreToolUse       | Inconsistent | Inconsistent       | Multiple open bugs (#6305)      |
| PostToolUse      | Inconsistent | Inconsistent       | Multiple open bugs (#6403)      |
| SessionStart     | ✓ Works      | ✓ Works            | Good for context injection      |
| Notification     | ✓ Works      | ✓ Works            | Good for alerts/TTS             |

**Recommendation**: Use UserPromptSubmit for reliable plugin hooks. Avoid Stop hooks for user-facing features - they fire but output is silent.

## Additional Marketplace Validation Errors

| Error | Cause | Solution |
| ----- | ----- | -------- |
| `File not found: .claude-plugin/marketplace.json` | Missing manifest | Create `.claude-plugin/marketplace.json` with required fields |
| `Invalid JSON syntax: Unexpected token...` | JSON syntax error | Check for missing commas, extra commas, unquoted strings |
| `YAML frontmatter failed to parse: ...` | Invalid YAML in skill/agent/command | Fix YAML syntax in frontmatter block |
| `Invalid JSON syntax: ...` (hooks.json) | Malformed `hooks/hooks.json` | Fix JSON. Malformed hooks.json prevents entire plugin from loading |
| `Plugin name "x" is not kebab-case` | Invalid name format | Use `my-plugin` format (lowercase, hyphens only) |

## Plugin Load Errors

| Error | Cause | Solution |
| ----- | ----- | -------- |
| `Plugin not loading` | Invalid `plugin.json` | Validate with `claude plugin validate` |
| `Commands not appearing` | Wrong directory structure | Ensure `commands/` at root, not inside `.claude-plugin/` |
| `Hooks not firing` | Script not executable | Run `chmod +x script.sh` |
| `MCP server fails` | Missing `${CLAUDE_PLUGIN_ROOT}` | Use variable for all plugin paths |
| `Path errors` | Absolute paths used | All paths must be relative, start with `./` |
| `Conflicting manifests` | Components in both plugin.json and marketplace entry | Use `strict: false` in marketplace or remove from one |

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
4. **Test plugin directly**: `claude --plugin-dir ./my-plugin`
5. **Debug mode**: `claude --debug` for verbose output
6. **Reload**: `/reload-plugins` to pick up changes
7. **Compare to working example**: Check claude-code-toolkit or official demos

## Directory Structure Mistakes

The most common mistake is putting components inside `.claude-plugin/`:

```
# WRONG
my-plugin/
├── .claude-plugin/
│   ├── plugin.json
│   ├── commands/      ← Should NOT be here
│   └── skills/        ← Should NOT be here

# CORRECT
my-plugin/
├── .claude-plugin/
│   └── plugin.json    ← Only this goes here
├── commands/           ← At root level
├── skills/             ← At root level
└── hooks/              ← At root level
```
