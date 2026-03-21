# Distribution Guide

Publishing, versioning, and sharing your marketplace.

## GitHub (Recommended)

1. Push to GitHub repository
2. Users add with: `/plugin marketplace add owner/repo`

Benefits: version control, issues, collaboration

## Other Git Hosts

GitLab, Bitbucket, self-hosted:

```
/plugin marketplace add https://gitlab.com/team/plugins.git
```

## Local Testing

Before publishing:

```bash
# Validate
claude plugin validate .

# Test plugin during development (no install needed)
claude --plugin-dir ./my-plugin

# Multiple plugins at once
claude --plugin-dir ./plugin-one --plugin-dir ./plugin-two

# Reload after changes (inside Claude Code)
/reload-plugins

# Test via marketplace install
/plugin marketplace add ./my-marketplace
/plugin install my-plugin@my-marketplace

# Verify it works
/my-plugin:skill-name
```

## Team Configuration

Add to project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "team-plugins": {
      "source": {
        "source": "github",
        "repo": "your-org/claude-plugins"
      }
    }
  },
  "enabledPlugins": {
    "my-plugin@team-plugins": true
  }
}
```

Team members get prompted to install when trusting the project.

## Version Management

### Semantic Versioning

Use `MAJOR.MINOR.PATCH` format in plugin.json:

```json
{
  "name": "my-plugin",
  "version": "2.1.0"
}
```

- **MAJOR**: Breaking changes
- **MINOR**: New features, backward compatible
- **PATCH**: Bug fixes

Pre-release versions are supported: `2.0.0-beta.1`

### Version Priority

If `version` is set in both `plugin.json` and `marketplace.json`, **`plugin.json` takes priority**. Set it in one place only to avoid confusion.

### Update Workflow

1. Update version in `plugin.json` (and optionally `marketplace.json`)
2. Update `CHANGELOG.md`
3. Commit and push (or tag a release)
4. Users update with: `/plugin marketplace update`

### Version Pinning

Pin plugins to exact versions using `ref` and `sha` in source:

```json
{
  "source": {
    "source": "github",
    "repo": "company/plugin",
    "ref": "v2.0.0",
    "sha": "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0"
  }
}
```

### Release Channels

Use separate marketplaces pointing to different branches:

**Stable channel** (`stable-tools` marketplace):

```json
{
  "name": "stable-tools",
  "owner": { "name": "Your Org" },
  "plugins": [
    {
      "name": "code-formatter",
      "source": {
        "source": "github",
        "repo": "acme-corp/code-formatter",
        "ref": "stable"
      }
    }
  ]
}
```

**Latest channel** (`latest-tools` marketplace):

```json
{
  "name": "latest-tools",
  "owner": { "name": "Your Org" },
  "plugins": [
    {
      "name": "code-formatter",
      "source": {
        "source": "github",
        "repo": "acme-corp/code-formatter",
        "ref": "latest"
      }
    }
  ]
}
```

Assign channels via managed `extraKnownMarketplaces` in settings.

## Installation Scopes

```bash
# User scope (default) — all projects
claude plugin install formatter@marketplace

# Project scope — shared via VCS
claude plugin install formatter@marketplace --scope project

# Local scope — gitignored
claude plugin install formatter@marketplace --scope local
```

## Private Repositories

Authentication via environment variables:

| Provider  | Environment variables        |
| --------- | ---------------------------- |
| GitHub    | `GITHUB_TOKEN` or `GH_TOKEN` |
| GitLab    | `GITLAB_TOKEN` or `GL_TOKEN` |
| Bitbucket | `BITBUCKET_TOKEN`            |

Add to `.bashrc`/`.zshrc`:

```bash
export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx
```

For slow connections, increase timeout:

```bash
export CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS=300000  # 5 minutes
```

## Managed Marketplace Restrictions

Admins can restrict which marketplaces users can add via `strictKnownMarketplaces` in managed settings:

| Value            | Behavior                                |
| ---------------- | --------------------------------------- |
| Undefined        | No restrictions (default)               |
| Empty array `[]` | Complete lockdown — no new marketplaces |
| List of sources  | Only allowlisted marketplaces           |

```json
{
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "acme-corp/approved-plugins" },
    { "source": "hostPattern", "hostPattern": "^github\\.example\\.com$" },
    { "source": "pathPattern", "pathPattern": "^/opt/approved/" }
  ]
}
```

## Container Pre-population

For CI/containers, seed plugins without runtime cloning:

```bash
export CLAUDE_CODE_PLUGIN_SEED_DIR=/path/to/seed
```

Seed directory structure:

```
$CLAUDE_CODE_PLUGIN_SEED_DIR/
  known_marketplaces.json
  marketplaces/<name>/...
  cache/<marketplace>/<plugin>/<version>/...
```

Contents are copied to `~/.claude/plugins` on startup.

## Submit to Official Marketplace

Submit plugins to the Anthropic-managed marketplace:

- **Claude.ai**: [claude.ai/settings/plugins/submit](https://claude.ai/settings/plugins/submit)
- **Console**: [platform.claude.com/plugins/submit](https://platform.claude.com/plugins/submit)

## File Caching

Plugins are copied to cache on install (`~/.claude/plugins/cache`). This means:

- Files outside plugin dir won't be copied
- No `../` path traversal allowed
- Use symlinks for shared files
- Reference files with `${CLAUDE_PLUGIN_ROOT}`

## Checklist

- [ ] `claude plugin validate .` passes
- [ ] All plugins have `.claude-plugin/plugin.json`
- [ ] Tested with `claude --plugin-dir ./my-plugin`
- [ ] Commands/skills function correctly
- [ ] Version numbers updated (semver)
- [ ] `CHANGELOG.md` updated
- [ ] No components inside `.claude-plugin/` directory
- [ ] Pushed to repository

## Official Resources

- [Create plugins](https://code.claude.com/docs/en/plugins)
- [Create and distribute a marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
- [Plugins reference](https://code.claude.com/docs/en/plugins-reference)
- [Discover and install plugins](https://code.claude.com/docs/en/discover-plugins)
