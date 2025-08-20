#!/usr/bin/env bash
# ButterBash Installation Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BUTTERBASH_DIR="$HOME/.config/bash"
BACKUP_DIR="$HOME/.config/bash.backup.$(date +%Y%m%d_%H%M%S)"

# Print colored message
print_msg() {
    echo -e "${2}${1}${NC}"
}

# Print header
print_header() {
    echo
    print_msg "🧈 ButterBash Installer" "$YELLOW"
    print_msg "======================" "$YELLOW"
    echo
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Backup existing configuration
backup_existing() {
    if [ -d "$BUTTERBASH_DIR" ] || [ -f "$HOME/.bashrc" ]; then
        print_msg "📦 Backing up existing configuration..." "$BLUE"
        
        # Backup .bashrc if it exists
        if [ -f "$HOME/.bashrc" ]; then
            cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"
            print_msg "   ✓ Backed up .bashrc" "$GREEN"
        fi
        
        # Backup existing bash config directory
        if [ -d "$BUTTERBASH_DIR" ]; then
            mv "$BUTTERBASH_DIR" "$BACKUP_DIR"
            print_msg "   ✓ Backed up existing config to $BACKUP_DIR" "$GREEN"
        fi
    fi
}

# Install ButterBash
install_butterbash() {
    print_msg "🚀 Installing ButterBash..." "$BLUE"
    
    # Create config directory
    mkdir -p "$BUTTERBASH_DIR/functions"
    
    # Copy configuration files
    cp -r bash/* "$BUTTERBASH_DIR/"
    print_msg "   ✓ Copied configuration files" "$GREEN"
    
    # Install main bashrc
    if [ -f "bashrc.example" ]; then
        cp bashrc.example "$HOME/.bashrc"
        print_msg "   ✓ Installed .bashrc" "$GREEN"
    fi
    
    # Note: .notes and .tasks files are created on first use
}

# Install optional dependencies
install_dependencies() {
    echo
    read -p "$(echo -e ${YELLOW}Would you like to install recommended tools? [fzf, ripgrep] \(y/N\): ${NC})" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_msg "📦 Installing recommended tools..." "$BLUE"
        
        # Detect package manager
        if command_exists apt; then
            PKG_MGR="apt"
            INSTALL_CMD="sudo apt install -y"
        elif command_exists dnf; then
            PKG_MGR="dnf"
            INSTALL_CMD="sudo dnf install -y"
        elif command_exists pacman; then
            PKG_MGR="pacman"
            INSTALL_CMD="sudo pacman -S --noconfirm"
        elif command_exists brew; then
            PKG_MGR="brew"
            INSTALL_CMD="brew install"
        else
            print_msg "   ⚠ Could not detect package manager" "$YELLOW"
            return
        fi
        
        # Install fzf
        if ! command_exists fzf; then
            print_msg "   Installing fzf..." "$BLUE"
            $INSTALL_CMD fzf
        else
            print_msg "   ✓ fzf already installed" "$GREEN"
        fi
        
        # Install ripgrep
        if ! command_exists rg; then
            print_msg "   Installing ripgrep..." "$BLUE"
            $INSTALL_CMD ripgrep
        else
            print_msg "   ✓ ripgrep already installed" "$GREEN"
        fi
        
        # Try to install eza (might not be available in all repos)
        if ! command_exists eza && ! command_exists exa; then
            print_msg "   Installing eza/exa..." "$BLUE"
            $INSTALL_CMD eza 2>/dev/null || $INSTALL_CMD exa 2>/dev/null || print_msg "   ⚠ eza/exa not available" "$YELLOW"
        else
            print_msg "   ✓ eza/exa already installed" "$GREEN"
        fi
    fi
}

# Main installation
main() {
    print_header
    
    # Check bash version
    if [ "${BASH_VERSION%%.*}" -lt 4 ]; then
        print_msg "⚠ Warning: Bash version 4+ recommended (you have $BASH_VERSION)" "$YELLOW"
    fi
    
    # Skip confirmation if called with --yes flag or from another installer
    if [[ "$1" != "--yes" ]] && [[ -z "$SKIP_CONFIRMATION" ]]; then
        # Confirm installation
        echo "This will install ButterBash to $BUTTERBASH_DIR"
        echo "Your existing configuration will be backed up."
        echo
        read -p "$(echo -e ${YELLOW}Continue with installation? \(y/N\): ${NC})" -n 1 -r
        echo
        
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_msg "Installation cancelled" "$RED"
            exit 1
        fi
    fi
    
    # Run installation steps
    backup_existing
    install_butterbash
    install_dependencies
    
    # Success message
    echo
    print_msg "✨ ButterBash installed successfully!" "$GREEN"
    echo
    print_msg "To get started:" "$BLUE"
    print_msg "  1. Reload your shell: source ~/.bashrc" "$NC"
    print_msg "  2. Try 'note help' or 'todo help' to explore features" "$NC"
    print_msg "  3. Check the README for full documentation" "$NC"
    echo
    print_msg "Enjoy your butter-smooth shell experience! 🧈" "$YELLOW"
}

# Run main function
main "$@"