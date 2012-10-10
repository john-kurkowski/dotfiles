set -o vi

source ~/.bashcolors

export HISTCONTROL=ignoredups
export PATH=/opt/local/apache2/bin/:/usr/local/sbin:/usr/local/Cellar/python/2.7/bin:/usr/local/bin:/opt/local/bin/:$PATH
export SVN_EDITOR=vim
export WORKON_HOME=~/Documents/python-environments/
export PYTHONSTARTUP=~/.pystartup
export MAVEN_COLOR=true

export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
export SCALA_HOME=/usr/share/java

VENVWRAPPER=/usr/local/Cellar/python/2.7/bin/virtualenvwrapper.sh
if [ -e $VENVWRAPPER ]
then
  source $VENVWRAPPER
fi

alias grep='GREP_COLOR="1;37;41" LANG=C grep -EIn --color=auto --exclude-dir=.{svn,git} --exclude-dir=target --exclude=tags --exclude="*TEST*" --exclude=*.{iml,ipr,iws}'
alias ls='ls -G'
alias pd="afplay /System/Library/Sounds/Glass.aiff && growlnotify -t 'Process Completed' -m 'Get back to work.'"
alias unsort="perl -MList::Util -e 'print List::Util::shuffle <>'"

source ~/.hostspecific
