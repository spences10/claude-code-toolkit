---
name: nopeek
description: "Reduce accidental secret disclosure with nopeek. Use for credential-dependent commands, .env loading, and secret-safety troubleshooting."
---

# nopeek — Per-command credentials

When the user says "use nopeek if you need keys", handle the CLI syntax
and key selection yourself. Use `npx`, `pnpx`, or `bunx` as appropriate;
prefer a reviewed, pinned local version for production credentials.
Do not read secret files into tool output or put literal credentials in commands.

```bash
nopeek run .env --only API_KEY -- node ./script-that-reads-env.js
nopeek list
nopeek status
nopeek audit
```

## Delivery rules

- Prefer `run` in every harness, including Claude Code, Codex, Gemini CLI,
  OpenCode, Cursor, and Pi. Select only the keys the command needs.
- `run` passes values in the child's environment, not shell assignments.
  It does not redact child stdout/stderr or prevent the child exposing values.
- `--only` filters the input file, not inherited environment variables.
  Start with a clean parent session; avoid `env`, `printenv`, tracing,
  verbose auth output, and expanding credentials into command arguments.
- `load` never writes `CLAUDE_ENV_FILE`. In detected agent sessions it
  creates a private, self-removing source file. Source its path only in
  the shell running the command; never inline its contents or put it into
  a session env file. Prefer `run` over this fallback.
- `set` and `load --persist --only KEY` explicitly store global plaintext
  keys. They are not project-scoped and are not automatically loaded.
  Avoid persistence unless specifically requested; `run` reads a file,
  not this global store. `init` audits cloud auth; it does not migrate it.

## Migration and limitations

Update both the CLI and plugin. Older versions injected stored keys and
CLI profiles into every session. Disable legacy SessionStart hooks,
restart affected sessions, and rotate exposed credentials. Updating does
not clear existing shell environments, hook files, histories, or transcripts.
Use `nopeek remove KEY` only when removal is requested.

The remaining PreToolUse hook applies best-effort regex redaction to
stdout of selected cloud CLI commands. It does not cover stderr,
`ps`/`pgrep`, or commands containing pipes/redirections, and requires jq.
It is not a security boundary. File permissions, sandboxes, and redaction
reduce risk but cannot guarantee secrecy from an arbitrary child command.
