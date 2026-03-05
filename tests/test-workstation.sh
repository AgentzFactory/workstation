#!/usr/bin/env bash
#
# Test suite for Workstation
#

set -euo pipefail

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSTATION_DIR="$(dirname "$TEST_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

passed=0
failed=0

log_test() { echo -e "${YELLOW}[TEST]${NC} $1"; }
log_pass() { echo -e "${GREEN}[PASS]${NC} $1"; passed=$((passed+1)); }
log_fail() { echo -e "${RED}[FAIL]${NC} $1"; failed=$((failed+1)); }

test_scripts_exist() {
    log_test "Scripts exist and are executable"
    
    local scripts=("install.sh" "scripts/create-seat.sh" "scripts/create-project.sh")
    
    for script in "${scripts[@]}"; do
        local path="$WORKSTATION_DIR/$script"
        if [[ -x "$path" ]]; then
            log_pass "$script is executable"
        else
            log_fail "$script missing or not executable"
        fi
    done
}

test_scripts_syntax() {
    log_test "Scripts have valid bash syntax"
    
    local scripts=("install.sh" "scripts/create-seat.sh" "scripts/create-project.sh")
    
    for script in "${scripts[@]}"; do
        if bash -n "$WORKSTATION_DIR/$script" 2>/dev/null; then
            log_pass "$script syntax OK"
        else
            log_fail "$script has syntax errors"
        fi
    done
}

test_required_files() {
    log_test "Required files exist"
    
    local files=("README.md" "LICENSE" "CONTRIBUTING.md" "CHANGELOG.md" ".env.example")
    
    for file in "${files[@]}"; do
        if [[ -f "$WORKSTATION_DIR/$file" ]]; then
            log_pass "$file exists"
        else
            log_fail "$file missing"
        fi
    done
}

test_docs() {
    log_test "Documentation exists"
    
    local docs=("docs/README.md" "docs/architecture.md" "docs/getting-started.md")
    
    for doc in "${docs[@]}"; do
        if [[ -f "$WORKSTATION_DIR/$doc" ]]; then
            log_pass "$(basename "$doc") exists"
        else
            log_fail "$(basename "$doc") missing"
        fi
    done
}

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

test_github_templates() {
    log_test "GitHub templates exist"
    
    if [[ -d "$WORKSTATION_DIR/.github/ISSUE_TEMPLATE" ]]; then
        log_pass ".github/ISSUE_TEMPLATE/ exists"
    else
        log_fail ".github/ISSUE_TEMPLATE/ missing"
    fi
}

main() {
    echo "=========================================="
    echo "  Workstation Test Suite"
    echo "=========================================="
    echo ""
    
    test_scripts_exist
    test_scripts_syntax
    test_required_files
    test_docs
    test_examples
    test_github_templates
    
    echo ""
    echo "=========================================="
    echo "  Results: $passed passed, $failed failed"
    echo "=========================================="
    
    [[ $failed -eq 0 ]] || exit 1
}

main "$@"
