# Enable tmux plugins

if [[ ! -d ~/.tmux/plugins/tpm ]]; then;
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Antigen plugin options

BREW_PREFIX='/usr/local'

# zsh-nvm options
NODE_VERSION='v6.10.0'
export NVM_DIR=~/.nvm
export NVM_NO_USE=true

# Enable Antigen for shell helpers and theme

source $BREW_PREFIX/share/antigen/antigen.zsh
antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
  fasd
  git
  heroku
  lukechilds/zsh-nvm
  pip
  vi-mode
  zsh-users/zsh-syntax-highlighting
  # zsh-syntax-highlighting must come before history-substring-search, according to its README
  history-substring-search
EOBUNDLES

POWERLEVEL9K_INSTALLATION_PATH=~/.antigen/bundles/bhilburn/powerlevel9k/
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'
POWERLEVEL9K_STATUS_OK=false
antigen theme bhilburn/powerlevel9k powerlevel9k

antigen apply

# Global, misc. shell settings

setopt extendedglob
setopt globdots
setopt HIST_IGNORE_ALL_DUPS
unsetopt share_history

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
