#!/usr/bin/env bash
#
# Create a new Project
#

set -euo pipefail

PROJECT_NAME="${1:-}"
if [[ -z "$PROJECT_NAME" ]]; then
    echo "Usage: $0 <project-name>"
    echo "Example: $0 api-redesign"
    exit 1
fi

PROJECT_DIR="SSOT/Projects/$PROJECT_NAME"

if [[ -d "$PROJECT_DIR" ]]; then
    echo "Error: Project '$PROJECT_NAME' already exists"
    exit 1
fi

mkdir -p "$PROJECT_DIR"

cat > "$PROJECT_DIR/README.md" <<EOF
# Project: $PROJECT_NAME

**Status**: Planning
**Created**: $(date -u +"%Y-%m-%d")

## Objective

<!-- What this project achieves -->

## Scope

<!-- Inclusions and exclusions -->

## Related

- **Seats**: <!-- Link relevant seats -->
- **KBs**: <!-- Link knowledge bases -->
- **Sprints**: <!-- Link sprints -->

## Deliverables

- [ ] <!-- Deliverable 1 -->
- [ ] <!-- Deliverable 2 -->

## Decisions

<!-- Key decisions log -->
EOF

echo "✓ Project created: $PROJECT_DIR"
echo ""
echo "Next steps:"
echo "  1. Edit $PROJECT_DIR/README.md"
echo "  2. Commit: git add $PROJECT_DIR && git commit -m 'Add project: $PROJECT_NAME'"
