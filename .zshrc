# Enable tmux plugins

if [[ ! -d ~/.tmux/plugins/tpm ]]; then;
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Antigen plugin options

BREW_PREFIX='/usr/local'

# zsh-vnm options
NODE_VERSION='v4.2.6'
export NVM_DIR=~/.nvm
export NVM_NO_USE=true

# Enable Antigen for shell helpers and theme

source $BREW_PREFIX/share/antigen/antigen.zsh
antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
  bower
  ember-cli
  fasd
  git
  heroku
  lukechilds/zsh-nvm
  osx
  pip
  rsync
  vi-mode
  zsh-users/zsh-syntax-highlighting
  # zsh-syntax-highlighting must come before history-substring-search, according to its README
  history-substring-search
EOBUNDLES

POWERLEVEL9K_INSTALLATION_PATH=~/.antigen/bundles/bhilburn/powerlevel9k/
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_with_package_name'
antigen theme bhilburn/powerlevel9k powerlevel9k

antigen apply

# Global, misc. shell settings

setopt extendedglob
setopt HIST_IGNORE_ALL_DUPS
unsetopt share_history

path=(
  ~/.bin
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
  $HOME/.yarn/bin
  ${NVM_DIR}/versions/node/${NODE_VERSION}/bin
)
export PATH=${(j[:])path}

if [[ `uname` == 'Darwin' && -z "$TMUX" ]]; then
  export EDITOR="mvim -f"
else
  export EDITOR=vim
fi

export LESS=-FRXi
export PYTHONSTARTUP=~/.pystartup

# Local-only environment

# Host-specific scripts and aliases
source ~/.hostspecific
# Source environment variables from a dotenv file
[[ -s "$HOME/.env" ]] && export $(cat "$HOME/.env" | xargs)

# Put on PATH scripts that aren't available via a package manager

ln -sf $BREW_PREFIX/share/git-core/contrib/diff-highlight/diff-highlight $BREW_PREFIX/bin/diff-highlight

# Enable fuzzy completion of any list of strings, like filepaths

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable various version managers

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
if which pyenv > /dev/null; then eval "$(pyenv init - --no-rehash)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Enable iTerm shell integration

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
export VIRTUAL_ENV_DISABLE_PROMPT=1
