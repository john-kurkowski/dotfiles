alias dotfiles-env='env GIT_DIR="$HOME"/.dotfiles/ GIT_WORK_TREE="$HOME"'
alias dotfiles='dotfiles-env git'
alias fd='fd --follow --hidden --exclude ".git"'
alias ga='git add'
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcn!='git commit -v --no-edit --amend'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gfp='git merge-base --fork-point origin/master'
alias gp='git push'
alias grb='git rebase'
alias gsh='git show'
alias gst='git status'
alias gup='git pull'
alias gupp='git pull --prune and git branch -vv | awk \'/: gone]/{print $1}\' | xargs git branch --delete --force'
alias nl='ll node_modules | rg " -> "'
alias pd="afplay /System/Library/Sounds/Glass.aiff and terminal-notifier -title 'Process Completed' -message 'Get back to work.'"
alias rsync='rsync --cvs-exclude --filter=\':- ~/.gitignore\''

set --export FZF_DEFAULT_COMMAND 'rg --files --follow --glob "!.git/*"'
set --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set --export RIPGREP_CONFIG_PATH "$HOME/.rgrc"
