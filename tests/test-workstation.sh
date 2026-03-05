#!/usr/bin/env bash
#
# Test suite for Workstation
#

set -euo pipefail

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSTATION_DIR="$(dirname "$TEST_DIR")"
TEMP_DIR="/tmp/workstation-test-$$"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

passed=0
failed=0

log_test() {
    echo -e "${YELLOW}[TEST]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((passed++))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((failed++))
}

# Setup
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

mkdir -p "$TEMP_DIR"

# Test 1: Scripts are executable
test_scripts_executable() {
    log_test "Scripts are executable"
    
    local scripts=("$WORKSTATION_DIR/scripts/create-seat.sh" "$WORKSTATION_DIR/scripts/create-project.sh" "$WORKSTATION_DIR/scripts/create-sprint.sh" "$WORKSTATION_DIR/install.sh")
    
    for script in "${scripts[@]}"; do
        if [[ -x "$script" ]]; then
            log_pass "$(basename "$script") is executable"
        else
            log_fail "$(basename "$script") is not executable"
        fi
    done
}

# Test 2: Scripts have valid syntax
test_scripts_syntax() {
    log_test "Scripts have valid bash syntax"
    
    local scripts=("$WORKSTATION_DIR/scripts/create-seat.sh" "$WORKSTATION_DIR/scripts/create-project.sh" "$WORKSTATION_DIR/scripts/create-sprint.sh" "$WORKSTATION_DIR/install.sh")
    
    for script in "${scripts[@]}"; do
        if bash -n "$script" 2>/dev/null; then
            log_pass "$(basename "$script") syntax OK"
        else
            log_fail "$(basename "$script") has syntax errors"
        fi
    done
}

# Test 3: Required files exist
test_required_files() {
    log_test "Required files exist"
    
    local files=("$WORKSTATION_DIR/README.md" "$WORKSTATION_DIR/LICENSE" "$WORKSTATION_DIR/CONTRIBUTING.md" "$WORKSTATION_DIR/CHANGELOG.md" "$WORKSTATION_DIR/.env.example")
    
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            log_pass "$(basename "$file") exists"
        else
            log_fail "$(basename "$file") missing"
        fi
    done
}

# Test 4: Blueprint structure
test_blueprint_structure() {
    log_test "Blueprint structure is valid"
    
    if [[ -d "$WORKSTATION_DIR/blueprint" ]]; then
        log_pass "blueprint/ directory exists"
    else
        log_fail "blueprint/ directory missing"
    fi
    
    if [[ -d "$WORKSTATION_DIR/blueprint/ssot" ]]; then
        log_pass "blueprint/ssot/ exists"
    else
        log_fail "blueprint/ssot/ missing"
    fi
}

# Test 5: Documentation structure
test_docs_structure() {
    log_test "Documentation structure is valid"
    
    local docs=("$WORKSTATION_DIR/docs/README.md" "$WORKSTATION_DIR/docs/architecture.md" "$WORKSTATION_DIR/docs/getting-started.md" "$WORKSTATION_DIR/docs/best-practices.md")
    
    for doc in "${docs[@]}"; do
        if [[ -f "$doc" ]]; then
            log_pass "docs/$(basename "$doc") exists"
        else
            log_fail "docs/$(basename "$doc") missing"
        fi
    done
}

# Test 6: GitHub templates
test_github_templates() {
    log_test "GitHub templates exist"
    
    if [[ -d "$WORKSTATION_DIR/.github/ISSUE_TEMPLATE" ]]; then
        log_pass ".github/ISSUE_TEMPLATE/ exists"
    else
        log_fail ".github/ISSUE_TEMPLATE/ missing"
    fi
    
    if [[ -f "$WORKSTATION_DIR/.github/workflows/ci.yml" ]]; then
        log_pass "CI workflow exists"
    else
        log_fail "CI workflow missing"
    fi
}

# Test 7: Examples exist
test_examples() {
    log_test "Examples exist"
    
    local examples=("minimal-team" "startup" "enterprise")
    
    for example in "${examples[@]}"; do
        if [[ -d "$WORKSTATION_DIR/examples/$example" ]]; then
            log_pass "examples/$example/ exists"
        else
            log_fail "examples/$example/ missing"
        fi
    done
}

# Run all tests
main() {
    echo "=========================================="
    echo "  Workstation Test Suite"
    echo "=========================================="
    echo ""
    
    test_scripts_executable
    test_scripts_syntax
    test_required_files
    test_blueprint_structure
    test_docs_structure
    test_github_templates
    test_examples
    
    echo ""
    echo "=========================================="
    echo "  Results: $passed passed, $failed failed"
    echo "=========================================="
    
    if [[ $failed -gt 0 ]]; then
        exit 1
    fi
}

main "$@"
