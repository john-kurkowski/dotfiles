alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias ag='rg'
alias ls='ls -G'
alias rg='rg --hidden'
alias rsync=$'rsync --cvs-exclude --filter=\':- ~/.gitignore\''
alias pd="afplay /System/Library/Sounds/Glass.aiff && terminal-notifier -title 'Process Completed' -message 'Get back to work.'"

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
