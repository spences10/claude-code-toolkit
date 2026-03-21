# Distribution

Sharing and distributing Claude Skills across platforms and teams.

## Packaging

### Using claude-skills-cli

Package a skill into a distributable zip:

```bash
# Validate and package
npx claude-skills-cli package .claude/skills/my-skill

# Custom output directory
npx claude-skills-cli package .claude/skills/my-skill --output builds/

# Skip validation (not recommended)
npx claude-skills-cli package .claude/skills/my-skill --skip-validation
```

The output is a zip file ready for upload or sharing.

See [cli-reference.md](cli-reference.md) for full packaging options.

### Manual Packaging

```bash
cd .claude/skills/my-skill
zip -r ../../../my-skill.zip .
```

Ensure the zip root contains SKILL.md directly (not nested in a subdirectory).

## Distribution Channels

### Claude Code (Filesystem)

Skills live as directories. Share via:

**Git repository** (recommended):

- Commit skills to `.claude/skills/` in the project repo
- Team members get skills automatically on clone/pull
- Version controlled with the rest of the project

**Plugin distribution**:

- Package skills as part of a Claude Code plugin
- Install via the plugin system or `npx mcpick plugins install <plugin>`
- Manage with `npx mcpick plugins list|enable|disable|update`
- Skills go in `plugins/<plugin>/skills/<skill-name>/`

**Manual copy**:

- Copy the skill directory to `~/.claude/skills/` (user-level) or `.claude/skills/` (project-level)

### Claude.ai (Web)

Upload packaged zip files:

1. Go to Settings > Features > Skills
2. Upload the zip file
3. Skill is available for your account only (not org-wide)

### Claude API

Upload via the skills API:

1. Package the skill as a zip
2. Upload via `POST /v1/skills` endpoint
3. Skill is available workspace-wide

**Important**: Skills do not sync across platforms. Upload separately for each target.

## Plugin Packaging

To distribute skills as part of a Claude Code plugin:

### Directory Structure

```
my-plugin/
├── plugin.json          # Plugin manifest
├── skills/
│   ├── skill-one/
│   │   ├── SKILL.md
│   │   └── references/
│   └── skill-two/
│       ├── SKILL.md
│       ├── references/
│       └── scripts/
└── README.md
```

### Plugin Manifest

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Plugin with custom skills"
}
```

Skills inside a plugin are automatically discovered by Claude Code when the plugin is installed.

## Versioning

### Semantic Versioning for Skills

Follow semver principles:

- **Patch** (1.0.x): Fix typos, clarify instructions, fix broken links
- **Minor** (1.x.0): Add new reference files, new patterns, new scripts
- **Major** (x.0.0): Change core instructions, rename skill, restructure fundamentally

### Version Tracking

Track versions in git commits or a changelog. Skills don't have a built-in version field, so use external version tracking:

```bash
# Tag releases
git tag -a skill-myskill-v1.0.0 -m "Initial release of my-skill"
```

### Backwards Compatibility

When updating a shared skill:

- Do not remove patterns that others depend on without notice
- Add new patterns alongside existing ones
- Use reference files for new content to minimize SKILL.md changes
- Test after updates to verify trigger behavior is preserved

## Plugin Management with mcpick

[mcpick](https://github.com/spences10/mcpick) provides CLI management for MCP servers and plugins:

```bash
# Install and manage plugins
npx mcpick plugins install <plugin>
npx mcpick plugins update <plugin>
npx mcpick plugins list

# Cache management (fix stale plugins after version bumps)
npx mcpick cache status
npx mcpick cache clear
npx mcpick cache clean-orphaned

# Save/load MCP server + plugin profiles
npx mcpick profile save my-setup
npx mcpick profile load my-setup
```

## Pre-Distribution Checklist

- [ ] `npx claude-skills-cli validate --strict` passes
- [ ] Tested in a fresh conversation
- [ ] All reference links resolve
- [ ] Scripts have correct permissions and shebangs
- [ ] No absolute paths or machine-specific references
- [ ] No secrets, tokens, or credentials in any file
- [ ] Description is clear for someone unfamiliar with the skill
- [ ] README or documentation explains the skill's purpose (for plugin distribution)
