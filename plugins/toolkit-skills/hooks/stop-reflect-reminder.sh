#!/bin/bash
# Stop hook that reminds about /reflect
#
# Simple reminder shown at session end. Replaces prompt-type hook
# which fails due to Claude Code JSON validation bug (#11947).

cat <<'EOF'
Session ending. If you made corrections, discoveries, or validated patterns, consider running /reflect to persist learnings.
EOF
exit 0
