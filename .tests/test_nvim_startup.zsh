# Neovim startup with isolated XDG state, sourced by dotfiles-test.

test_nvim_startup() {
  local work_root=$1
  local tmp_root=$2
  local tool_cwd="$tmp_root/tool-cwd"

  mkdir -p \
    "$tmp_root/xdg-cache" \
    "$tmp_root/xdg-config" \
    "$tmp_root/xdg-data" \
    "$tmp_root/xdg-state"

  local nvim_log="$tmp_root/nvim.log"
  if ! (
    cd "$tool_cwd" &&
      env \
        HOME="$work_root" \
        XDG_CACHE_HOME="$tmp_root/xdg-cache" \
        XDG_CONFIG_HOME="$tmp_root/xdg-config" \
        XDG_DATA_HOME="$tmp_root/xdg-data" \
        XDG_STATE_HOME="$tmp_root/xdg-state" \
        nvim --headless "+Lazy! restore" "+qa"
  ) >"$nvim_log" 2>&1; then
    cat "$nvim_log"
    return 1
  fi

}
