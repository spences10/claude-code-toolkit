# Statusline Setup

Display context usage, git branch, and session info in shell prompt.

## Starship Configuration

Starship is cross-shell. Config: `~/.config/starship.toml`

### Basic Setup

```toml
format = """
$directory$git_branch$git_status$character"""

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
format = "[$branch]($style) "
style = "bold purple"

[git_status]
format = '([$all_status$ahead_behind]($style) )'
style = "bold red"

[character]
success_symbol = "[>](bold green)"
error_symbol = "[>](bold red)"
```

### With Claude Context Display

Add custom command to show context:

```toml
[custom.claude_context]
command = "claude context 2>/dev/null | grep -o '[0-9]*%' | head -1 || echo ''"
when = "command -v claude"
format = "[$output]($style) "
style = "bold cyan"
```

## Oh-My-Zsh

### Git Plugin (built-in)

Add to `~/.zshrc`:

```bash
plugins=(git)
```

Provides: `git_current_branch`, `git_prompt_info`

### Custom Prompt with Context

```bash
# Add to ~/.zshrc
claude_context() {
  local ctx=$(claude context 2>/dev/null | grep -o '[0-9]*%' | head -1)
  [[ -n "$ctx" ]] && echo "[ctx:$ctx] "
}

PROMPT='$(claude_context)%F{cyan}%~%f %F{magenta}$(git_current_branch)%f > '
```

## Pure Bash

```bash
# Add to ~/.bashrc
parse_git_branch() {
  git branch 2>/dev/null | grep '^*' | cut -d' ' -f2
}

claude_ctx() {
  local ctx=$(claude context 2>/dev/null | grep -o '[0-9]*%' | head -1)
  [[ -n "$ctx" ]] && echo "[ctx:$ctx] "
}

PS1='$(claude_ctx)\[\033[36m\]\w\[\033[35m\] $(parse_git_branch)\[\033[0m\] > '
```

## Context Tracking Tips

1. **Check periodically** - Run `claude context` to see usage
2. **Start fresh** - Use `/clear` when context gets high
3. **Color code** - Change prompt color when context > 80%

### Auto-warning

```bash
# Warn when context high
check_context() {
  local pct=$(claude context 2>/dev/null | grep -o '[0-9]*' | head -1)
  [[ "$pct" -gt 80 ]] && echo -e "\033[33m[!] Claude context at ${pct}%\033[0m"
}
PROMPT_COMMAND="check_context; $PROMPT_COMMAND"
```

## Session Identification

Name sessions for multi-project work:

```bash
# Set window/tab title
set_title() { echo -ne "\033]0;$1\007"; }

# Auto-set from git repo
auto_title() {
  local repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null)
  [[ -n "$repo" ]] && set_title "$repo"
}
cd() { builtin cd "$@" && auto_title; }
```
