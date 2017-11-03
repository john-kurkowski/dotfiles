alias dotfiles-env='GIT_DIR="$HOME"/.dotfiles/ GIT_WORK_TREE="$HOME"'
alias dotfiles='dotfiles-env git'

alias ls='ls -G'
alias rg='rg --hidden'
alias rsync=$'rsync --cvs-exclude --filter=\':- ~/.gitignore\''
alias pd="afplay /System/Library/Sounds/Glass.aiff && terminal-notifier -title 'Process Completed' -message 'Get back to work.'"

export FZF_DEFAULT_COMMAND='rg --files --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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
