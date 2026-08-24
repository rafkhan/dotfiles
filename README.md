# Dotfiles

My personal dotfiles and configurations. Works on **macOS** and **Linux/WSL** from the same checkout.

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

`setup.sh` locates the repo from its own path, so the checkout does not have to
live at `~/Developer/dotfiles`.

### Dependencies

**macOS:**

```bash
brew install zsh neovim ripgrep fd fzf
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s /bin/zsh
```

**Ubuntu / WSL:**

```bash
sudo apt update && sudo apt install -y zsh build-essential ripgrep fd-find unzip fzf
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo chsh -s /usr/bin/zsh "$USER"
```

Ubuntu's `neovim` package is too old for this config (kickstart needs 0.10+).
Install the official build instead:

```bash
curl -fsSL -o /tmp/nvim.tar.gz \
  https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
mkdir -p ~/.local/opt && tar -xzf /tmp/nvim.tar.gz -C ~/.local/opt
ln -sfn ~/.local/opt/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
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

- `~/.zshrc` → `<dotfiles>/.zshrc`
- `~/.config/nvim` → `<dotfiles>/nvim`
- `~/.config/ghostty/themes` → `<dotfiles>/gruvbox-material-ghostty/themes` (macOS/Linux only —
  Ghostty has no Windows build, so `setup.sh` skips this under WSL)

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

## Platform Notes

`.zshrc` detects the platform at startup (`IS_MACOS`, `IS_LINUX`, `IS_WSL`) and
guards everything machine-specific, so the same file is safe on both boxes:

- **PATH entries are only added if the directory exists** (`path_prepend`), so a
  Mac-only Homebrew path doesn't leave a dead entry on Linux.
- **Homebrew** is picked up from `/opt/homebrew`, `/usr/local`, or Linuxbrew, and
  skipped entirely when absent. Keg-only paths hang off `$HOMEBREW_PREFIX`.
- **pnpm** resolves to `~/Library/pnpm` on macOS, `~/.local/share/pnpm` elsewhere.
- **`$DOTFILES`** is auto-detected and used for the `dotf` alias and the API key.
- **`fixss`** is only defined when ImageMagick is installed.

### WSL

The Linux home stays a real Linux home. The Windows side is reached through a
single symlink rather than mounting it over `~`:

- `~/winhome` → `/mnt/c/Users/<you>`, plus `$WINHOME` / `$WINDESKTOP` and the
  `winhome`, `desk`, and `open` (Explorer) aliases.

Do **not** point `~` at `/mnt/c`. DrvFs reports every file as `777`, so SSH
refuses to use `~/.ssh` keys; it is also far slower and case-insensitive, and
the legacy junctions (`Application Data`, `Cookies`) error when tools walk them.

### Machine-local overrides

`~/.zshrc.local` is sourced last if present. Keep per-machine paths and secrets
there — it is outside the repo and never committed.
