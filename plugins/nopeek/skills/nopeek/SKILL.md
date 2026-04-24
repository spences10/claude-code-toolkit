---
name: nopeek
description: "Secret-safe Claude Code sessions via nopeek CLI. Use when user asks about secrets, .env loading, credential safety, or keeping API keys out of conversation context."
---

# nopeek — Secret Safety for Claude Code

Secure proxy between Claude Code and your secrets. Claude knows key names, never key values.

## Why

Every Bash tool output is sent to Anthropic's API and retained 30+ days. If a CLI prints a token, that token is stored on Anthropic's servers. nopeek prevents this.

## Quick Start

All nopeek commands are safe inside Claude Code — they never output secret values, only key names.

### 1. Scan and migrate CLIs

```bash
npx nopeek init
```

Detects installed cloud CLIs (aws, hcloud, kubectl, etc.), checks their auth config, and migrates to profile-based auth where needed.

### 2. Load .env secrets

```bash
npx nopeek load .env
npx nopeek load .env --only DATABASE_URL,API_KEY
```

Injects values into the session via `CLAUDE_ENV_FILE` (when available) or outputs a source command. Only key names appear in output — never values.

### 3. Store arbitrary keys

```bash
npx nopeek set MY_API_KEY --from-env
npx nopeek set STRIPE_KEY --value "sk_live_..."
```

Stored keys auto-load on every Claude Code session via the SessionStart hook.

### 4. Verify

```bash
npx nopeek status
npx nopeek list
```

## What the hooks do

| Hook | Event | Purpose |
|------|-------|---------|
| session-load.sh | SessionStart | Loads stored keys + CLI profiles into `CLAUDE_ENV_FILE` |
| redact-output.sh | PreToolUse(Bash) | Wraps cloud CLI output through secret pattern redaction |

## Limitations

- **Redaction is best-effort.** Regex patterns catch known formats (AWS keys, bearer tokens, Stripe keys, private key headers, connection strings) but cannot catch every possible secret.
- **This is a safety net, not a guarantee.** The primary defense is loading secrets via `CLAUDE_ENV_FILE` so they never appear in output at all.
- **No PostToolUse output redaction.** Claude Code doesn't support modifying Bash output after execution. The PreToolUse hook rewrites commands to filter output before Claude sees it.
- **Commands with pipes or redirections are not wrapped.** The redaction hook skips commands containing `|`, `>`, or `<` to avoid breaking complex command semantics.
- **Requires jq.** The redact hook will not fire without jq installed.
- **Waiting on anthropics/claude-code#39882** — PreApiCall/PostApiCall hooks would enable full payload redaction before data leaves your machine.

## Audit .env files

```bash
npx nopeek audit
```

Scans current directory for .env files containing secrets and checks .gitignore coverage.

## Troubleshooting

**Keys not loading on session start:**
- Check `npx nopeek status` — are keys stored?
- Verify the plugin is installed: `/plugin list`
- Try `/reload-plugins`

**Cloud CLI still showing secrets:**
- The redaction hook only fires for commands starting with known CLI names (aws, hcloud, kubectl, doctl, gcloud, az, terraform)
- Commands with pipes or redirections are skipped to avoid breaking semantics
- Run `npx nopeek load .env` to make secrets available as env vars, then use `$VAR_NAME` in commands
