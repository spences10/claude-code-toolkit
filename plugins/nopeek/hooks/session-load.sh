#!/bin/bash
# SessionStart hook — inject stored nopeek keys + CLI profiles into CLAUDE_ENV_FILE
# Reads ~/.config/nopeek/config.json directly (no npx, instant startup)

[[ -z "$CLAUDE_ENV_FILE" ]] && exit 0

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nopeek/config.json"
[[ ! -f "$CONFIG" ]] && exit 0

if ! command -v jq &>/dev/null; then
  exit 0
fi

# Inject stored keys
jq -r '.keys // {} | to_entries[] | "export \(.key)=\(.value.value | @sh)"' "$CONFIG" >> "$CLAUDE_ENV_FILE" 2>/dev/null

# Inject CLI profiles as environment variables
jq -r '
  .cli_profiles // {} | to_entries[] |
  if .key == "aws" then "export AWS_PROFILE=\(.value.profile | @sh)"
  elif .key == "hcloud" then "export HCLOUD_CONTEXT=\(.value.profile | @sh)"
  elif .key == "kubectl" then "export KUBECONFIG_CONTEXT=\(.value.profile | @sh)"
  elif .key == "doctl" then "export DOCTL_CONTEXT=\(.value.profile | @sh)"
  elif .key == "gcloud" then "export CLOUDSDK_ACTIVE_CONFIG_NAME=\(.value.profile | @sh)"
  else empty
  end
' "$CONFIG" >> "$CLAUDE_ENV_FILE" 2>/dev/null

exit 0
