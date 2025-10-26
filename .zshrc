export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
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

alias c='cursor'
alias n='nvim'

# Shopify Hydrogen alias to local projects
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'

BINGO_DIR="~/Developer/okay/bingo"
alias bn="bash ~/Developer/okay/bingo/scripts/dev.sh"
alias bnn="bn --no-compile"
alias br="bash $BINGO_DIR/script/build-release-macos.sh"
alias clod="claude"

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

