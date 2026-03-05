#!/usr/bin/env bash
#
# Create a new Sprint within the current SSOT
#

set -euo pipefail

SPRINT_NAME="${1:-}"
if [[ -z "$SPRINT_NAME" ]]; then
    echo "Usage: $0 <sprint-name>"
    echo "Example: $0 2026-03-foundation"
    exit 1
fi

# Check if we're in an SSOT directory
if [[ ! -f "SSOT.md" ]] && [[ ! -d "Sprints" ]]; then
    echo "Error: Must run from an SSOT directory"
    echo "Current directory: $(pwd)"
    echo "Expected: SSOT-<ORG_NAME>/"
    exit 1
fi

SPRINT_DIR="Sprints/$SPRINT_NAME"

if [[ -d "$SPRINT_DIR" ]]; then
    echo "Error: Sprint '$SPRINT_NAME' already exists"
    exit 1
fi

mkdir -p "$SPRINT_DIR"

cat > "$SPRINT_DIR/README.md" <>EOF
# Sprint: $SPRINT_NAME

**Status**: Planning  
**Start**: <!-- YYYY-MM-DD -->  
**End**: <!-- YYYY-MM-DD -->  
**Duration**: <!-- X weeks -->

## Goals

1. <!-- Primary goal -->
2. <!-- Secondary goal -->
3. <!-- Tertiary goal -->

## Capacity

| Seat | Capacity | Notes |
|------|----------|-------|
| <!-- Seat name --> | <!-- % --> | <!-- Notes --> |

## Projects

- [ ] <!-- Project 1 -->
- [ ] <!-- Project 2 -->

## Deliverables

- [ ] <!-- Deliverable 1 -->
- [ ] <!-- Deliverable 2 -->
- [ ] <!-- Deliverable 3 -->

## Daily Log

### <!-- YYYY-MM-DD -->

- <!-- What happened -->

## Retrospective

### What Went Well

- <!-- Success 1 -->

### What Could Be Improved

- <!-- Improvement 1 -->

### Action Items for Next Sprint

- [ ] <!-- Action 1 -->
EOF

echo ""
echo "✅ Sprint created: $SPRINT_DIR"
echo ""
echo "Next steps:"
echo "  1. Edit $SPRINT_DIR/README.md with dates and goals"
echo "  2. Commit the sprint:"
echo "     git add $SPRINT_DIR"
echo "     git commit -m 'Add sprint: $SPRINT_NAME'"
