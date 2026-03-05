#!/usr/bin/env bash
#
# Agent Auto-Setup for Workstation
# Run this from within a Seat (.openclaw/workspace/) to auto-configure
#

set -e

echo "🤖 Workstation Agent Setup"
echo "=========================="
echo ""

# Detect if we're in a Seat
if [[ ! -d ".openclaw/workspace" ]]; then
    echo "❌ Error: Not in a Seat context"
    echo "This script must be run from a directory with .openclaw/workspace/"
    exit 1
fi

SEAT_PATH="$(pwd)"
SEAT_NAME="$(basename "$SEAT_PATH")"

echo "📍 Detected Seat: $SEAT_NAME"
echo ""

# Check if already linked
if [[ -f ".openclaw/.workstation/org" ]]; then
    ORG=$(cat .openclaw/.workstation/org)
    echo "✅ Already linked to Organization: $ORG"
    echo ""
    echo "Current status:"
    workstation status 2>/dev/null || echo "  (workstation CLI not in PATH)"
    exit 0
fi

# Interactive setup
echo "🔗 Linking Seat to Organization"
echo ""

read -p "Organization name (e.g., AcmeCorp): " ORG_NAME
if [[ -z "$ORG_NAME" ]]; then
    echo "❌ Organization name required"
    exit 1
fi

read -p "SSOT URL (e.g., https://github.com/acme/SSOT-AcmeCorp): " SSOT_URL
if [[ -z "$SSOT_URL" ]]; then
    echo "❌ SSOT URL required"
    exit 1
fi

echo ""
echo "Setting up..."

# Run workstation command
if command -v workstation >/dev/null 2>&1; then
    workstation seat join --org "$ORG_NAME" --url "$SSOT_URL"
else
    echo "⚠️  workstation CLI not found"
    echo "Installing..."
    
    # Try to install
    if curl -fsSL https://raw.githubusercontent.com/AgentzFactory/workstation/main/install-cli.sh | bash; then
        export PATH="$HOME/.local/bin:$PATH"
        workstation seat join --org "$ORG_NAME" --url "$SSOT_URL"
    else
        echo "❌ Could not install workstation"
        exit 1
    fi
fi

# Update AGENT.md with org context
AGENT_FILE=".openclaw/workspace/AGENT.md"
if [[ -f "$AGENT_FILE" ]]; then
    echo ""
    echo "📝 Updating AGENT.md with organization context..."
    
    # Add org section if not present
    if ! grep -q "Organization" "$AGENT_FILE"; then
        cat >> "$AGENT_FILE" <>EOF

## Organization

**Name**: $ORG_NAME  
**Linked**: $(date +%Y-%m-%d)  
**SSOT**: $SSOT_URL

I work within the $ORG_NAME organization, following their standards and collaborating on their projects.
EOF
        echo "✅ AGENT.md updated"
    fi
fi

# Update MEMORY.md
MEMORY_FILE=".openclaw/workspace/MEMORY.md"
if [[ -f "$MEMORY_FILE" ]]; then
    if ! grep -q "Organization" "$MEMORY_FILE"; then
        cat >> "$MEMORY_FILE" <>EOF

## Organization

- **Name**: $ORG_NAME
- **Linked**: $(date +%Y-%m-%d)
- **Status**: Pending admin approval
EOF
        echo "✅ MEMORY.md updated"
    fi
fi

echo ""
echo "✅ Agent setup complete!"
echo ""
echo "Next steps:"
echo "  1. Ensure your Seat is pushed to GitHub:"
echo "     git remote add origin https://github.com/YOURNAME/$SEAT_NAME"
echo "     git push -u origin main"
echo ""
echo "  2. Share your Seat URL with $ORG_NAME admin:"
echo "     https://github.com/YOURNAME/$SEAT_NAME"
echo ""
echo "  3. Admin will run: workstation seat incorporate --url https://github.com/YOURNAME/$SEAT_NAME"
echo ""
echo "  4. Once incorporated, you can access organizational KBs in:"
echo "     .openclaw/workspace/imports/$ORG_NAME/"
echo ""
