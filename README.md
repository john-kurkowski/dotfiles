# dotfiles

This is my dotfiles repo. There are many like it, but this one is mine.

It is laid out exactly how it goes in the `$HOME` dir.

## Install

```fish
git clone --bare https://github.com/john-kurkowski/dotfiles.git $HOME/.dotfiles
alias dotfiles='GIT_DIR=$HOME/.dotfiles/ GIT_WORK_TREE=$HOME git'
dotfiles config --local core.worktree $HOME
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local user.email john.kurkowski@gmail.com
dotfiles checkout

# If not a personal device
git config --global user.email john.kurkowski@company.com

# Permanently switch shell
chsh -s fish
```

### Update

```fish
dotfiles pull

# If not a personal device
git config --global user.email john.kurkowski@company.com
```

### Usage

The dotfiles are now in your home folder, in the conventional location. Your
tools automatically pick them up.

To interact with the dotfiles' version control, instead of `git`, use
`dotfiles-env git`, or `dotfiles` for short. For example, `dotfiles add -p`,
`dotfiles commit -v`.

Why all the above commands to get this started up? There are [a lot][GitHub
does dotfiles] of custom tools to ship your dotfiles to your `$HOME` dir. Why
not a bespoke tool that would make this a 1-liner? I'd rather use an existing
tool many already understand. You probably already use Git. The repo should be
laid out the way you want. If the storage layout diverges from how it's used,
it's harder to maintain and sync. A bare Git repo and an `alias` later, it
works pretty seamlessly. [Read more about the best way to store dotfiles][The
best way to store your dotfiles].

## What's Inside

My development workhorses are the terminal and Vim. They make up the majority
of the custom code in this repo. Their entry points are
`.config/fish/config.fish` and `.vimrc`, respectively.

My team is IDE-agnostic, so I think it makes sense for the individual to invest
in and sharpen such tools, for their benefit, to shorten the feedback
loop.<sup>[1](#1)</sup>

This is at the risk of making the configs idiosyncratic, so they're high cost
to the author and they don't benefit others. It's a balance. When building a
custom prompt, it can be full of inscrutable symbols and directives. When you
see this, **outsource to plugins**. Then the majority of the custom code
becomes listing plugins and configuring them. You'll see this in the files,
above. Plugins do the thing 90% as good as the best dotfile hacker, with little
code to maintain for the end user. Hitch your wagon to the community.
Functionality is an asset. Code is a liability.

The other files here configure miscellaneous tools, which come up for schleps
and experiments with little convention.<sup>[2](#2)</sup> To fill the gaps,
there are a lot of tools to memorize. They should be the exception rather than
the rule. Prune your unused dotfiles aggressively.

## Footnotes

<a name="1">1.</a> The quicker it is to try an idea or to cross reference it,
the quicker it is to improve upon or discard the idea. While programming,
always keep in the back of your head: programming doesn't have to be _this_
way. It can be better. See [Inventing on Principle].

<a name="2">2.</a> Generally, instead, configuration should be explicit and
fleshed out _in the projects that use them_, for high convention. This enforces
consistency across collaborators. It reduces project holy wars. Copy a dotfile
like [`.editorconfig`][EditorConfig] into the root of your project, so all
collaborators can agree on e.g. spaces vs. tabs, and trailing whitespace. Or
[`.eslintrc.js`][ESLint] to enforce the best parts of JavaScript,
[`pylintrc`][Pylint] for Python, etc. Use CI to enforce the dotfiles.

[EditorConfig]: https://editorconfig.org/
[ESLint]: https://eslint.org/
[GitHub does dotfiles]: https://dotfiles.github.io/
[Inventing on Principle]: https://vimeo.com/36579366
[Pylint]: https://www.pylint.org/
[The best way to store your dotfiles]: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
