#!/usr/bin/env bash
#
# Create a new Seat (agent workspace)
#

set -euo pipefail

SEAT_NAME="${1:-}"
if [[ -z "$SEAT_NAME" ]]; then
    echo "Usage: $0 <seat-name>"
    echo "Example: $0 Developer"
    exit 1
fi

SEAT_DIR="SSOT/Seats/$SEAT_NAME"

if [[ -d "$SEAT_DIR" ]]; then
    echo "Error: Seat '$SEAT_NAME' already exists"
    exit 1
fi

mkdir -p "$SEAT_DIR"

cat > "$SEAT_DIR/AGENT.md" <<EOF
# $SEAT_NAME

**Role**: <!-- Define agent role -->
**Created**: $(date -u +"%Y-%m-%d")

## Purpose

<!-- What this agent does -->

## Boundaries

<!-- Clear permissions and limits -->

## Tools

<!-- Available capabilities -->

## Memory

<!-- Key information to retain -->
EOF

cat > "$SEAT_DIR/MEMORY.md" <<EOF
# Memory: $SEAT_NAME

<!-- Persistent context for this agent -->
EOF

cat > "$SEAT_DIR/TOOLS.md" <<EOF
# Tools: $SEAT_NAME

<!-- Tool configurations and credentials -->
EOF

echo "✓ Seat created: $SEAT_DIR"
echo ""
echo "Next steps:"
echo "  1. Edit $SEAT_DIR/AGENT.md to define the agent"
echo "  2. Commit: git add $SEAT_DIR && git commit -m 'Add seat: $SEAT_NAME'"
