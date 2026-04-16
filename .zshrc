export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="wedisagree"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/raf/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="/opt/homebrew/opt/jpeg/bin:$PATH"

# bun completions
[ -s "/Users/raf/.bun/_bun" ] && source "/Users/raf/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH=/usr/bin:$PATH

gpc() {
    git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)
}

glc() {
    git pull origin $(git rev-parse --abbrev-ref HEAD)
}

git-clean-branches() {
  git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d
}

alias n='nvim'

# Shopify Hydrogen alias to local projects
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'

BINGO_DIR="~/Developer/okay/bingo"
alias bn="bash $BINGO_DIR/scripts/dev.sh"
alias bnn="bn --no-compile"
alias bnv="bash $BINGO_DIR/scripts/build-vst3-debug.sh && $BINGO_DIR/scripts/install-vst3.sh Debug"

# # Custom Claude Code launcher with sprout emoji
# claude_with_banner() {
#   printf '\033[2J\033[H    🌱'
#   /Users/raf/.local/bin/claude "$@"
# }
#
# alias claude="claude_with_banner"
alias clod="claude"
alias c="claude"
alias cdanger="claude --dangerously-skip-permissions"

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
alias ok='cd ~/Developer/okay'
alias hub='cd ~/Developer/okay/hub'

# Vim mode indicators
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


export PATH="$HOME/.local/bin:$PATH"

# Load Anthropic API key if it exists (for avante.nvim and other AI tools)
# Create this file from .anthropic_key.template in your dotfiles directory
if [ -f "$HOME/Developer/dotfiles/.anthropic_key" ]; then
  source "$HOME/Developer/dotfiles/.anthropic_key"
fi


bindkey -v
bindkey ^R history-incremental-search-backward
bindkey ^S history-incremental-search-forward
alias nconf="cd ~/.config/nvim"
alias gll="git log --all --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias dotf="cd ~/Developer/dotfiles"

export PATH="$HOME/go/bin:$PATH"
# Load GitHub token if it exists

alias fixss='cd ~/Desktop && for f in Screenshot*.png; do magick "$f" -depth 8 -define png:color-type=2 "$f"; done'

# export CLAUDE_CODE_EFFORT_LEVEL=high

alias claude-mem='bun "/Users/raf/.claude/plugins/cache/thedotmack/claude-mem/10.5.5/scripts/worker-service.cjs"'

# opencode
export PATH=/Users/raf/.opencode/bin:$PATH

export OLLAMA_API_KEY="ollama"
