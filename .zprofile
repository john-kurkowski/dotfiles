# macOS's /etc/zprofile runs after .zshenv and resets PATH with path_helper.
# Restore Mise's shims for login shells so selected tools still win over the
# system and Homebrew executables.
if command -v mise > /dev/null; then
  eval "$(mise activate zsh --shims)"
fi
