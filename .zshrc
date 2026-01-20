export EDITOR=nvim

# Global, misc. shell settings

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt always_to_end
setopt auto_menu              # show completion menu on successive tab press
setopt complete_in_word
setopt extended_history       # record timestamp of command in HISTFILE
setopt extendedglob
setopt globdots
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_all_dups   # ignore duplicate, non-consecutive commands history list
setopt hist_ignore_dups       # ignore duplicate, consecutive commands in history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt interactive_comments   # allow comments in interactive shell (common with copy-paste)
setopt menu_complete          # save an extra autocomplete Tab key

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# $PATH

if [ -d /opt/homebrew/bin ]; then
  # Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d /usr/local/bin ]; then
  # Intel
  eval "$(/usr/local/bin/brew shellenv)"
fi
path=(
  ~/.bin
  $HOME/.cargo/bin
  $HOME/.local/bin
  $HOME/brew/bin
  $path
)
export PATH=${(j[:])path}

export HOMEBREW_NO_INSTALL_CLEANUP=true

export LESS="\
--IGNORE-CASE \
--RAW-CONTROL-CHARS \
--no-init \
--quit-if-one-screen \
"

# Load shell helpers

if which sheldon > /dev/null; then eval "$(sheldon source)"; fi

# Prompt

eval "$(starship init zsh)"

# Interactive shell-only aliases (the rest go in the every-shell-type .zshenv).

alias cat='bat --paging=never'
alias eza='eza --group --git'
alias ll='eza --long'
# If this is too noisy, consider running it with eza's `--git-ignore` or
# `--ignore-glob some_noisy_subfolder/` flags.
alias llt='eza --long --tree'
alias ls='eza'

# Local-only environment

# Host-specific scripts and aliases
[[ -s "$HOME/.hostspecific" ]] && source "$HOME/.hostspecific"
# Source environment variables from a dotenv file
[[ -s "$HOME/.env" ]] && export $(cat "$HOME/.env" | xargs)

function zvm_after_init() {
  # zsh-vi-mode

  # Always start in insert mode
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

  # [Up]/[Down] ([k]/[j] in Vi) _search_ history, not only stepping through it linearly
  zvm_bindkey viins '^[[A' history-substring-search-up
  zvm_bindkey viins '^[[B' history-substring-search-down
  zvm_bindkey vicmd '^[[A' history-substring-search-up
  zvm_bindkey vicmd '^[[B' history-substring-search-down
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down

  # [Shift-Tab] - move through the completion menu backwards
  bindkey "${terminfo[kcbt]}" reverse-menu-complete

  # Enable interactive fuzzy completion of any list of strings, like filepaths
  if which fzf > /dev/null; then source <(fzf --zsh); fi
}

# Enable non/interactive directory jumping by frecency

eval "$(zoxide init zsh)"

# Enable various version managers

if which mise > /dev/null; then eval "$(mise activate zsh)"; fi

# Enable iTerm shell integration

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
fi
export VIRTUAL_ENV_DISABLE_PROMPT=1
