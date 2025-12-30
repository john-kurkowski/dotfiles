alias dotfiles-env='GIT_DIR="$HOME"/.dotfiles/ GIT_WORK_TREE="$HOME"'
alias dotfiles='dotfiles-env git'

# Grep dotfiles, using Ripgrep.
#
# Excludes symlinks (Git mode 120000), which could clutter search with files
# outside of dotfiles. Passes the filename list, which could be long, to as few
# instances of Ripgrep as possible (xargs mode), preserving colorized output
# (TTY mode).
alias dotfiles-rg=$'dotfiles ls-files --stage "$HOME" | rg --invert-match \'^120000\' | cut -f 2 | parallel --tty --xargs rg'

alias fd='fd --follow --hidden --exclude ".git"'

alias ga='git add'
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcn!='git commit -v --no-edit --amend'
alias gco='git checkout'
alias gd='git diff'
alias gds='git -c delta.features=side-by-side diff'
alias gf='git fetch --all --tags'
alias gfp='git merge-base --fork-point origin/master'
alias gp='git push'
alias grb='git rebase'
alias gsh='git show'
alias gst='git status'
alias gup='git pull'
alias gupp=$'git fetch --all --prune --tags && git rebase @{u} && git branch -vv | awk \'/: gone]/{print $1}\' | xargs git branch --delete --force'

alias jjb='jj bookmark'
alias jjbc='jj bookmark create'
alias jjbl='jj bookmark list'
alias jjbs='jj bookmark set'
alias jjbt='jj bookmark track'
alias jjc='jj commit'
alias jjcm='jj commit --message'
alias jjd='jj diff'
alias jjdm='jj desc --message'
alias jjds='jj desc'
alias jje='jj edit'
alias jjf='jj git fetch'
alias jjl='jj log'
alias jjla='jj log -r "all()"'
alias jjn='jj new'
alias jjnt='jj new "trunk()"'
alias jjrb='jj rebase'
alias jjrbm='jj rebase -d "trunk()"'
alias jjsh='jj show'
alias jjsp='jj split'
alias jjsq='jj squash'
alias jjst='jj status'

alias llnl='ll node_modules | rg " -> "'

alias pd="afplay /System/Library/Sounds/Glass.aiff && terminal-notifier -title 'Process Completed' -message 'Get back to work.'"

alias rsync=$'rsync --cvs-exclude --filter=\':- ~/.gitignore\''

export FZF_DEFAULT_COMMAND='rg --files --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export RIPGREP_CONFIG_PATH="$HOME/.rgrc"

# Support zoxide in Vim command mode, which isn't an interactive shell by
# default. It's okay if `zoxide` isn't found. Outside of Vim, starting a new
# shell, it may not be on the PATH yet.
if [ "$(command -v zoxide)" ]; then
  eval "$(zoxide init zsh)"
fi
