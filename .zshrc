if [[ ! -d ~/.tmux/plugins/tpm ]]; then;
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

BREW_PREFIX=$(brew --prefix)

source $BREW_PREFIX/share/antigen/antigen.zsh
antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
  bower
  brew
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

setopt extendedglob
setopt HIST_IGNORE_ALL_DUPS
unsetopt share_history

export PATH=/usr/local/bin:/usr/bin:/bin:/opt/X11/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/usr/X11/bin:/Library/TeX/texbin


if [[ `uname` == 'Darwin' && -z "$TMUX" ]]; then
  export EDITOR="mvim -f"
else
  export EDITOR=vim
fi

export LESS=-FRXi
export PYTHONSTARTUP=~/.pystartup
export MAVEN_COLOR=true

export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
export SCALA_HOME=/usr/share/java
export SBT_OPTS='-Xmx2048M -XX:MaxPermSize=768m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled'

function griot() {
  lynx "http://rapgenius.com/search?q=`echo $@ | perl -p -e 's/\s+/+/g'`";
}

source ~/.hostspecific
[[ -s "$HOME/.env" ]] && export $(cat "$HOME/.env" | xargs)

ln -sf $BREW_PREFIX/share/git-core/contrib/diff-highlight/diff-highlight $BREW_PREFIX/bin/diff-highlight

function server() {
	local port="${1:-8000}"
	open "http://localhost:${port}/"
	python -m SimpleHTTPServer "$port"
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
NODE_VERSION='v4.2.6'
export NVM_DIR=~/.nvm
[[ -d $NVM_DIR ]] || mkdir $NVM_DIR
source $BREW_PREFIX/opt/nvm/nvm.sh --no-use
export PATH="${PATH}:${NVM_DIR}/versions/node/${NODE_VERSION}/bin"
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
if which pyenv > /dev/null; then eval "$(pyenv init - --no-rehash)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
export VIRTUAL_ENV_DISABLE_PROMPT=1
