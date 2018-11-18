# Antigen plugin options

BREW_PREFIX='/usr/local'

# zsh-nvm options
NODE_VERSION='v6.10.0'
export NVM_DIR=~/.nvm
export NVM_NO_USE=true

# Enable Antigen for shell helpers and theme

source $BREW_PREFIX/share/antigen/antigen.zsh

antigen bundles <<EOBUNDLES
  lukechilds/zsh-nvm
  zsh-users/zsh-syntax-highlighting
  # zsh-syntax-highlighting must come before history-substring-search, according to its README
  zsh-users/zsh-history-substring-search
EOBUNDLES

POWERLEVEL9K_INSTALLATION_PATH=~/.antigen/bundles/bhilburn/powerlevel9k/
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'
POWERLEVEL9K_STATUS_OK=false
antigen theme bhilburn/powerlevel9k powerlevel9k

antigen apply

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

# Global, misc. shell settings

setopt always_to_end
setopt auto_menu              # show completion menu on successive tab press
setopt complete_in_word
setopt extended_history       # record timestamp of command in HISTFILE
setopt extendedglob
setopt globdots
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_all_dups   # ignore duplicate, non-consecutive commands history list
setopt hist_ignore_dups       # ignore duplicate, consecutive commands in history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution

# zsh vi mode
bindkey -v

# allow v to edit the command line
zle -N edit-command-line
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

path=(
  ~/.bin
  ${NVM_DIR}/versions/node/${NODE_VERSION}/bin
  /usr/local/bin
  /usr/bin
  /bin
  /opt/X11/bin
  /usr/local/sbin
  /usr/local/bin
  /usr/sbin
  /sbin
  /usr/X11/bin
  /Library/TeX/texbin
  $HOME/.cargo/bin
)
export PATH=${(j[:])path}

export EDITOR=vim
export LESS=-FRXi
export PYTHONSTARTUP=~/.pystartup

# Interactive shell-only aliases (the rest go in the every-shell-type .zshenv).

alias exa='exa -g --git'
alias ll='exa -l'
alias ls='exa'

# Local-only environment

# Host-specific scripts and aliases
source ~/.hostspecific
# Source environment variables from a dotenv file
[[ -s "$HOME/.env" ]] && export $(cat "$HOME/.env" | xargs)

# Enable fuzzy completion of any list of strings, like filepaths

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable various version managers

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
if which pyenv > /dev/null; then eval "$(pyenv init - --no-rehash)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Enable iTerm shell integration

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
export VIRTUAL_ENV_DISABLE_PROMPT=1
