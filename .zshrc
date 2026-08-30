# ---------------------------------------------------------------------------
# Platform detection — this file is shared between macOS and Linux/WSL.
# Anything machine-specific below is guarded, so the same .zshrc works on both.
# ---------------------------------------------------------------------------
unset IS_MACOS IS_LINUX IS_WSL
case "$OSTYPE" in
  darwin*) IS_MACOS=1 ;;
  linux*)
    IS_LINUX=1
    [[ -r /proc/version ]] && grep -qi microsoft /proc/version && IS_WSL=1
    ;;
esac

# Prepend to PATH only if the directory exists and isn't already there, so a
# config shared across machines doesn't accumulate dead entries.
path_prepend() {
  [[ -d "$1" ]] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

# Where this dotfiles checkout lives (mac: ~/Developer/dotfiles, WSL: /mnt/c/...).
if [[ -z "$DOTFILES" ]]; then
  for _d in "$HOME/Developer/dotfiles" "/mnt/c/Users/$USER/dotfiles"; do
    if [[ -d "$_d" ]]; then export DOTFILES="$_d"; break; fi
  done
  unset _d
fi

# Homebrew (Apple Silicon, Intel mac, or Linuxbrew). Sets HOMEBREW_PREFIX, PATH,
# MANPATH. Skipped entirely when brew isn't installed.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [[ -x "$_brew" ]]; then eval "$("$_brew" shellenv)"; break; fi
done
unset _brew

# ---------------------------------------------------------------------------
# oh-my-zsh
# ---------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="wedisagree"

plugins=(git)

if [[ -d "$ZSH" ]]; then
  source $ZSH/oh-my-zsh.sh
  OMZ_LOADED=1
else
  print -u2 "warning: oh-my-zsh not found at $ZSH — run \$DOTFILES/setup.sh"
fi

if [[ -n "$CLAUDECODE" ]]; then
  # Inside Claude Code: plain ASCII prompt, no colors, no git status,
  # so escape codes don't leak into tool output.
  PROMPT='%~ %# '
  RPROMPT=''
elif [[ -n "$OMZ_LOADED" ]]; then
  # Obvious, text-label git prompt (no emojis — they break width calculation
  # and wrap the line in some terminals).
  ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[red]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} [dirty]"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} [untracked]"
  ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} [clean]"
  ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} [added]"
  ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} [modified]"
  ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} [deleted]"
  ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} [renamed]"
  ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} [conflict]"
  ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%} [ahead]"
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# ---------------------------------------------------------------------------
# Language runtimes / package managers
# ---------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm — macOS puts it under ~/Library, Linux under XDG data dir
if [[ -n "$IS_MACOS" ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
fi
path_prepend "$PNPM_HOME"
# pnpm end

# Homebrew keg-only formulae (macOS/Linuxbrew only)
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  path_prepend "$HOMEBREW_PREFIX/opt/jpeg/bin"
  path_prepend "$HOMEBREW_PREFIX/opt/postgresql@17/bin"
fi

# bun
export BUN_INSTALL="$HOME/.bun"
path_prepend "$BUN_INSTALL/bin"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"  # bun completions

export PATH=/usr/bin:$PATH

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/go/bin"
path_prepend "$HOME/.opencode/bin"
path_prepend "$HOME/.cargo/bin"

export PYENV_ROOT="$HOME/.pyenv"
path_prepend "$PYENV_ROOT/bin"
command -v pyenv >/dev/null && eval "$(pyenv init - zsh)"

# ---------------------------------------------------------------------------
# Git helpers
# ---------------------------------------------------------------------------
gpc() {
    git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)
}

glc() {
    git pull origin $(git rev-parse --abbrev-ref HEAD)
}

git-clean-branches() {
  git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d
}

alias gll="git log --all --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
alias n='nvim'

# Shopify Hydrogen alias to local projects
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'

BINGO_DIR="$HOME/Developer/okay/hub/bingo"
alias bn="bash $BINGO_DIR/scripts/dev.sh"
alias bnn="bn --no-compile"
alias bnv="bash $BINGO_DIR/scripts/build-vst3-debug.sh && $BINGO_DIR/scripts/install-vst3.sh Debug"

alias clod="claude"
alias c="claude"
alias cdanger="claude --dangerously-skip-permissions"
alias retardmode="claude --dangerously-skip-permissions"

alias ok='cd ~/Developer/okay'
alias hub='cd ~/Developer/okay/hub'
alias nconf="cd ~/.config/nvim"
alias dotf='cd "$DOTFILES"'

# claude-mem worker — the install path is version-pinned, so resolve the newest
# one present rather than hardcoding a version.
# The (N) qualifier is zsh's nullglob: without it an unmatched pattern is a
# hard error, which would break shell startup on a machine without the plugin.
_cm_matches=( "$HOME"/.claude/plugins/cache/thedotmack/claude-mem/*/scripts/worker-service.cjs(N) )
if (( ${#_cm_matches} )); then
  _cm=$(printf '%s\n' "${_cm_matches[@]}" | sort -V | tail -1)
  alias claude-mem="bun '$_cm'"
fi
unset _cm _cm_matches

# Screenshot fixup — needs ImageMagick, which is only set up on the mac.
if command -v magick >/dev/null; then
  alias fixss='cd ~/Desktop && for f in Screenshot*.png; do magick "$f" -depth 8 -define png:color-type=2 "$f"; done'
fi

# ---------------------------------------------------------------------------
# Keys / secrets
# ---------------------------------------------------------------------------
# Load Anthropic API key if it exists (for avante.nvim and other AI tools).
# Create this file from .anthropic_key.template in your dotfiles directory.
if [[ -n "$DOTFILES" && -f "$DOTFILES/.anthropic_key" ]]; then
  source "$DOTFILES/.anthropic_key"
fi

export OLLAMA_API_KEY="ollama"

# ---------------------------------------------------------------------------
# Keybindings — vi mode
# ---------------------------------------------------------------------------
bindkey -v
bindkey ^R history-incremental-search-backward
bindkey ^S history-incremental-search-forward

# Vim mode indicators (skip inside Claude Code to keep its prompt clean)
if [[ -z "$CLAUDECODE" && -n "$OMZ_LOADED" ]]; then
  function zle-keymap-select {
    VIM_NORMAL="%{$fg_bold[yellow]%} [NORMAL] %{$reset_color%}"
    VIM_INSERT="%{$fg_bold[green]%} [INSERT] %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
    RPS1="$RPS1 "'${time} %{$fg[magenta]%}$(git_prompt_info)%{$reset_color%}$(git_prompt_status)%{$reset_color%}$(git_prompt_ahead)%{$reset_color%}'
    zle reset-prompt
  }

  function zle-line-init {
    VIM_INSERT="%{$fg_bold[green]%} [INSERT] %{$reset_color%}"
    RPS1="$VIM_INSERT"
    RPS1="$RPS1 "'${time} %{$fg[magenta]%}$(git_prompt_info)%{$reset_color%}$(git_prompt_status)%{$reset_color%}$(git_prompt_ahead)%{$reset_color%}'
    zle reset-prompt
  }

  zle -N zle-keymap-select
  zle -N zle-line-init
fi

# ---------------------------------------------------------------------------
# WSL — bridge to the Windows side
# ---------------------------------------------------------------------------
# The Linux home stays a real Linux home (POSIX perms, fast ext4). Windows files
# are reached through ~/winhome instead of mounting them over ~, which would
# break ssh key perms and slow every tool that walks the tree.
if [[ -n "$IS_WSL" ]]; then
  export WINHOME="/mnt/c/Users/$USER"
  [[ -d "$WINHOME" ]] || export WINHOME="$HOME/winhome"
  # Desktop/Documents are OneDrive-redirected on this machine.
  [[ -d "$WINHOME/OneDrive/Desktop" ]] && export WINDESKTOP="$WINHOME/OneDrive/Desktop"

  alias winhome='cd "$WINHOME"'
  alias desk='cd "${WINDESKTOP:-$WINHOME/Desktop}"'
  # `open .` opens the current directory in Windows Explorer, like macOS `open`.
  alias open='explorer.exe'
fi

# sentry CLI completions
fpath=("$HOME/.local/share/zsh/site-functions" $fpath)

# ---------------------------------------------------------------------------
# Machine-local overrides — not tracked in git, safe for per-machine secrets
# ---------------------------------------------------------------------------
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
