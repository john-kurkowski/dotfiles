# Enable shell package manager for tool integrations and themes

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set NODE_VERSION 'v6.10.0'
set NVM_DIR ~/.nvm

# PATH
set --export fish_user_paths \
  ~/.bin \
  "$NVM_DIR"/versions/node/"$NODE_VERSION"/bin \
  /usr/local/bin \
  /usr/bin \
  /bin \
  /opt/X11/bin \
  /usr/local/bin \
  /usr/sbin \
  /sbin \
  /usr/X11/bin \
  /Library/TeX/texbin \
  "$HOME"/.cargo/bin \

set --export EDITOR vim
set --export LESS -FRXi
set --export PYTHONSTARTUP ~/.pystartup

. (dirname (status -f))/aliases.fish

if status --is-interactive
  . (dirname (status -f))/interactive.fish
end
