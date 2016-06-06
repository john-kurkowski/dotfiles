# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  bower
  brew
  brew-cask
  ember-cli
  fasd
  git
  heroku
  nvm
  osx
  pip
  rsync
  vi-mode
  zsh-syntax-highlighting
  # zsh-syntax-highlighting must come before history-substring-search, according to its README
  history-substring-search
)

source $ZSH/oh-my-zsh.sh

setopt extendedglob
setopt HIST_IGNORE_ALL_DUPS
unsetopt share_history

bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down

export PATH=/usr/local/bin:/usr/bin:/bin:/opt/X11/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/texbin

if [[ `uname` == 'Darwin' ]]; then
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

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias sbtd='SBT_OPTS="$SBT_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005" sbt'
alias sbtj='SBT_OPTS="-noverify -javaagent:/opt/jrebel/jrebel.jar $SBT_OPTS" sbt'
alias sbtdj='SBT_OPTS="-noverify -javaagent:/opt/jrebel/jrebel.jar $SBT_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005" sbt'

alias sniff="sudo ngrep -W byline -d 'en0' -t '^(GET|POST) ' 'tcp and port 80'"

alias cgrep='GREP_COLOR="1;37;41" LANG=C ggrep -PIn --color=always --exclude-dir=.git --exclude-dir=target --exclude=tags --exclude="*TEST*" --exclude="*.iml" --exclude="*.ipr" --exclude="*.iws" --exclude-dir=.idea'
alias ag='ag --pager=less'
alias ls='ls -G'
alias pd="afplay /System/Library/Sounds/Glass.aiff && terminal-notifier -title 'Process Completed' -message 'Get back to work.'"
alias unsort="perl -MList::Util -e 'print List::Util::shuffle <>'"
function griot() {
  lynx "http://rapgenius.com/search?q=`echo $@ | perl -p -e 's/\s+/+/g'`";
}

source ~/.hostspecific
[[ -s "$HOME/.env" ]] && export $(cat "$HOME/.env" | xargs)

BREW_PREFIX=$(brew --prefix)

ln -sf $BREW_PREFIX/share/git-core/contrib/diff-highlight/diff-highlight $BREW_PREFIX/bin/diff-highlight

function server() {
	local port="${1:-8000}"
	open "http://localhost:${port}/"
	python -m SimpleHTTPServer "$port"
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export NVM_DIR=~/.nvm
[[ -d $NVM_DIR ]] || mkdir $NVM_DIR
source $BREW_PREFIX/opt/nvm/nvm.sh
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
export VIRTUAL_ENV_DISABLE_PROMPT=1
