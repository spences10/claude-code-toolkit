# Distribution Guide

Publishing and sharing your marketplace.

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

# Test local install
/plugin marketplace add ./my-marketplace
/plugin install my-plugin@my-marketplace

# Verify it works
/my-command
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

## Version Updates

1. Update version in `marketplace.json` and `plugin.json`
2. Push to repository
3. Users update with: `/plugin marketplace update`

## File Caching

Plugins are copied to cache on install. This means:

- Files outside plugin dir won't be copied
- Use symlinks for shared files
- Reference files with `${CLAUDE_PLUGIN_ROOT}`

## Checklist

- [ ] `claude plugin validate .` passes
- [ ] All plugins have `.claude-plugin/plugin.json`
- [ ] Tested local install works
- [ ] Commands/skills function correctly
- [ ] Version numbers updated
- [ ] Pushed to repository
