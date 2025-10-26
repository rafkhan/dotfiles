#!/bin/bash

# Dotfiles setup script
# This script creates symlinks from home directory to dotfiles directory

DOTFILES_DIR="$HOME/Developer/dotfiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up dotfiles...${NC}\n"

# Function to safely create symlink
safe_link() {
    local src="$1"
    local dest="$2"

    # Check if source exists
    if [ ! -e "$src" ]; then
        echo -e "${RED}✗ Source does not exist: $src${NC}"
        return 1
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # Check if destination already exists
    if [ -L "$dest" ]; then
        # It's already a symlink
        local current_target=$(readlink "$dest")
        if [ "$current_target" = "$src" ]; then
            echo -e "${GREEN}✓ Already linked: $dest → $src${NC}"
            return 0
        else
            echo -e "${YELLOW}! Removing old symlink: $dest → $current_target${NC}"
            rm "$dest"
        fi
    elif [ -e "$dest" ]; then
        # It exists but is not a symlink - back it up
        local backup="${dest}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}! Backing up existing file: $dest → $backup${NC}"
        mv "$dest" "$backup"
    fi

    # Create the symlink
    ln -sf "$src" "$dest"
    echo -e "${GREEN}✓ Linked: $dest → $src${NC}"
}

# Link dotfiles
echo -e "${BLUE}Linking dotfiles...${NC}"
safe_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
safe_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

echo -e "\n${GREEN}Setup complete!${NC}"
echo -e "\n${BLUE}Next steps:${NC}"
echo -e "  1. Reload your shell: ${YELLOW}source ~/.zshrc${NC}"
echo -e "  2. Open Neovim to install plugins: ${YELLOW}nvim${NC}"
