---
name: terminal-optimization
# prettier-ignore
description: Terminal setup for Claude Code. Use for Ghostty config, statusline customization, voice dictation, tmux worktrees.
---

# Terminal Optimization

Configure terminal environment for effective Claude Code usage.

## Ghostty Configuration

Ghostty works well with Claude Code. Key settings:

```ini
# ~/.config/ghostty/config
font-family = JetBrains Mono
font-size = 14
window-padding-x = 10
window-padding-y = 10
cursor-style = bar
shell-integration = detect
```

See [ghostty-config.md](references/ghostty-config.md) for full config.

## Statusline

Display context usage and git info in shell prompt. Useful for:

- Tracking Claude Code context consumption
- Current git branch/status at a glance
- Session identification

See [statusline-setup.md](references/statusline-setup.md) for starship/oh-my-zsh configs.

## Voice Dictation

macOS: Press **fn key twice** to toggle dictation. Tips:

- Speak punctuation explicitly ("comma", "period", "new line")
- Pause briefly before/after commands
- Works in any text field including terminal

See [voice-dictation.md](references/voice-dictation.md) for detailed tips.

## Tab Naming

Name terminal tabs by project/task:

```bash
# Set tab title (most terminals)
echo -ne "\033]0;my-project\007"

# Or use terminal-specific shortcuts
# Ghostty: Cmd+Shift+I
# iTerm2: Cmd+I
```

## tmux for Worktrees

Use tmux sessions per git worktree:

```bash
# Create session for worktree
tmux new-session -s feature-branch -c ~/repos/project-feature

# Attach to existing
tmux attach -t feature-branch
```

Each worktree gets isolated Claude Code context.

## References

- [ghostty-config.md](references/ghostty-config.md) - Full Ghostty configuration
- [statusline-setup.md](references/statusline-setup.md) - Prompt/statusline setup
- [voice-dictation.md](references/voice-dictation.md) - Voice input tips
