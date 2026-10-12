# Zsh startup behavior and isolated command fixtures, sourced by dotfiles-test.

write_executable() {
  local executable_path=$1

  cat >"$executable_path"
  chmod +x "$executable_path"
}

assert_equal() {
  local actual=$1
  local expected=$2
  local label=$3

  if [[ "$actual" == "$expected" ]]; then
    return 0
  fi

  print -u2 "dotfiles-test: $label"
  print -u2 "dotfiles-test: expected: $expected"
  print -u2 "dotfiles-test: actual:   $actual"
  exit 1
}

test_zsh_startup_scope() {
  local tmp_root=$1
  local test_home="${tmp_root:A}/zsh-startup-home"

  mkdir -p \
    "$test_home/.local/bin" \
    "$test_home/.local/share/mise/shims" \
    "$test_home/brew/bin" \
    "$test_home/mise-env/bin" \
    "$tmp_root/zsh-startup-cwd"
  cp .zshenv .zprofile .zshrc "$test_home"/

  write_executable "$test_home/.local/bin/mise" <<'EOF'
#!/bin/sh
printf '%s\n' "mise $*" >>"$DOTFILES_TEST_MISE_LOG"

case "$1:$2:$3" in
  env:-s:zsh)
    printf '%s\n' 'export DOTFILES_TEST_MISE_ENV=loaded'
    printf '%s\n' 'export GIT_AUTHOR_EMAIL=work@example.com'
    printf '%s\n' 'export GIT_COMMITTER_EMAIL=work@example.com'
    printf '%s\n' 'export PATH="$HOME/mise-env/bin:$PATH"'
    if [ -n "${DOTFILES_TEST_MISE_ENV_CWD_LOG:-}" ]; then
      printf '%s\n' "$PWD" >>"$DOTFILES_TEST_MISE_ENV_CWD_LOG"
    fi
    ;;
  activate:zsh:--shims)
    printf '%s\n' 'export DOTFILES_TEST_MISE_SHIMS=loaded'
    printf '%s\n' 'export PATH="$HOME/.local/share/mise/shims:$PATH"'
    ;;
  activate:zsh:)
    printf '%s\n' 'export DOTFILES_TEST_MISE_ACTIVATE=loaded'
    ;;
esac
EOF
  ln -s "$test_home/.local/bin/mise" "$test_home/brew/bin/mise"

  write_executable "$test_home/.local/share/mise/shims/python" <<'EOF'
#!/bin/sh
printf '%s\n' 'Mise shim Python'
EOF

  write_executable "$test_home/mise-env/bin/python" <<'EOF'
#!/bin/sh
printf '%s\n' 'Mise env Python'
EOF

  write_executable "$test_home/.local/bin/brew" <<'EOF'
#!/bin/sh
if [ "$1" = shellenv ]; then
  printf '%s\n' 'export DOTFILES_TEST_BREW=loaded'
fi
EOF

  write_executable "$test_home/.local/bin/starship" <<'EOF'
#!/bin/sh
if [ "$1" = init ]; then
  printf '%s\n' 'export DOTFILES_TEST_ZSHRC=loaded'
fi
EOF

  write_executable "$test_home/.local/bin/zoxide" <<'EOF'
#!/bin/sh
if [ "$1" = init ]; then
  printf '%s\n' ''
fi
EOF

  write_executable "$test_home/.local/bin/sheldon" <<'EOF'
