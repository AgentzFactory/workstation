#!/usr/bin/env bash
#
# Interactive Agent Onboarding
# For agents running in OpenClaw context
#

set -e

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  🤖 AGENT WORKSTATION ONBOARDING                          ║"
echo "║  Connect your Seat to an Organization                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Detect context
SEAT_PATH="$(pwd)"
SEAT_NAME="$(basename "$SEAT_PATH")"

echo "📍 Current Location: $SEAT_PATH"
echo "🪑 Seat Name: $SEAT_NAME"
echo ""

# Verify Seat structure
if [[ ! -d ".openclaw/workspace" ]]; then
    echo "⚠️  Warning: No .openclaw/workspace/ found"
    echo "Creating minimal Seat structure..."
    mkdir -p .openclaw/workspace
    echo "# Agent" > .openclaw/workspace/AGENT.md
    echo "# Memory" > .openclaw/workspace/MEMORY.md
    echo "# Tools" > .openclaw/workspace/TOOLS.md
    echo "✅ Created"
    echo ""
fi

# Check current org link
if [[ -f ".openclaw/.workstation/org" ]]; then
    CURRENT_ORG=$(cat .openclaw/.workstation/org)
    echo "ℹ️   Already linked to: $CURRENT_ORG"
    echo ""
    read -p "Do you want to re-link to a different org? [y/N]: " RELINK
    if [[ ! "$RELINK" =~ ^[Yy]$ ]]; then
        echo ""
        echo "✅ Keeping current link to $CURRENT_ORG"
        echo ""
        echo "Quick commands:"
        echo "  workstation status       - Check sync status"
        echo "  workstation sync         - Update KBs and push changes"
        exit 0
    fi
    echo ""
fi

# Organization input
echo "🏢 ORGANIZATION SETUP"
echo "---------------------"
echo ""
echo "To link your Seat to an organization, I need:"
echo ""

read -p "Organization name (e.g., AcmeCorp): " ORG_NAME
if [[ -z "$ORG_NAME" ]]; then
    echo "❌ Organization name is required"
    exit 1
fi

echo ""
echo "The SSOT URL is the GitHub repository for the organization's Central."
echo "Example: https://github.com/acme/SSOT-AcmeCorp"
echo ""

read -p "SSOT URL: " SSOT_URL
if [[ -z "$SSOT_URL" ]]; then
    echo "❌ SSOT URL is required"
    exit 1
fi

echo ""
echo "🔧 CONFIGURING..."
echo "-----------------"
echo ""

# Check workstation CLI
if ! command -v workstation >/dev/null 2>&1; then
    echo "📦 Installing Workstation CLI..."
    curl -fsSL https://raw.githubusercontent.com/AgentzFactory/workstation/main/install-cli.sh | bash
    export PATH="$HOME/.local/bin:$PATH"
    echo "✅ Installed"
    echo ""
fi

# Run workstation join
echo "🔗 Linking Seat to $ORG_NAME..."
if workstation seat join --org "$ORG_NAME" --url "$SSOT_URL"; then
    echo "✅ Linked successfully"
else
    echo "❌ Link failed"
    exit 1
fi

echo ""
echo "📝 UPDATING DOCUMENTATION"
echo "-------------------------"
echo ""

# Update AGENT.md
if [[ -f ".openclaw/workspace/AGENT.md" ]]; then
    if ! grep -q "^## Organization" ".openclaw/workspace/AGENT.md"; then
        cat >> ".openclaw/workspace/AGENT.md" <>EOF

## Organization

**Name**: $ORG_NAME  
**SSOT**: $SSOT_URL  
**Linked**: $(date +%Y-%m-%d)

I am an agent working within the $ORG_NAME organization.
I follow their standards defined in KB-Core and collaborate on their projects.

## Boundaries

- ✅ Access organizational KBs
- ✅ Work on assigned projects
- ✅ Sync progress with Central
- ❌ Access other agents' private Seats
EOF
        echo "✅ Updated AGENT.md"
    fi
fi

# Update MEMORY.md
if [[ -f ".openclaw/workspace/MEMORY.md" ]]; then
    if ! grep -q "Organization:" ".openclaw/workspace/MEMORY.md"; then
        cat >> ".openclaw/workspace/MEMORY.md" <>EOF

## Organization Context

**Org**: $ORG_NAME  
**Linked**: $(date +%Y-%m-%d)  
**Status**: Awaiting admin incorporation

### Available Resources
- KB-Core: Organizational standards
- Projects: To be assigned by admin

### Sync Log
- $(date): Initial link to $ORG_NAME
EOF
        echo "✅ Updated MEMORY.md"
    fi
fi

echo ""
echo "📋 NEXT STEPS"
echo "-------------"
echo ""
echo "1️⃣  PUSH YOUR SEAT TO GITHUB"
echo "   If not already done:"
echo "   $ git remote add origin https://github.com/YOURNAME/$SEAT_NAME"
echo "   $ git push -u origin main"
echo ""
echo "2️⃣  REQUEST ADMIN APPROVAL"
echo "   Share this URL with $ORG_NAME administrator:"
echo "   👉 https://github.com/YOURNAME/$SEAT_NAME"
echo ""
echo "3️⃣  ADMIN WILL INCORPORATE"
echo "   They'll run: workstation seat incorporate --url https://github.com/YOURNAME/$SEAT_NAME"
echo ""
echo "4️⃣  START WORKING"
echo "   Once incorporated, access organizational KBs:"
echo "   📁 .openclaw/workspace/imports/$ORG_NAME/KB-Core/"
echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ Agent onboarding complete!"
echo "════════════════════════════════════════════════════════════"
echo ""
