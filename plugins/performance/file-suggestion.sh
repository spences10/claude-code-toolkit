#!/bin/bash
# Fast file suggestion with SQLite FTS5 indexing for Claude Code
# Provides ~9x faster search with intelligent BM25 ranking
#
# Install: Add to ~/.claude/settings.json:
#   "fileSuggestion": {
#     "type": "command",
#     "command": "~/.claude/plugins/cache/performance/file-suggestion.sh"
#   }

set -e

# Read query from JSON stdin (Claude Code passes {"query": "..."})
QUERY=$(jq -r '.query // ""' 2>/dev/null || echo "")

# Exit if no query
[[ -z "$QUERY" ]] && exit 0

# Get repo root, fallback to CLAUDE_PROJECT_DIR or pwd
REPO_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"

# Cache setup - unique DB per repo
CACHE_DIR="$HOME/.cache/claude-code"
REPO_HASH=$(echo "$REPO_ROOT" | md5sum | cut -d' ' -f1)
DB_PATH="$CACHE_DIR/file-index-$REPO_HASH.db"

# Ensure cache directory exists
mkdir -p "$CACHE_DIR"

# Check if index needs rebuild (stale > 5 min or doesn't exist)
REBUILD=false
if [[ ! -f "$DB_PATH" ]]; then
    REBUILD=true
elif [[ -n $(find "$DB_PATH" -mmin +5 2>/dev/null) ]]; then
    REBUILD=true
fi

# Rebuild index if needed (fast: ~100ms for 5k files)
if [[ "$REBUILD" == "true" ]]; then
    python3 << PYEOF
import sqlite3
import os
import subprocess

conn = sqlite3.connect('$DB_PATH')
conn.execute("DROP TABLE IF EXISTS files")
conn.execute("""
    CREATE VIRTUAL TABLE files USING fts5(
        filepath,
        filename,
        directory,
        tokenize='unicode61'
    )
""")

# Use git ls-files for tracked files (respects .gitignore)
result = subprocess.run(
    ['git', 'ls-files'],
    capture_output=True,
    text=True,
    cwd='$REPO_ROOT'
)

files = []
for f in result.stdout.strip().split('\n'):
    if f:
        files.append((f, os.path.basename(f), os.path.dirname(f)))

conn.executemany("INSERT INTO files VALUES (?, ?, ?)", files)
conn.commit()
conn.close()
PYEOF
fi

# Escape query for FTS5 (handle special chars)
SAFE_QUERY=$(echo "$QUERY" | sed 's/["\*\(\)\[\]{}^~:\\]//g')

# Query the index with prefix matching and BM25 ranking
sqlite3 "$DB_PATH" "SELECT filepath FROM files WHERE files MATCH '\"$SAFE_QUERY\"*' ORDER BY bm25(files) LIMIT 50;" 2>/dev/null || \
    # Fallback to simple LIKE if FTS5 query fails
    sqlite3 "$DB_PATH" "SELECT filepath FROM files WHERE filepath LIKE '%$SAFE_QUERY%' OR filename LIKE '%$SAFE_QUERY%' LIMIT 50;"
