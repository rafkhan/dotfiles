export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="wedisagree"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Cool ASCII art from Neovim dashboard
cat << "EOF"
@@@@@@@@@@@@@@@@@@@@@@  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@W  @@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@W+  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  -W@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@;    *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#    ,@@@@@@@@@@@@@@@@@@@
@@@@@@#-..=#@@@@@:     +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*     .@@@@@W=;;-*@@@@@@
@@@@@@@@@#   +@@:        ,:#@@@@@@@@@@@@@+*@@@@@@+#@@@@@@@@@@@@@@@@@@@@@#:.        ;@@#   *@@@@@@@@@
@@@@@@@@@@ +          ,;*@@#@@@@@@@@@@@. -@@@@. :W@@@@@@*=*+@@@@@@@@@@@@#@@@@@#         :,#@@@@@@@@@
@@@@@@@@@=+W             W@@@@@@@@@@@=  =@@@;  @@@@@@@@@@@;   :*@@@@@@=*@@@@@@@@-       W#:@@@@@@@@@
@@@@@@@@@-@;     .@;      ,.@@@@@@@@;   #@W   W@@@#*@@@@@@@#    ;@@@@@ -@@@@@@@@@@:      @-@@@@@@@@@
W@@@@@@@@@@-     W@@@        .W@@@:    :@-     @@W -@@@@@@@*       ;W@ .@@@@@@@@@@@     ;@W@@@@@@@@W
W:.*@@@@@@@     @@@@@##*       -#WW:   +-,     -   ;+@@@@@@        #+@   W*@@@@@@@@@     @@@@@@@#;;#
@@:            .@@@@@=#@=      W@@W    -@@W       **  ;#W@+         @@;     =@@#=@@@-            .@@
@@@@@*          #@@@@=@@     @   -    .@#.     .#@@@@:        #@W    .@+          #W          +@@@@@
@@@@@@@ =@      ,@@@@-#     =@*               @@@@@@@@#               @@W-:               WW @@@@@@@
@@@@@@@;=@W+    +@@@@;-     W@@@W.           @@@@@@@@@@-              :@@@@@W*.         :W@W @@@@@@@
@@@@@@@+=@@W     @@@@      @@@@@@+     +     +@@@@@@@@@#    ;@*        W@@@@@@@*        W@@W:@@@@@@@
@@@@@@@@+@@ ;    =@@W     @@@@@@@*    W#@     -@@@@@@@@.   :@@@ W#+     @@@W@@@@@@-    , @@W*@@@@@@@
@@@@@@@@@@@W     +@@:     @@@@:@@,   ,@@@W*      ;*#=      W@@@ @@@@    ,@W @@@@@@+     #@@@@@@@@@@@
@@@@@@@@@W+,      @*      ;@@@ .+    ;@@@@@#+    @@@@@    @@@@@ @@@@-      .@@@@@@      ,+#@@@@@@@@@
@@@@@@@@@@@+:          =@@#+@@@      #W@@@@@@    -@@@#   ,@@@@@:@@@@=.     @@@@@;      :+@@@@@@@@@@@
@@@@@@@@@@@@@W         @@@@@@@@@.    #:@@@@@@@    @W#-    @@@@@+@@@@*+    @@@@@;      #@@@@@@@@@@@@@
@@@@@@@@@@@@@@@        @@@@@@@@@@,    =@@@@@@@     #*     #@@@@@@@@@#    =@@@@,      @@@@@@@@@@@@@@@
@@@@@@@@@@@@@@*        W@@@@@@@@@@#    +@@@@@@.   @@@@*   #@@@@@@@@@    W@@@@        +@@@@@@@@@@@@@@
@@@@@@@@@@@@@@=-@@      @@@@@@@@@@@@W;   :W@@@   W@@@@@@:  @@@@@@W;  ,+@@@@@      @@+-@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@W;#-;   =W@@@@@@@@@@W@@*=W@W  @@@@@@@@@@..+W@@@*W@@@@@W=   .-+=+@@@@@@@@@@@@@@@@@@
EOF

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
alias bn="bash ~/Developer/okay/bingo/scripts/dev.sh"
alias bnn="bn --no-compile"
alias br="bash $BINGO_DIR/script/build-release-macos.sh"

alias claude="/Users/raf/.claude/local/claude"
alias clod="claude"
alias c='claude'

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
alias ok='~/Developer/okay'

bindkey -v
bindkey ^R history-incremental-search-backward
bindkey ^S history-incremental-search-forward

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

alias nconf="cd ~/.config/nvim"

alias gll="git log --all --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

