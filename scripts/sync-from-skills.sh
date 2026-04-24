#!/bin/bash
# Sync Claude Code Toolkit skills from the canonical skills repo.

set -euo pipefail

SKILLS_REPO=${SKILLS_REPO:-../skills}
SOURCE_DIR="$SKILLS_REPO"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: canonical skills repo not found: $SOURCE_DIR" >&2
  echo "Set SKILLS_REPO=/path/to/skills if needed." >&2
  exit 1
fi

copy_skill() {
  local skill="$1"
  local dest="$2"
  if [ ! -d "$SOURCE_DIR/$skill" ]; then
    echo "Error: missing canonical skill: $SOURCE_DIR/$skill" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$dest")"
  rm -rf "$dest"
  cp -a "$SOURCE_DIR/$skill" "$dest"
  echo "Synced $skill -> $dest"
}

copy_root_skill() {
  local skill="$1"
  local dest_file="$2"
  if [ ! -f "$SOURCE_DIR/$skill/SKILL.md" ]; then
    echo "Error: missing canonical skill file: $SOURCE_DIR/$skill/SKILL.md" >&2
    exit 1
  fi
  cp "$SOURCE_DIR/$skill/SKILL.md" "$dest_file"
  echo "Synced $skill -> $dest_file"
}

copy_root_skill analytics plugins/analytics/SKILL.md
copy_root_skill mcp-setup plugins/mcp-essentials/SKILL.md

copy_skill ecosystem-guide plugins/toolkit-skills/skills/ecosystem-guide
copy_skill plugin-dev plugins/toolkit-skills/skills/plugin-dev
copy_skill reflect plugins/toolkit-skills/skills/reflect
copy_skill research plugins/toolkit-skills/skills/research
copy_skill skill-creator plugins/toolkit-skills/skills/skill-creator

copy_skill advanced-prompting plugins/claude-workflow/skills/advanced-prompting
copy_skill claude-md-maintenance plugins/claude-workflow/skills/claude-md-maintenance
copy_skill orchestration plugins/claude-workflow/skills/orchestration
copy_skill structured-rpi plugins/claude-workflow/skills/structured-rpi

copy_skill terminal-optimization plugins/dev-environment/skills/terminal-optimization
copy_skill worktree-mastery plugins/dev-environment/skills/worktree-mastery

copy_skill asshole plugins/devops-skills/skills/asshole
copy_skill ci-debug-workflow plugins/devops-skills/skills/ci-debug-workflow
copy_skill deslop plugins/devops-skills/skills/deslop
copy_skill improve-codebase-architecture plugins/devops-skills/skills/improve-codebase-architecture
copy_skill techdebt-finder plugins/devops-skills/skills/techdebt-finder

copy_skill tdd plugins/dev-practices/skills/tdd
copy_skill nopeek plugins/nopeek/skills/nopeek
