# dotfiles

This is my dotfiles repo. There are many like it, but this one is mine.

It is laid out exactly how it goes in the `$HOME` dir.

## Install

```zsh
git clone --bare https://github.com/john-kurkowski/dotfiles.git $HOME/.dotfiles
alias dotfiles='GIT_DIR=$HOME/.dotfiles/ GIT_WORK_TREE=$HOME git'
dotfiles config --local core.worktree $HOME
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local user.email john.kurkowski@gmail.com
dotfiles checkout

# If not a personal device
git config --global user.email john.kurkowski@company.com

# If zsh is not the default shell
chsh -s zsh
```

### Update

```zsh
dotfiles pull
```

### Usage

The dotfiles are now in your home folder, in the conventional location. Your
tools automatically pick them up.

### Contribute

To interact with version control, instead of using `git` directly, use the
alias `dotfiles-env git`, or `dotfiles` for short. For example, `dotfiles add
-p`, `dotfiles commit -v`.

Why the alias? While there are [a lot][GitHub does dotfiles] of bespoke tools
to version control and ship your dotfiles to your `$HOME` dir, you probably
already use Git. With a bare Git repo and an alias, [Git can manage your
dotfiles' lifecycle for you][The best way to store your dotfiles]. Same
interface as `git`. No extra, bespoke tool. The repo layout stays in sync with
how the files are used.

## What's Inside

My development workhorses are the terminal and Vim. They make up the majority
of the custom code in this repo. Their entry points are `.zshrc` and `.vimrc`,
respectively.

These tools are what I'm productive with. Use whatever IDE makes you
productive. Keep investing in and sharpening your tools to shorten the feedback
loop. The quicker it is to try an idea or to cross reference it, the quicker it
is to improve upon or discard.<sup>[1](#1)</sup>

This is at the risk of making the configs idiosyncratic, so they're high cost
to the author and they don't benefit others. It's a balance. When building a
custom prompt, it can be full of inscrutable symbols and directives. When you
see this, **outsource to plugins**. Then the majority of the custom code
becomes listing plugins and configuring them. I strive to show this in this
repo. Plugins do the thing 90% as good as the best dotfile hacker, with little
code to maintain. Hitch your wagon to the community. Functionality is an asset.
Code is a liability.

The other files here configure miscellaneous tools, which come up for schleps
and experiments with little convention.<sup>[2](#2)</sup> They should be the
exception rather than the rule. Prune your unused dotfiles and plugins
aggressively.

## Footnotes

<a name="1">1.</a> While programming, keep in mind, programming doesn't have to
be _this_ way. It can be better. See [Inventing on Principle].

<a name="2">2.</a> Their configuration should be explicit _in the projects that
use them_. This enforces consistency across collaborators. It reduces project
holy wars. Copy a dotfile like [`.editorconfig`][EditorConfig] into the root of
your project, so all collaborators can agree on e.g. spaces vs. tabs, and
trailing whitespace. Or [`.eslintrc.js`][ESLint] to enforce the best parts of
JavaScript, [`pylintrc`][Pylint] for Python, etc. Use CI to enforce the
dotfiles.

[EditorConfig]: https://editorconfig.org/
[ESLint]: https://eslint.org/
[GitHub does dotfiles]: https://dotfiles.github.io/
[Inventing on Principle]: https://vimeo.com/36579366
[Pylint]: https://www.pylint.org/
[The best way to store your dotfiles]: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
