# Enable tmux plugins

if [[ ! -d ~/.tmux/plugins/tpm ]]; then;
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

BREW_PREFIX=$(brew --prefix)

# Enable Antigen for shell helpers and theme

source $BREW_PREFIX/share/antigen/antigen.zsh
antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
  bower
  ember-cli
  fasd
  git
  heroku
  nvm
  osx
  pip
  rsync
  vi-mode
  zsh-users/zsh-syntax-highlighting
  # zsh-syntax-highlighting must come before history-substring-search, according to its README
  history-substring-search
EOBUNDLES

antigen theme robbyrussell

antigen apply

# Global, misc. shell settings

setopt extendedglob
setopt HIST_IGNORE_ALL_DUPS
unsetopt share_history

export PATH=~/.bin:/usr/local/bin:/usr/bin:/bin:/opt/X11/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/usr/X11/bin:/Library/TeX/texbin

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

NODE_VERSION='v4.2.6'
export NVM_DIR=~/.nvm
[[ -d $NVM_DIR ]] || mkdir $NVM_DIR
source $BREW_PREFIX/opt/nvm/nvm.sh --no-use
export PATH="${PATH}:${NVM_DIR}/versions/node/${NODE_VERSION}/bin"
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
if which pyenv > /dev/null; then eval "$(pyenv init - --no-rehash)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Enable iTerm shell integration

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
export VIRTUAL_ENV_DISABLE_PROMPT=1
