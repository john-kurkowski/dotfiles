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

Python project dependencies are _not_ conventionally stored within the project.
Since I'm using [pyenv](https://github.com/pyenv/pyenv), while inside the
project folder, I can set the virtualenv the project should use with
`pyenv local <virtualenv-name-here>`. This activates the local Python install
whenever you're inside the project folder. When editing project files,
[vim-rooter](https://github.com/airblade/vim-rooter) should automatically `cd`
into the folder, and therefore activate pyenv's local Python install, for Vim.
Then ALE will use the local tool versions.

If this doesn't work, ALE does have an option to "find up" patterns of
virtualenv directories, in case they are stored near the project. See
`help g:ale_virtualenv_dirnames`. This "find up" is like what ALE does for
node_modules/. So, if the pyenv environment doesn't get picked up in Vim, a
workaround to feed ALE the correct tool versions is to create a symlink to the
virtualenv matching one of ALE's virtualenv directory patterns.

```sh
ln -s ~/.pyenv/versions/virtualenv-name-here /path/to/project/.venv
```

#### Global tools

My default pyenv approach, above, confounds finding a global install of a tool,
in addition to local tools. pyenv tends to make only 1 virtualenv's tools
available at a time. Say a project chooses not to specify/depend on a tool, but
it still helps my local development. In this case, installing a tool with
[pipx](https://github.com/pypa/pipx) makes the tool available on my `PATH`,
while isolating the tool's environment. The tool is not inflicted upon the
project nor the developer's global Python install. I like the following tools.

```sh
brew install pipx
pipx install mypy
pipx install python-lsp-server
pipx install ruff
```

Note however that tools installed via `pipx` will not have access to the
project's 3rd party dependencies, for example `python-lsp-server` analyzing 3rd
party types, because the tool's environment is separate from the project's
environment. It would only have access to first party types and standard library
types. As a last resort, I directly install into the project's virtualenv. For
example:

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
without enforced code style, autofix can inflict a ton of noise.

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
