# Dotfiles repository

These instructions apply to work on the dotfiles repository, not unrelated
projects or files elsewhere in the home directory.

The working tree is `$HOME`; the bare Git directory is `~/.dotfiles`. Read
`~/README.md` before repository inspection or edits. Use the documented dotfiles
commands for version control, and limit changes to the task's dotfiles scope.

After changing dotfiles, run `dotfiles-test --here --fix --yes` before finishing
the task and before any authorized commit. Review the resulting changes and
report any remaining failures.