#!/bin/sh
exit 0
EOF

  local identity_output
  identity_output=$(
    env -i HOME="$test_home" PATH="/usr/bin:/bin" ZDOTDIR="$test_home" \
      DOTFILES_TEST_MISE_LOG="$tmp_root/mise-identity.log" \
      DOTFILES_GIT_IDENTITY_LOCK=1 \
      GIT_AUTHOR_EMAIL=john.kurkowski@gmail.com GIT_COMMITTER_EMAIL=john.kurkowski@gmail.com \
      zsh -c 'print -r -- "$GIT_AUTHOR_EMAIL:$GIT_COMMITTER_EMAIL"'
  )
  assert_equal "$identity_output" "john.kurkowski@gmail.com:john.kurkowski@gmail.com" "locked child shells should preserve personal author and committer emails"

  identity_output=$(
    env -i HOME="$test_home" PATH="/usr/bin:/bin" ZDOTDIR="$test_home" \
      DOTFILES_TEST_MISE_LOG="$tmp_root/mise-unlocked-identity.log" \
      GIT_AUTHOR_EMAIL=old@example.com GIT_COMMITTER_EMAIL=old@example.com \
      zsh -c 'print -r -- "$GIT_AUTHOR_EMAIL:$GIT_COMMITTER_EMAIL"'
  )
  assert_equal "$identity_output" "work@example.com:work@example.com" "ordinary shells should load the machine-local identity"

  local noninteractive_log="$tmp_root/mise-noninteractive.log"
  local noninteractive_env_cwd_log="$tmp_root/mise-noninteractive-env-cwd.log"
  local startup_cwd="${tmp_root:A}/zsh-startup-cwd"
  local noninteractive_output
  noninteractive_output=$(
    cd "$startup_cwd" &&
      env -i \
        DOTFILES_TEST_MISE_LOG="$noninteractive_log" \
        DOTFILES_TEST_MISE_ENV_CWD_LOG="$noninteractive_env_cwd_log" \
        HOME="$test_home" \
        PATH="/usr/bin:/bin" \
        ZDOTDIR="$test_home" \
        zsh -c 'print -- "${DOTFILES_TEST_MISE_ENV:-unset}:${DOTFILES_TEST_MISE_SHIMS:-unset}:${DOTFILES_TEST_MISE_ACTIVATE:-unset}:${DOTFILES_TEST_ZSHRC:-unset}"; python; print -- "$PWD"'
  )

  assert_equal "$noninteractive_output" $'loaded:loaded:unset:unset\nMise shim Python\n'"$startup_cwd" "non-interactive zsh should load Mise env and resolve commands through shims"
  assert_equal "$(<"$noninteractive_env_cwd_log")" "$test_home" "non-interactive zsh should evaluate Mise env from home without changing its current directory"
  assert_equal "$(<"$noninteractive_log")" $'mise env -s zsh\nmise activate zsh --shims' "non-interactive zsh should load Mise env before shims"

  local interactive_log="$tmp_root/mise-interactive.log"
  local interactive_output
  interactive_output=$(
    env -i \
      DOTFILES_TEST_MISE_LOG="$interactive_log" \
      HOME="$test_home" \
      PATH="/usr/bin:/bin" \
      TERM_PROGRAM=WarpTerminal \
      ZDOTDIR="$test_home" \
      zsh -ic 'print -- "${DOTFILES_TEST_MISE_ENV:-unset}:${DOTFILES_TEST_MISE_SHIMS:-unset}:${DOTFILES_TEST_MISE_ACTIVATE:-unset}:${DOTFILES_TEST_ZSHRC:-unset}"; python'
  )

  assert_equal "$interactive_output" $'loaded:loaded:loaded:loaded\nMise shim Python' "interactive zsh should retain Mise env and shims before .zshrc activation"
  assert_equal "$(<"$interactive_log")" $'mise env -s zsh\nmise activate zsh --shims\nmise activate zsh' "interactive zsh should add shell hooks after loading Mise env and shims"

  # A real login shell also reads the host's /etc/zprofile. Simulate its PATH
  # reset in an isolated shell, leaving a Homebrew-installed Mise available so
  # this verifies that .zprofile restores shims without host configuration.
  local login_log="$tmp_root/mise-login.log"
  local login_output
  login_output=$(
    env -i \
      DOTFILES_TEST_MISE_LOG="$login_log" \
      HOME="$test_home" \
      PATH="/usr/bin:/bin" \
      ZDOTDIR="$test_home" \
      zsh -dfc '
        source "$ZDOTDIR/.zshenv"
        PATH="$HOME/brew/bin:/usr/bin:/bin"
        export PATH
        source "$ZDOTDIR/.zprofile"
        print -- "${DOTFILES_TEST_MISE_ENV:-unset}:${DOTFILES_TEST_MISE_SHIMS:-unset}:${DOTFILES_TEST_MISE_ACTIVATE:-unset}:${DOTFILES_TEST_ZSHRC:-unset}"
        python
      '
  )

  assert_equal "$login_output" $'loaded:loaded:unset:unset\nMise shim Python' "login zsh should retain Mise env and restore shims without interactive activation"
  assert_equal "$(<"$login_log")" $'mise env -s zsh\nmise activate zsh --shims\nmise activate zsh --shims' "login zsh should restore shims after the system PATH reset"
}
