# Ghostty Configuration for Claude Code

Ghostty is a fast, GPU-accelerated terminal. Config location: `~/.config/ghostty/config`

## Recommended Config

```ini
# Font
font-family = JetBrains Mono
font-size = 14
font-thicken = true

# Window
window-padding-x = 10
window-padding-y = 10
window-decoration = true
window-theme = auto

# Cursor
cursor-style = bar
cursor-style-blink = false

# Shell integration
shell-integration = detect
shell-integration-features = cursor,sudo,title

# Clipboard
clipboard-read = allow
clipboard-write = allow
clipboard-paste-protection = false

# Performance
vsync = true
bold-is-bright = false

# Scrollback
scrollback-limit = 50000

# Tab bar
gtk-tabs-location = top
gtk-wide-tabs = false
```

## Keybindings

```ini
# Split panes
keybind = ctrl+shift+d=new_split:right
keybind = ctrl+shift+s=new_split:down

# Navigate splits
keybind = ctrl+shift+h=goto_split:left
keybind = ctrl+shift+l=goto_split:right
keybind = ctrl+shift+j=goto_split:bottom
keybind = ctrl+shift+k=goto_split:top

# Tabs
keybind = cmd+t=new_tab
keybind = cmd+w=close_surface
keybind = cmd+shift+i=inspector:show
```

## Theme Integration

Ghostty supports many themes. Set in config:

```ini
# Use a built-in theme
theme = catppuccin-mocha

# Or custom colors
background = 1e1e2e
foreground = cdd6f4
selection-background = 45475a
selection-foreground = cdd6f4
```

## Claude Code Tips

1. **Large scrollback** - Set `scrollback-limit = 50000` for long Claude outputs
2. **No paste protection** - `clipboard-paste-protection = false` avoids prompts
3. **Shell integration** - Enables better prompt detection for context

## Troubleshooting

### Font rendering issues

```ini
font-thicken = true
freetype-load-flags = no-hinting
```

### Slow startup

Check for slow shell initialization in `.zshrc` or `.bashrc`.

### Copy/paste not working

Ensure clipboard settings are enabled and no conflicting keybindings.
