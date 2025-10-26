# Dotfiles

My personal macOS dotfiles and configurations.

## Structure

```
dotfiles/
├── .zshrc                    # Zsh shell configuration
├── nvim/                     # Neovim config (git submodule)
├── gruvbox-material-ghostty/ # Ghostty terminal theme (git submodule)
├── setup.sh                  # Setup script for new machines
├── sync-nvim.sh              # Helper script to sync nvim changes
└── claude.md                 # Comprehensive dotfiles guide
```

## Quick Setup

On a new machine:

```bash
git clone <your-repo-url> ~/Developer/dotfiles
cd ~/Developer/dotfiles
git submodule update --init --recursive
./setup.sh
```

## Daily Usage

### Syncing Neovim Config

After making changes to your nvim config:

```bash
# From anywhere:
~/Developer/dotfiles/sync-nvim.sh "Your commit message"

# Or with default message:
~/Developer/dotfiles/sync-nvim.sh
```

This script will:
1. Commit and push changes in the nvim repo
2. Update the submodule reference in dotfiles
3. Push the dotfiles repo

### Adding an Alias

Add to your `.zshrc`:

```bash
alias sync-nvim="~/Developer/dotfiles/sync-nvim.sh"
```

Then use it simply as:

```bash
sync-nvim "Update keybindings"
```

### Updating Other Dotfiles

For changes to `.zshrc` or other files:

```bash
cd ~/Developer/dotfiles
git add .
git commit -m "Update zshrc"
git push
```

## Files Managed by Symlinks

- `~/.zshrc` → `~/Developer/dotfiles/.zshrc`
- `~/.config/nvim` → `~/Developer/dotfiles/nvim`

Changes to these files in either location are reflected everywhere.

## Pulling Updates

```bash
cd ~/Developer/dotfiles
git pull
git submodule update --init --recursive
```

## Resources

See `claude.md` for comprehensive guides on:
- macOS system preferences automation
- Homebrew package management
- Shell configuration
- Git setup
- Keyboard shortcuts and automations
- Productivity tools
