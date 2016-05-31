# dotfiles

## Install

    git clone https://github.com/john-kurkowski/dotfiles.git
    cd dotfiles
    ./setup.py install personal --email john.kurkowski@company.com
    chsh -s zsh

## Export Local Dotfiles

    ./setup.py export

## What's Inside

### Why I Like This Configuration

Programmers are an opinionated bunch. I'm of the opinion to [unify those
opinions](https://xkcd.com/927/). Prompts should look the same. Code should be
formatted the same. Keystrokes should be the same. Sharing configuration gives
us common language and base understanding. We can spend less time on holy wars,
e.g. tabs vs. spaces, and less time adjusting our eyes to someone else's
layout, and more time on bigger problems. Meanwhile, nobody benefits from
fragmentation. Nobody benefits from my idiosyncratic `.zshrc` & `.vimrc` soup.

There is still plenty idiosyncratic soup in this repo, to be cleaned up, but
there are a couple good ideas reflecting my opinion above:

1. Outsource to plugins

    Wherever I can substitute a plugin for maintaining the dotfile behavior
    myself, I go for the plugin.

    I built up a colored, highly custom shell prompt over the course of years.
    The color codes and interpolated variables were inscrutable. Then came
    along an [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh) standard
    plugin, which did the same thing 90% as good and with 0 code on my end.
    Functionality is an asset. Code is a liability. I quickly switched to the
    standard plugin.

    Same story for my old Vim hacks. Why juggle e.g. all of my and teammates'
    spacing, when [vim-sleuth](https://github.com/tpope/vim-sleuth) detects it
    90% of the time?

    I benefit from the plugin's community's bugfixes. I can share my own. If
    another person is using the same prompt, I can quickly identify and follow
    along. All around, I save time.

2. Subtrees > submodules

    What to do about external plugins and scripts that don't have their own
    package manager? Hey, Git is pretty good at versioning.

    Git subtrees store the squashed history of my such dependencies in this
    repo, but without the manual misery of Git submodules. On a new device,
    fetching all my dependencies is 1 `git clone` away. Upgrading & downgrading
    dependencies is a concise, familiar Git experience as well. Forget
    copy/pasting the dependencies' source. Git can keep them in sync. Subtrees
    are also effective for contributing upstream.

    Generally I don't like the noise of external dependencies. I like to keep
    the repo focused on what makes the repo special. But a few vendored
    dependencies here and there are lightweight to manage via Git.

    * (Previously this section boasted about managing Vim plugins via subtrees.
      That can work for a few subtrees, but the history and plugin management
      becomes a real headache when there are a lot of subtrees. `git log
      --graph` this repo to see the mess. Vendored dependencies should be the
      exception, not the standard.)

### Why I Don't Like It

There's still a 100% custom, non-standard bootstrap / installation script in
the form of `setup.py`. It's gross and reinvents the wheel. I'd like to
standardize on [one of these](https://dotfiles.github.io/).
