# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(brew git gnu-utils heroku mvn osx pip python)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

setopt extendedglob

set -o vi

#source ~/.bashcolors

export HISTCONTROL=ignoredups
export PATH=/usr/local/share/python:/usr/local/bin:/usr/local/Cellar/ruby/1.9.3-p125/bin:/usr/bin:/bin:/opt/X11/bin:/opt/local/apache2/bin/:/usr/local/sbin:/usr/local/bin:/opt/local/bin/:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/lib/node_modules/.bin:/usr/local/share/npm/bin
export NODE_PATH=/usr/local/lib/node_modules
export EDITOR=vim
export SVN_EDITOR=vim
export WORKON_HOME=~/Documents/python-environments/
export PYTHONSTARTUP=~/.pystartup
export MAVEN_COLOR=true

export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
export SCALA_HOME=/usr/share/java
#export SBT_OPTS='-noverify -javaagent:/opt/jrebel/jrebel.jar -Xms512M -Xmx2536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005'
export SBT_OPTS='-Xms512M -Xmx2536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M'

alias sbtd='SBT_OPTS="$SBT_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005" sbt'
alias sbtdj='SBT_OPTS="-noverify -javaagent:/opt/jrebel/jrebel.jar $SBT_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005" sbt'

VENVWRAPPER=/usr/local/Cellar/python/2.7/bin/virtualenvwrapper.sh
if [ -e $VENVWRAPPER ]
then
  source $VENVWRAPPER
fi

alias grep='GREP_COLOR="1;37;41" LANG=C grep -PIn --color=auto --exclude-dir=.git --exclude-dir=target --exclude=tags --exclude="*TEST*" --exclude="*.iml" --exclude="*.ipr" --exclude="*.iws"'
alias ls='ls -G'
alias pd="afplay /System/Library/Sounds/Glass.aiff && growlnotify -t 'Process Completed' -m 'Get back to work.'"
alias rsyncgi="rsync -avz --exclude '.git' `git clean -dXn | perl -p -e 's/Would remove (.*)/--exclude "$1"/g' | tr \"\\n\" \" \"`"
alias unsort="perl -MList::Util -e 'print List::Util::shuffle <>'"
function griot() {
  lynx "http://rapgenius.com/search?q=`echo $@ | perl -p -e 's/\s+/+/g'`";
}

source ~/.hostspecific

function gup
{
  # subshell for `set -e` and `trap`
  (
    set -e # fail immediately if there's a problem
    # use `git-up` if installed
    if type git-up > /dev/null 2>&1
    then
      exec git-up
    fi
    # fetch upstream changes
    git fetch
    BRANCH=$(git describe --contains --all HEAD)
    if [ -z "$(git config branch.$BRANCH.remote)" -o -z "$(git config branch.$BRANCH.merge)" ]
    then
      echo "\"$BRANCH\" is not a tracking branch." >&2
      exit 1
    fi
    # create a temp file for capturing command output
    TEMPFILE="`mktemp -t gup.XXXXXX`"
    trap '{ rm -f "$TEMPFILE"; }' EXIT
    # if we're behind upstream, we need to update
    if git status | grep "# Your branch" > "$TEMPFILE"
    then
      # extract tracking branch from message
      UPSTREAM=$(cat "$TEMPFILE" | cut -d "'" -f 2)
      if [ -z "$UPSTREAM" ]
      then
        echo Could not detect upstream branch >&2
        exit 1
      fi
      # can we fast-forward?
      CAN_FF=1
      grep -q "can be fast-forwarded" "$TEMPFILE" || CAN_FF=0
      # stash any uncommitted changes
      git stash | tee "$TEMPFILE"
      [ "${PIPESTATUS[0]}" -eq 0 ] || exit 1
      # take note if anything was stashed
      HAVE_STASH=0
      grep -q "No local changes" "$TEMPFILE" || HAVE_STASH=1
      if [ "$CAN_FF" -ne 0 ]
      then
        # if nothing has changed locally, just fast foward.
        git merge --ff "$UPSTREAM"
      else
        # rebase our changes on top of upstream, but keep any merges
        git rebase -p "$UPSTREAM"
      fi
      # restore any stashed changes
      if [ "$HAVE_STASH" -ne 0 ]
      then
        git stash pop
      fi
    fi
  )
}

. `brew --prefix`/etc/profile.d/z.sh
function precmd () {
    z --add "$(pwd -P)"
}

function server() {
	local port="${1:-8000}"
	open "http://localhost:${port}/"
	python -m SimpleHTTPServer "$port"
}
