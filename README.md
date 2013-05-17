# Linux

Well it's not quite a one-liner...

    sudo apt-get install python-pip && sudo pip install argparse              # if Python < 2.7
    git clone https://john.kurkowski@bitbucket.org/john.kurkowski/dotfiles
    dotfiles/setup.py install gravity
    chsh -s zsh

# Mac OS X

Install Homebrew then

    git clone https://john.kurkowski@bitbucket.org/john.kurkowski/dotfiles

    brew tap homebrew/dupes
    brew install parallel
    parallel -j 1 brew install {} < dotfiles/brewlist

    dotfiles/setup.py install gravity
    chsh -s zsh # TODO
