# Project-Local Configuration

## Tool Versions

### JavaScript

✅ **JavaScript project-local tooling should be picked up automatically.**

JavaScript projects already install their tooling locally to the project's
node_modules/. [ALE](https://github.com/dense-analysis/ale) looks up for the
nearest node_modules/ with the relevant tool, e.g. Prettier.

If a project doesn't specify the tool, ALE can fall back to a global install of
the tool. Note the global tool will not necessarily have access to the project's
3rd party dependencies, e.g. for type checking.

### Python

❎ **Python project-local tooling should be picked up automatically,** with
caveats.

Python project dependencies require an extra step, because Python does not
require you to use an isolated environment, and Python projects do not have a
unified install command.

I'm using [mise](https://github.com/jdx/mise) to manage Python versions and
virtualenvs, so while inside the project folder, I can set the virtualenv the
project should use with a `.mise.local.toml` like the following.

```toml
[tools]
python = "3.13"

[env]
_.python.venv = { path = ".venv", create = true }
```

Then `mise trust` the file. Then follow the project's install instructions.

The `.mise.local.toml` above activates the local Python install whenever you're
inside the project folder. When editing project files,
[vim-rooter](https://github.com/airblade/vim-rooter) should automatically `cd`
into the folder, and therefore activate the local Python install and tool
versions, for Vim and ALE.

#### Global tools

Active virtualenvs confound finding a _global_ tool, in addition to local tools;
only 1 virtualenv's installed tools tend to be available at a time.

Say a project chooses not to specify/depend on a tool, but it still helps my
local development. In this case, installing a tool with
[`uv tool install`](https://github.com/astral-sh/uv) makes the tool available on
my `PATH`, while isolating the tool's environment. The tool is not inflicted
upon the project nor the developer's global Python install. I like the following
tools.

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

`pip install` is at the risk of mucking up the project's environment working
with other team members. Be careful when freezing and updating the project's
dependencies.

If you want an easier time, rally for your global tool to be an official, local
dependency of the project.

### Monorepos

❌ **TODO**

## Editor

Individual projects can conflict with my general dotfiles settings. For example,
my Vim autofix settings are liberal. When interacting with legacy projects
without enforced code style, autofix can inflict a ton of noise. My editor ought
to be configured per-project, instead of every project bending to me.

> [!CAUTION]
>
> **TODO:** Replace direnv with mise. The following is outdated.

I'm already using [direnv](https://direnv.net/) dotfiles for per-project
environment variables. With 2 project folder dotfiles, .envrc and .vimrc.local,
I can customize Vim's linters and autofixers when it's editing that project.
This can also apply to an organization of projects checked out in the same
parent folder by placing the 2 dotfiles in the parent folder.

In the following example, the project-local dotfiles disable Prettier for all
files within that project, and uses a different set of Python linters than the
global set in [~/.vimrc](../.vimrc).

```sh
# .envrc
use vim
```

```vim
" .vimrc.local
let b:ale_fix_on_save_ignore = ['prettier']
let b:ale_linters = {
\   'python': ['mypy', 'pylsp']
\}
```
