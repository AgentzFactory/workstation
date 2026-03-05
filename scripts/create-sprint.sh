#!/usr/bin/env bash
#
# Create a new Sprint
#

set -euo pipefail

SPRINT_NAME="${1:-}"
if [[ -z "$SPRINT_NAME" ]]; then
    echo "Usage: $0 <sprint-name>"
    echo "Example: $0 2026-03-foundation"
    exit 1
fi

SPRINT_DIR="SSOT/Sprints/$SPRINT_NAME"

if [[ -d "$SPRINT_DIR" ]]; then
    echo "Error: Sprint '$SPRINT_NAME' already exists"
    exit 1
fi

mkdir -p "$SPRINT_DIR"

cat > "$SPRINT_DIR/README.md" <<EOF
# Sprint: $SPRINT_NAME

**Status**: Planning
**Start**: <!-- YYYY-MM-DD -->
**End**: <!-- YYYY-MM-DD -->

## Goals

<!-- Sprint objectives -->

## Projects

<!-- Linked projects -->

## Deliverables

- [ ] <!-- Item 1 -->
- [ ] <!-- Item 2 -->

## Retrospective

<!-- Post-sprint review -->
EOF

echo "✓ Sprint created: $SPRINT_DIR"
echo ""
echo "Next steps:"
echo "  1. Edit $SPRINT_DIR/README.md"
echo "  2. Commit: git add $SPRINT_DIR && git commit -m 'Add sprint: $SPRINT_NAME'"
