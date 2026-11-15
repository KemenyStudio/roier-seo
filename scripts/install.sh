#!/bin/bash

# Roier SEO Skill - Installation Script
# Installs dependencies for the audit scripts

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 Installing Roier SEO Skill dependencies..."

cd "$SCRIPT_DIR"

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required but not installed."
    echo "   Install it from: https://nodejs.org"
    exit 1
fi

# Lighthouse 13 requires Node.js 22.19+. Same floor as package.json engines.
NODE_RAW="$(node -v)"
NODE_RAW="${NODE_RAW#v}"
IFS=. read -r NODE_MAJOR NODE_MINOR _ <<<"$NODE_RAW"
if [ "$NODE_MAJOR" -lt 22 ] || { [ "$NODE_MAJOR" -eq 22 ] && [ "$NODE_MINOR" -lt 19 ]; }; then
    echo "❌ Node.js 22.19 or higher is required (Lighthouse 13). You have v${NODE_RAW}."
    echo "   Install it from: https://nodejs.org"
    exit 1
fi

# Install npm dependencies
if [ -f "package.json" ]; then
    npm install --silent
    echo "✅ Dependencies installed successfully!"
else
    echo "❌ package.json not found in $SCRIPT_DIR"
    exit 1
fi

# Make scripts executable
chmod +x audit.js audit-api.js 2>/dev/null || true

echo ""
echo "🎉 Roier SEO Skill is ready!"
echo ""
echo "Usage:"
echo "  node $SCRIPT_DIR/audit.js <URL>         # Local Lighthouse (needs Chrome)"
echo "  node $SCRIPT_DIR/audit-api.js <URL>     # PageSpeed API (public URLs only)"
