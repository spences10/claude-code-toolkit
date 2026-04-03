#!/bin/bash
# PreToolUse(Bash) hook — wraps cloud CLI commands to redact secrets from output
#
# Per https://code.claude.com/docs/en/hooks#pretooluse-decision-control:
# - Uses permissionDecision (not deprecated "decision")
# - updatedInput replaces the ENTIRE input object, so all fields are preserved

set -euo pipefail

INPUT=$(cat)

# Require jq — security tool should not silently degrade
if ! command -v jq &>/dev/null; then
  echo "nopeek redact hook requires jq" >&2
  exit 1
fi

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
[[ -z "$COMMAND" ]] && exit 0

# Only intercept CLI commands that might output secrets
CLOUD_CLI_PATTERN='^\s*(aws|hcloud|kubectl|doctl|gcloud|az|terraform|gh|ssh|scp|ssh-keygen|docker|docker-compose|pulumi|flyctl|railway|vercel)\s'
if ! echo "$COMMAND" | grep -qE "$CLOUD_CLI_PATTERN"; then
  exit 0
fi

# Don't wrap commands that already have pipes or redirections — too risky to modify
if echo "$COMMAND" | grep -qE '[|><]'; then
  exit 0
fi

# Build the redaction sed filter
REDACT='sed -E'
REDACT+=' -e '"'"'s/AKIA[A-Z0-9]{16}/[REDACTED:AWS_KEY]/g'"'"''
REDACT+=' -e '"'"'s/(SecretAccessKey|aws_secret_access_key)[[:space:]]*[:=][[:space:]]*[A-Za-z0-9\/+=]{40}/\1=[REDACTED]/g'"'"''
REDACT+=' -e '"'"'s/Bearer [a-zA-Z0-9._-]{20,}/Bearer [REDACTED]/g'"'"''
REDACT+=' -e '"'"'s/sk-[a-zA-Z0-9._-]{20,}/[REDACTED:API_KEY]/g'"'"''
REDACT+=' -e '"'"'s/sk_live_[a-zA-Z0-9]{20,}/[REDACTED:STRIPE_LIVE]/g'"'"''
REDACT+=' -e '"'"'s/sk_test_[a-zA-Z0-9]{20,}/[REDACTED:STRIPE_TEST]/g'"'"''
REDACT+=' -e '"'"'s/-----BEGIN[[:space:]]+[A-Z[:space:]]*PRIVATE[[:space:]]+KEY-----/[REDACTED:PRIVATE_KEY]/g'"'"''
REDACT+=' -e '"'"'s|://[^:]+:[^@]+@|://[REDACTED]@|g'"'"''
REDACT+=' -e '"'"'s/(password|passwd|secret|token)[[:space:]]*[:=][[:space:]]*[\"'"'"'"'"'"']?[^[:space:]\"'"'"'"'"'"']{8,}/\1=[REDACTED]/gI'"'"''
REDACT+=' -e '"'"'s/[a-f0-9]{64}/[REDACTED:HEX_TOKEN]/g'"'"''

# Wrap: pipe stdout through redaction, leave stderr untouched
WRAPPED="${COMMAND} | ${REDACT}"

# Preserve ALL original tool_input fields, only replace command
# Per docs: "Replaces the entire input object, so include unchanged fields alongside modified ones"
UPDATED_INPUT=$(echo "$INPUT" | jq --arg cmd "$WRAPPED" '.tool_input | .command = $cmd')

# Output per https://code.claude.com/docs/en/hooks#pretooluse-decision-control
jq -n --argjson input "$UPDATED_INPUT" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "allow",
    permissionDecisionReason: "nopeek: cloud CLI output redacted for secret safety",
    updatedInput: $input
  }
}'
