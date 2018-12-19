alias dotfiles-env='GIT_DIR="$HOME"/.dotfiles/ GIT_WORK_TREE="$HOME"'
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
alias gupp=$'git pull --prune && git branch -vv | awk \'/: gone]/{print $1}\' | xargs git branch --delete --force'
alias pd="afplay /System/Library/Sounds/Glass.aiff && terminal-notifier -title 'Process Completed' -message 'Get back to work.'"
alias rsync=$'rsync --cvs-exclude --filter=\':- ~/.gitignore\''

export FZF_DEFAULT_COMMAND='rg --files --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export RIPGREP_CONFIG_PATH="$HOME/.rgrc"

fasd_cache="$HOME/.fasd-init-env"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

 # fco - checkout git branch/tag
 fco() {
   local tags branches target
   tags=$(
     git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
   branches=$(
     git branch --all | grep -v HEAD             |
     sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
     sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
   target=$(
     (echo "$tags"; echo "$branches") |
     fzf-tmux -- --no-hscroll --ansi +m -d "\t" -n 2) || return
   git checkout "$(echo "$target" | awk '{print $2}')"
 }
