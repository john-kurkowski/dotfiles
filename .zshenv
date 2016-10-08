alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias sbtd='SBT_OPTS="$SBT_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005" sbt'
alias sbtj='SBT_OPTS="-noverify -javaagent:/opt/jrebel/jrebel.jar $SBT_OPTS" sbt'
alias sbtdj='SBT_OPTS="-noverify -javaagent:/opt/jrebel/jrebel.jar $SBT_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005" sbt'

alias sniff="sudo ngrep -W byline -d 'en0' -t '^(GET|POST) ' 'tcp and port 80'"

alias cgrep='GREP_COLOR="1;37;41" LANG=C ggrep -PIn --color=always --exclude-dir=.git --exclude-dir=target --exclude=tags --exclude="*TEST*" --exclude="*.iml" --exclude="*.ipr" --exclude="*.iws" --exclude-dir=.idea'
alias ag='ag --pager=less'
alias ls='ls -G'
alias rg='rg --hidden'
alias pd="afplay /System/Library/Sounds/Glass.aiff && terminal-notifier -title 'Process Completed' -message 'Get back to work.'"
alias unsort="perl -MList::Util -e 'print List::Util::shuffle <>'"

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
