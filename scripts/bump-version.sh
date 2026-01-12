#!/bin/bash
# Bump patch version across all plugin.json files
# Usage: ./scripts/bump-version.sh [version]
# Example: ./scripts/bump-version.sh 0.0.2

set -e

VERSION=${1:-}

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 0.0.2"
  exit 1
fi

echo "Bumping to version $VERSION..."

# Update marketplace plugin.json
sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$VERSION\"/" .claude-plugin/plugin.json

# Update each plugin's plugin.json
for f in plugins/*/.claude-plugin/plugin.json; do
  if [ -f "$f" ]; then
    sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$VERSION\"/" "$f"
    echo "  Updated: $f"
  fi
done

echo ""
echo "Updated to $VERSION. Don't forget to:"
echo "  1. Update CHANGELOG.md"
echo "  2. git add -A && git commit -m 'chore: bump to $VERSION'"
echo "  3. git push"
