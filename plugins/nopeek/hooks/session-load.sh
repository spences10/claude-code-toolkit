#!/bin/bash
# Retired compatibility entry point for manually registered older hooks.
# Never read stored credentials or write CLAUDE_ENV_FILE.
printf '%s\n' 'nopeek: automatic session loading is disabled for secret safety. Use nopeek run <file> --only KEY -- <command>; restart sessions that loaded keys with an older plugin.' >&2
exit 0
