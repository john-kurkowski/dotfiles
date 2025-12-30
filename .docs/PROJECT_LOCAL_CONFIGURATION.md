# Project-Local Configuration

This document describes how to configure project-local tooling in the following
environments, if any configuration is necessary.

- Vim
- Terminal (e.g. `$PATH`)

Wherever manual configuration is necessary, it is recommended to have [mise]
installed.

## Tool Versions

### JavaScript

JavaScript projects already install their tooling locally to the project's
`node_modules/`. As long as tools or the `$PATH` know to look there first.

- ✅ Vim plugins automatically look up the nearest `node_modules/` with the
  relevant tool, e.g. Prettier. Nothing extra to configure.
- ❎ The terminal can add the `node_modules/.bin` folder to the `$PATH`
  automatically upon `cd`ing into a folder containing a mise `.mise.local.toml`
  like the following.

```toml
# /path/to/cloned/project/.mise.local.toml

[tools]
node = '22'

[env]
_.path = ['{{config_root}}/node_modules/.bin']
```

In the terminal, after `cd`ing into the project folder, calling `prettier` will
refer to the project's installed version of `prettier`.

Without mise, a terminal user can directly call
`node_modules/.bin/name-of-tool`, `npx name-of-tool`, or
`pnpm exec name-of-tool`.

#### Global tools

If a project doesn't specify the tool, linting and formatting "look up" behavior
can fall back to a global install of the tool. Same for the terminal as long as
the global tool is on on `$PATH`. Note the global tool will not necessarily have
access to the project's 3rd party dependencies, e.g. for type checking.

### Python

❎ **Python project-local tooling should be picked up automatically** by Vim and
terminal, similar to JavaScript, _provided manual Python version
configuration/activation with mise_.

Python project dependencies require an extra step, because Python does not
require you to use an isolated environment, and Python projects do not have a
unified install command.

mise serves double duty in these dotfiles, to manage _system_ Python versions
and _local_ virtualenvs.

While inside the project folder, I can set the virtualenv the project should use
with a `.mise.local.toml` like the following.

```toml
# /path/to/cloned/project/.mise.local.toml

[tools]
python = "3.13"

[env]
_.python.venv = { path = ".venv", create = true }
```

Then `cd` into the folder with the `.mise.local.toml`. Then follow the project's
install instructions. It should install into `/path/to/cloned/project/.venv`.

In the terminal, the mise file activates the local Python install whenever
you're inside the project folder. When editing project files, [vim-rooter]
should automatically `cd` Vim into the folder, and therefore activate the local
Python install and tool versions for Vim.

#### Global tools

Active virtualenvs confound finding a _global_ tool, in addition to local tools;
only 1 virtualenv's installed tools tend to be available at a time.

Say a project chooses not to specify/depend on a tool, but it still helps my
local development. In this case, installing a tool with
[`uv tool install`](https://github.com/astral-sh/uv) makes the tool available on
my `PATH`, while isolating the tool's environment. The tool is not inflicted
upon the project nor the developer's global Python install (which could be
further lost by switching global versions).

I personally like the following tools.

```sh
brew install uv  # if not already installed by ~/.config/mise/config.toml

uv tool install mypy
uv tool install python-lsp-server
uv tool install ruff
```

Note however that global, isolated tools installed via `uv tool install` will
not have access to the project's 3rd party dependencies. For example,
`python-lsp-server` won't analyze 3rd party types; it only has access to first
party types and standard library types. As a last resort, I directly install
into the project's virtualenv. For example:

```sh
pip install python-lsp-server
```

This direct install is at the risk of mucking up the project's environment
working with other team members. Be careful when freezing and updating the
project's dependencies. If you want an easier time, rally for your global tool
to be an official, local dependency of the project.

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
