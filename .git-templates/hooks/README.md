# Git Templates: Hooks

This directory contains Git hooks, like `prepare-commit-msg` and `pre-commit`.
When Git's `init.templatedir` config option contains this directory, its hooks
will henceforth install and run in _all_ newly created and newly cloned Git
repos on this system.

To add the hooks to a previously cloned Git repo, in that repo, run `git init`.
This will not overwrite existing hooks with the same name, such as hooks added
by an earlier `git init` or hooks installed by the project itself. Remove the
conflicting hooks first, then run `git init`.
