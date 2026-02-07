# Machine-Local Configuration

This document describes machine-specific configuration that should not be
committed to the dotfiles repo.

Use [mise]'s `.mise.local.toml` for these settings. The file is already ignored
system-wide by the dotfiles repo.

Some values vary per machine or employer. Keeping them in tracked files causes
permanent dirty changes, which risk getting merged upstream. Keep tracked
defaults stable, and inject machine-local values via environment variables.

## Commit Identity

Tracked config keeps `user.name`, but not `user.email`. Set in
`.mise.local.toml`:

```toml
# $HOME/.mise.local.toml
[env]
GIT_AUTHOR_EMAIL = "you@company.com"
GIT_COMMITTER_EMAIL = "you@company.com"
JJ_EMAIL = "you@company.com"
```

## Theme

### Neovim Terminal

Neovim defaults to its built-in terminal colors unless `NVIM_TERMINAL_THEME` is
set. See
[~/.vim/lua/plugins/colorscheme.lua](../.vim/lua/plugins/colorscheme.lua) for
supported themes.

Example:

```toml
# $HOME/.mise.local.toml
[env]
NVIM_TERMINAL_THEME = "horizon"
```

This enables terminal ANSI colors in Neovim to match
[Ghostty's theme](../.config/jj/config.toml) `Horizon`, without committing
machine-specific palette decisions.

[mise]: https://github.com/jdx/mise
