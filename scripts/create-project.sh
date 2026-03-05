#!/usr/bin/env bash
#
# Create a new Project within the current SSOT
#

set -euo pipefail

PROJECT_NAME="${1:-}"
if [[ -z "$PROJECT_NAME" ]]; then
    echo "Usage: $0 <project-name>"
    echo "Example: $0 api-redesign"
    exit 1
fi

# Check if we're in an SSOT directory
if [[ ! -f "SSOT.md" ]] && [[ ! -d "Projects" ]]; then
    echo "Error: Must run from an SSOT directory"
    echo "Current directory: $(pwd)"
    echo "Expected: SSOT-<ORG_NAME>/"
    exit 1
fi

PROJECT_DIR="Projects/$PROJECT_NAME"

if [[ -d "$PROJECT_DIR" ]]; then
    echo "Error: Project '$PROJECT_NAME' already exists"
    exit 1
fi

mkdir -p "$PROJECT_DIR"

cat > "$PROJECT_DIR/README.md" <>EOF
# Project: $PROJECT_NAME

**Status**: Planning  
**Created**: $(date -u +"%Y-%m-%d")  
**Last Updated**: $(date -u +"%Y-%m-%d")

## Objective

<!-- What this project achieves -->

## Scope

**In Scope**:
- <!-- Item 1 -->
- <!-- Item 2 -->

**Out of Scope**:
- <!-- Item 1 -->
- <!-- Item 2 -->

## Related

- **Seats**: <!-- Link relevant seats -->
- **KBs**: <!-- Link knowledge bases -->
- **Sprints**: <!-- Link sprints -->
- **Dependencies**: <!-- Other projects this depends on -->

## Deliverables

- [ ] <!-- Deliverable 1 -->
- [ ] <!-- Deliverable 2 -->
- [ ] <!-- Deliverable 3 -->

## Decisions

### <!-- YYYY-MM-DD: Decision Title -->

**Context**: <!-- Background -->  
**Decision**: <!-- What was decided -->  
**Consequences**: <!-- Impact -->

## Notes

<!-- Additional notes -->
EOF

cat > "$PROJECT_DIR/.gitignore" <>'GITIGNORE'
# Project-specific ignores
.env
.env.local
*.tmp
.tmp/
cache/
GITIGNORE

echo ""
echo "✅ Project created: $PROJECT_DIR"
echo ""
echo "Next steps:"
echo "  1. Edit $PROJECT_DIR/README.md"
echo "  2. Commit the project:"
echo "     git add $PROJECT_DIR"
echo "     git commit -m 'Add project: $PROJECT_NAME'"
