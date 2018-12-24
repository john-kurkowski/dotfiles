# Keybindings

fish_vi_key_bindings
fzf_key_bindings

# Theme

set --export theme_color_scheme dracula
set --export theme_display_cmd_duration no
set --export theme_display_date no
set --export theme_show_exit_status yes
set --export theme_title_display_process yes

# Interactive-only aliases (see more in aliases.fish)

alias exa='exa -g --git'
alias ll='exa -l'
alias ls='exa'

# Local-only environment

# Host-specific scripts and aliases
. ~/.hostspecific
# Source environment variables from a dotenv file
if test -s "$HOME"/.env
  posix-source "$HOME"/.env
end

# Enable various version managers

if test -s "$HOME/.gvm/scripts/gvm"
  . "$HOME/.gvm/scripts/gvm"
end
if which pyenv > /dev/null
  . (pyenv init - | psub)
end
if which pyenv-virtualenv-init > /dev/null
  . (pyenv virtualenv-init - | psub)
end

# Enable iTerm shell integration

if test -e "$HOME"/.iterm2_shell_integration.(basename $SHELL)
  . "$HOME"/.iterm2_shell_integration.(basename $SHELL)
end
set --export VIRTUAL_ENV_DISABLE_PROMPT 1
