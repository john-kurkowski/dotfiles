# Project-Local Configuration

This document describes how to configure project-local tooling for the
following.

- Vim (e.g. inline format and lint)
- Terminal (e.g. `$PATH`)

Most configuration uses [mise] for version and environment management.

## Tool Versions

**General note on global tools**: If a project doesn't specify a tool, Vim and
terminal can fall back to globally installed versions, as long as it's `$PATH`.
However, global tools won't have access to the project's dependencies, which may
limit features like 3rd party type checking.

### JavaScript

JavaScript projects install tooling locally to `node_modules/`.

- **Vim**: Plugins automatically "find up" to tools in the nearest
  `node_modules/`. No configuration needed.
- **Terminal**: Add `node_modules/.bin` to `$PATH` automatically by creating a
  mise `.mise.local.toml` file:

```toml
# /path/to/cloned/project/.mise.local.toml

[tools]
node = '22'

[env]
_.path = ['{{config_root}}/node_modules/.bin']
```

Without mise, a terminal user can directly call
`node_modules/.bin/name-of-tool`, `npx name-of-tool`, or
`pnpm exec name-of-tool`.

### Python

**Python project-local tooling works _almost_ automatically** in Vim and
terminal, similar to JavaScript. The extra step: Python doesn't mandate isolated
environments or provide a unified install command, so you must configure the
Python version and virtualenv with mise.

Set the project's virtualenv by creating a `.mise.local.toml` file:

```toml
# /path/to/cloned/project/.mise.local.toml

[tools]
python = "3.13"

[env]
_.python.venv = { path = ".venv", create = true }
```

Then `cd` into the folder with the `.mise.local.toml` and follow the project's
install instructions. Tools and the virtualenv will activate automatically in
both Vim (via [vim-rooter]) and terminal when inside the project folder.

#### Installing global tools

Only one Python environment's tools are available at a time. To use tools across
projects without conflicting with active virtualenvs, use
[`uv tool install`](https://github.com/astral-sh/uv):

```sh
brew install uv  # if not already installed by ~/.config/mise/config.toml

uv tool install mypy
uv tool install python-lsp-server
uv tool install ruff
```

If you need a tool to access project dependencies, install it directly into the
project's virtualenv. Be aware this risks affecting other team members'
environments:

```sh
pip install python-lsp-server
```

### Monorepos

❌ **TODO**

## Editor

Individual projects can conflict with my general dotfiles settings. For example,
my Vim autofix settings are liberal. When interacting with legacy projects
without enforced code style, autofix can inflict a ton of noise. My editor ought
to be configured per-project, instead of every project bending to me. Enter
[vim-localvimrc][vim-localvimrc] and per-project `.lvimrc` files.

In the following example, the project-local `.lvimrc` disables formatting for
all JavaScript files within that project, and uses a different set of Python
linters than the global set in
[~/.vim/lua/linting.lua](../.vim/lua/linting.lua).

```vim
" /path/to/cloned/project/.lvimrc

lua << EOF
-- Disable Prettier for this project
require('conform').setup({
  formatters_by_ft = {
    javascript = {},  -- empty to disable
  },
})

-- Use specific Python linters for this project
require('lint').linters_by_ft = {
  python = {'pylint'},
}
EOF
```

[mise]: https://github.com/jdx/mise
[vim-localvimrc]: https://github.com/embear/vim-localvimrc
[vim-rooter]: https://github.com/airblade/vim-rooter
