#!/bin/bash

# Script to sync nvim config and update dotfiles submodule reference
# Usage: ./sync-nvim.sh [commit message]

set -e  # Exit on any error

DOTFILES_DIR="$HOME/Developer/dotfiles"
NVIM_DIR="$DOTFILES_DIR/nvim"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default commit message if none provided
NVIM_COMMIT_MSG="${1:-Update nvim config}"
DOTFILES_COMMIT_MSG="Update nvim submodule"

echo -e "${BLUE}=== Syncing Neovim Config ===${NC}\n"

# Step 1: Commit and push nvim repo
echo -e "${BLUE}[1/4]${NC} Checking nvim repo for changes..."
cd "$NVIM_DIR"

if [[ -n $(git status --porcelain) ]]; then
    echo -e "${YELLOW}Found changes in nvim repo${NC}"

    git add .
    echo -e "${GREEN}✓ Staged all changes${NC}"

    git commit -m "$NVIM_COMMIT_MSG"
    echo -e "${GREEN}✓ Committed: $NVIM_COMMIT_MSG${NC}"

    echo -e "${BLUE}[2/4]${NC} Pushing nvim repo..."
    git push
    echo -e "${GREEN}✓ Pushed nvim repo${NC}\n"
else
    echo -e "${GREEN}✓ No changes in nvim repo${NC}\n"
fi

# Step 2: Update submodule reference in dotfiles
echo -e "${BLUE}[3/4]${NC} Updating dotfiles submodule reference..."
cd "$DOTFILES_DIR"

if [[ -n $(git status --porcelain nvim) ]]; then
    echo -e "${YELLOW}Submodule reference needs updating${NC}"

    git add nvim
    echo -e "${GREEN}✓ Staged submodule update${NC}"

    git commit -m "$DOTFILES_COMMIT_MSG"
    echo -e "${GREEN}✓ Committed submodule update${NC}"

    echo -e "${BLUE}[4/4]${NC} Pushing dotfiles repo..."
    git push
    echo -e "${GREEN}✓ Pushed dotfiles repo${NC}\n"
else
    echo -e "${GREEN}✓ Submodule reference already up to date${NC}\n"
fi

echo -e "${GREEN}=== Sync Complete! ===${NC}"
