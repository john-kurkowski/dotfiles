# Antigen plugin options

BREW_PREFIX='/usr/local'

export VOLTA_HOME="$HOME/.volta"

# Enable Antigen for shell helpers and theme

source $BREW_PREFIX/share/antigen/antigen.zsh

antigen bundles <<EOBUNDLES
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
  # zsh-syntax-highlighting must come before history-substring-search, according to its README
  zsh-users/zsh-history-substring-search
EOBUNDLES

eval "$(starship init zsh)"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

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
setopt menu_complete          # save an extra autocomplete Tab key

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# zsh vi mode
bindkey -v

# [v] edit the command line
zle -N edit-command-line
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line

# [Up]/[Down] ([k]/[j] in Vi) _search_ history, not only stepping through it linearly
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# [Shift-Tab] - move through the completion menu backwards
bindkey "${terminfo[kcbt]}" reverse-menu-complete

path=(
  ~/.bin
  $VOLTA_HOME/bin
  /usr/local/bin
  /usr/local/opt/ruby/bin
  /usr/bin
  /bin
  /opt/X11/bin
  /usr/local/sbin
  /usr/sbin
  /sbin
  /usr/X11/bin
  /Library/TeX/texbin
  $HOME/.cargo/bin
)
export PATH=${(j[:])path}

export EDITOR=vim
export HOMEBREW_NO_INSTALL_CLEANUP=true
export LESS=-FRXi

# Interactive shell-only aliases (the rest go in the every-shell-type .zshenv).

alias cat='bat'
alias exa='exa --group --git'
alias ll='exa --long'
alias llt='exa --git-ignore --ignore-glob node_modules --long --tree'
alias ls='exa'

# Local-only environment

# Host-specific scripts and aliases
[[ -s "$HOME/.hostspecific" ]] && source "$HOME/.hostspecific"
# Source environment variables from a dotenv file
[[ -s "$HOME/.env" ]] && export $(cat "$HOME/.env" | xargs)
eval "$(direnv hook zsh)"

# Enable interactive fuzzy completion of any list of strings, like filepaths

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable non/interactive directory jumping by frecency

eval "$(zoxide init zsh)"

# Enable various version managers

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
if which pyenv > /dev/null; then eval "$(pyenv init - --no-rehash)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Enable iTerm shell integration

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
export VIRTUAL_ENV_DISABLE_PROMPT=1
