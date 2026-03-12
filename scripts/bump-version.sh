#!/bin/bash
# Bump version in marketplace.json (single source of truth for versions)
# Usage: ./scripts/bump-version.sh [version]
# Example: ./scripts/bump-version.sh 0.0.17

set -e

VERSION=${1:-}

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 0.0.17"
  exit 1
fi

echo "Bumping to version $VERSION..."

# Update marketplace.json (single source of truth for all plugin versions)
sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$VERSION\"/" .claude-plugin/marketplace.json
echo "  Updated: .claude-plugin/marketplace.json"

echo ""
echo "Updated to $VERSION. Don't forget to:"
echo "  1. Update CHANGELOG.md"
echo "  2. git add -A && git commit -m 'chore: bump to $VERSION'"
echo "  3. git push"
