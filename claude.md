# macOS Dotfiles, Automations & Shortcuts Guide

A comprehensive guide for setting up and managing macOS dotfiles, automations, and productivity shortcuts.

## Table of Contents

- [Dotfiles Management](#dotfiles-management)
- [Neovim Configuration](#neovim-configuration)
- [Shell Configuration](#shell-configuration)
- [Package Management](#package-management)
- [Git Configuration](#git-configuration)
- [macOS System Preferences](#macos-system-preferences)
- [Automations](#automations)
- [Keyboard Shortcuts](#keyboard-shortcuts)
- [Productivity Tools](#productivity-tools)

## Dotfiles Management

### Symlink Strategy

Use symbolic links to keep dotfiles in a centralized repository:

```bash
# Link individual dotfiles
ln -s ~/Developer/dotfiles/.zshrc ~/.zshrc
ln -s ~/Developer/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/Developer/dotfiles/.vimrc ~/.vimrc

# Create config directories if needed
mkdir -p ~/.config
ln -s ~/Developer/dotfiles/.config/nvim ~/.config/nvim
```

### Automated Setup Script

Create a `setup.sh` script for quick bootstrapping:

```bash
#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to create symlink
link_file() {
    local src=$1
    local dest=$2

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo -e "${YELLOW}Backing up existing $dest${NC}"
        mv "$dest" "${dest}.backup"
    fi

    ln -sf "$src" "$dest"
    echo -e "${GREEN}Linked $src -> $dest${NC}"
}

# Link dotfiles
link_file "$HOME/Developer/dotfiles/.zshrc" "$HOME/.zshrc"
link_file "$HOME/Developer/dotfiles/.gitconfig" "$HOME/.gitconfig"
link_file "$HOME/Developer/dotfiles/.vimrc" "$HOME/.vimrc"

echo -e "${GREEN}Setup complete!${NC}"
```

### Git-based Dotfiles

Initialize as a git repository for version control:

```bash
cd ~/Developer/dotfiles
git init
git add .
git commit -m "Initial dotfiles commit"
git remote add origin https://github.com/yourusername/dotfiles.git
git push -u origin main
```

## Shell Configuration

### Zsh Configuration (.zshrc)

Essential .zshrc components:

```bash
# Oh My Zsh (optional but recommended)
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"  # or "powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    kubectl
    npm
    brew
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias ll='ls -lah'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias g='git'
alias gst='git status'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git pull'
alias gpu='git push'

# Custom paths
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# Editor
export EDITOR='vim'
export VISUAL='vim'

# History
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# Functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract archives
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
```

### Fish Shell Alternative

```fish
# ~/.config/fish/config.fish

# Aliases
alias ll='ls -lah'
alias g='git'

# Environment variables
set -x EDITOR vim
set -x PATH $HOME/bin $PATH

# Custom functions in ~/.config/fish/functions/
```

## Package Management

### Homebrew Setup

Install and configure Homebrew:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH (Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
```

### Brewfile for Automated Installation

Create a `Brewfile`:

```ruby
# Taps
tap "homebrew/bundle"
tap "homebrew/cask-fonts"

# CLI Tools
brew "git"
brew "vim"
brew "neovim"
brew "htop"
brew "tree"
brew "wget"
brew "curl"
brew "jq"
brew "ripgrep"
brew "fd"
brew "bat"
brew "eza"  # Modern replacement for ls
brew "fzf"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "gh"  # GitHub CLI
brew "tldr"
brew "node"
brew "python"
brew "go"
brew "zoxide"  # Smarter cd command

# Casks (Applications)
cask "visual-studio-code"
cask "iterm2"
cask "warp"  # Modern terminal
cask "rectangle"  # Window management
cask "alfred"
cask "raycast"  # Alfred alternative
cask "docker"
cask "firefox"
cask "google-chrome"
cask "arc"  # Modern browser
cask "slack"
cask "discord"
cask "notion"
cask "obsidian"
cask "spotify"
cask "1password"

# Fonts
cask "font-fira-code"
cask "font-jetbrains-mono"
cask "font-hack-nerd-font"
cask "font-meslo-lg-nerd-font"

# Mac App Store apps (requires mas)
brew "mas"
mas "Amphetamine", id: 937984704
```

Install from Brewfile:

```bash
brew bundle --file=~/Developer/dotfiles/Brewfile
```

## Git Configuration

### Global .gitconfig

```ini
[user]
    name = Your Name
    email = your.email@example.com

[core]
    editor = vim
    excludesfile = ~/.gitignore_global
    autocrlf = input
    pager = less -FRX

[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = log --oneline --graph --decorate --all
    amend = commit --amend --no-edit
    undo = reset --soft HEAD^
    clean-branches = "!git branch --merged | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -d"

[color]
    ui = auto

[push]
    default = current
    autoSetupRemote = true

[pull]
    rebase = true

[diff]
    tool = vimdiff

[merge]
    tool = vimdiff
    conflictstyle = diff3

[init]
    defaultBranch = main

[credential]
    helper = osxkeychain
```

### Global .gitignore

```bash
# ~/.gitignore_global

# macOS
.DS_Store
.AppleDouble
.LSOverride
._*
.Spotlight-V100
.Trashes

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# Environment
.env
.env.local
*.log

# Dependencies
node_modules/
venv/
__pycache__/
```

## macOS System Preferences

### defaults Command Script

Automate macOS settings:

```bash
#!/bin/bash
# macos-defaults.sh

# Close System Preferences to prevent override
osascript -e 'tell application "System Preferences" to quit'

# General UI/UX
# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Trackpad & Mouse
# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2

# Increase tracking speed
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3.0

# Finder
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show the ~/Library folder
chflags nohidden ~/Library

# Show absolute path in Finder title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Dock
# Set the icon size
defaults write com.apple.dock tilesize -int 48

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Remove auto-hide delay
defaults write com.apple.dock autohide-delay -float 0

# Speed up animations
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Don't show recent applications
defaults write com.apple.dock show-recents -bool false

# Screenshots
# Save to Pictures/Screenshots
mkdir -p ~/Pictures/Screenshots
defaults write com.apple.screencapture location -string "~/Pictures/Screenshots"

# Save as PNG
defaults write com.apple.screencapture type -string "png"

# Disable shadow
defaults write com.apple.screencapture disable-shadow -bool true

# Restart affected applications
for app in "Dock" "Finder"; do
    killall "${app}" &> /dev/null
done

echo "Done! Some changes require logout/restart."
```

## Automations

### Keyboard Maestro Macros

Common automation ideas:

1. **Text Expansion**: Auto-expand abbreviations (e.g., `@@` → email address)
2. **Window Management**: Hotkeys for window positioning
3. **Application Launching**: Quick access to frequent apps
4. **Clipboard History**: Enhanced clipboard management
5. **Date/Time Insertion**: Quick shortcuts for timestamps

### Automator Workflows

#### Quick Action: Open in VS Code

1. Open Automator
2. Create new "Quick Action"
3. Add "Run Shell Script"
4. Paste:

```bash
for f in "$@"
do
    open -a "Visual Studio Code" "$f"
done
```

5. Save as "Open in VS Code"

#### Quick Action: New File Here

```bash
cd "$@"
touch "untitled.txt"
open "untitled.txt"
```

### Hammerspoon Configuration

Lua-based automation (~/.hammerspoon/init.lua):

```lua
-- Window Management
hs.hotkey.bind({"cmd", "alt"}, "Left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt"}, "Right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

-- Maximize window
hs.hotkey.bind({"cmd", "alt"}, "F", function()
    local win = hs.window.focusedWindow()
    win:maximize()
end)

-- Center window
hs.hotkey.bind({"cmd", "alt"}, "C", function()
    local win = hs.window.focusedWindow()
    win:centerOnScreen()
end)

-- Auto-reload config
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
end)

hs.alert.show("Config loaded")
```

### Apple Shortcuts

Create custom shortcuts using Shortcuts.app:

1. **Quick Note**: Capture text to note app
2. **WiFi Toggle**: Quick WiFi on/off
3. **Do Not Disturb Timer**: Set DND for specific duration
4. **File Organization**: Auto-organize downloads by type

## Keyboard Shortcuts

### System-wide Custom Shortcuts

Configure in System Settings > Keyboard > Keyboard Shortcuts:

- **Screenshot region**: Cmd+Shift+4
- **Screenshot window**: Cmd+Shift+5
- **Lock screen**: Cmd+Ctrl+Q
- **Force quit**: Cmd+Option+Esc
- **Spotlight**: Cmd+Space (or use Alfred/Raycast)

### iTerm2 Hotkeys

- **Hotkey window**: Configure a system-wide hotkey (e.g., Cmd+`)
- **Split pane vertically**: Cmd+D
- **Split pane horizontally**: Cmd+Shift+D
- **Navigate panes**: Cmd+Option+Arrow keys
- **Clear buffer**: Cmd+K

### Rectangle (Window Management)

Default shortcuts:

- **Left half**: Ctrl+Option+Left
- **Right half**: Ctrl+Option+Right
- **Top half**: Ctrl+Option+Up
- **Bottom half**: Ctrl+Option+Down
- **Maximize**: Ctrl+Option+Enter
- **Center**: Ctrl+Option+C
- **Next display**: Ctrl+Option+Cmd+Right

## Productivity Tools

### Essential CLI Tools

```bash
# fzf - Fuzzy finder
brew install fzf
$(brew --prefix)/opt/fzf/install

# Usage in .zshrc
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Ctrl+R for command history
# Ctrl+T for file search
# Alt+C for directory navigation

# bat - Better cat with syntax highlighting
brew install bat
alias cat='bat'

# eza - Better ls with icons
brew install eza
alias ls='eza --icons'
alias ll='eza -l --icons'
alias la='eza -la --icons'
alias tree='eza --tree --icons'

# ripgrep - Better grep
brew install ripgrep
alias grep='rg'

# zoxide - Smarter cd command (learns your patterns)
brew install zoxide
eval "$(zoxide init zsh)"
# Use 'z' instead of 'cd'
# e.g., 'z dotfiles' jumps to ~/Developer/dotfiles

# fd - Better find
brew install fd
alias find='fd'

# tldr - Simplified man pages
brew install tldr
# Usage: tldr git, tldr tar, etc.
```

### Alfred/Raycast Workflows

Common workflows and features:

1. **Clipboard Manager**: Save and search clipboard history
2. **Snippets**: Text expansion for common phrases
3. **Calculator**: Quick calculations with natural language
4. **File Search**: Fast file navigation
5. **Web Search**: Custom search engines
6. **Window Management**: Quick window positioning
7. **System Commands**: Sleep, shutdown, restart shortcuts
8. **Currency Converter**: Quick conversions
9. **Emoji Picker**: Fast emoji search

### VS Code Integration

Add to your shell config for quick access:

```bash
# Open current directory in VS Code
alias code.='code .'

# Open specific file/folder
c() {
    if [ $# -eq 0 ]; then
        code .
    else
        code "$@"
    fi
}
```

### Git Aliases & Functions

Add to .zshrc:

```bash
# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# Git functions
gcm() {
    git commit -m "$1"
}

gac() {
    git add . && git commit -m "$1"
}

gacp() {
    git add . && git commit -m "$1" && git push
}

# Create new branch and switch to it
gnb() {
    git checkout -b "$1"
}
```

## Quick Start Checklist

- [ ] Clone dotfiles repository
- [ ] Run setup script to create symlinks
- [ ] Install Homebrew
- [ ] Run `brew bundle` to install packages
- [ ] Apply macOS defaults
- [ ] Configure iTerm2/Warp/Terminal
- [ ] Set up git with SSH keys
- [ ] Install and configure productivity tools (Alfred/Raycast)
- [ ] Set up automations (Hammerspoon/Keyboard Maestro)
- [ ] Configure Rectangle for window management
- [ ] Set up custom keyboard shortcuts
- [ ] Install Oh My Zsh and plugins
- [ ] Configure VS Code settings sync
- [ ] Test and iterate

## Resources

- [GitHub Dotfiles Guide](https://dotfiles.github.io/)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
- [macOS Defaults List](https://macos-defaults.com/)
- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)
- [Hammerspoon Docs](https://www.hammerspoon.org/docs/)

## Maintenance

```bash
# Update Homebrew packages
brew update && brew upgrade && brew cleanup

# Update dotfiles from git
cd ~/Developer/dotfiles && git pull

# Backup current system state
brew bundle dump --force --file=~/Developer/dotfiles/Brewfile

# Commit changes
cd ~/Developer/dotfiles
git add .
git commit -m "Update dotfiles"
git push

# Check for outdated packages
brew outdated

# Clean up old versions
brew autoremove
```

## Tips & Tricks

### Productivity Shortcuts

1. **Use Raycast/Alfred for everything**: Launch apps, search files, calculate, convert units
2. **Master Rectangle**: Learn 3-4 window shortcuts and use them constantly
3. **Enable key repeat**:
   ```bash
   defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
   ```
4. **Speed up keyboard repeat**:
   ```bash
   defaults write NSGlobalDomain KeyRepeat -int 1
   defaults write NSGlobalDomain InitialKeyRepeat -int 10
   ```

### Terminal Productivity

1. **Use `z` instead of `cd`**: Jump to frequently used directories
2. **Use `fzf` for history**: Press Ctrl+R and search your command history
3. **Use aliases**: Create shortcuts for common commands
4. **Use `bat` for better file viewing**: Syntax highlighting makes reading code easier

### Sync Across Machines

```bash
# On machine 1: Push dotfiles
cd ~/Developer/dotfiles
git add .
git commit -m "Update dotfiles"
git push

# On machine 2: Pull and setup
git clone https://github.com/yourusername/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
./setup.sh
brew bundle
```
