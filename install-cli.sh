#!/usr/bin/env bash
#
# Workstation CLI Installer
# Installs the workstation command to ~/.local/bin
#

set -euo pipefail

REPO_URL="https://github.com/AgentzFactory/workstation"
INSTALL_DIR="${HOME}/.local/bin"
WORKSTATION_DIR="${HOME}/.workstation"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "========================================"
echo "  Workstation CLI Installer"
echo "========================================"
echo ""

# Check dependencies
log_info "Checking dependencies..."

if ! command -v git >/dev/null 2>&1; then
    log_error "git is required but not installed"
    exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
    log_error "GitHub CLI (gh) is required"
    echo "Install from: https://cli.github.com/"
    exit 1
fi

log_success "Dependencies OK"

# Create directories
log_info "Creating directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$WORKSTATION_DIR"
mkdir -p "$WORKSTATION_DIR/orgs"
log_success "Directories created"

# Download workstation CLI
log_info "Installing workstation CLI..."

if [[ -f "bin/workstation" ]]; then
    # Local install (from repo)
    cp "bin/workstation" "$INSTALL_DIR/workstation"
else
    # Remote install
    curl -fsSL "${REPO_URL}/raw/main/bin/workstation" -o "$INSTALL_DIR/workstation"
fi

chmod +x "$INSTALL_DIR/workstation"
log_success "workstation installed to $INSTALL_DIR/workstation"

# Check PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    log_warn "$INSTALL_DIR is not in your PATH"
    echo ""
    echo "Add this to your ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "Then run: source ~/.bashrc (or ~/.zshrc)"
fi

# Verify installation
if command -v workstation >/dev/null 2>&1; then
    log_success "workstation command is available"
elif [[ -f "$INSTALL_DIR/workstation" ]]; then
    log_info "workstation installed but not in PATH yet"
fi

echo ""
echo "========================================"
log_success "Installation complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Ensure ~/.local/bin is in your PATH"
echo "  2. Run: workstation onboard"
echo "  3. Or run: ~/.local/bin/workstation onboard"
echo ""
echo "Documentation: $REPO_URL"
echo ""
