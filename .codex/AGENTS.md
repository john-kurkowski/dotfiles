## Version Control

- Use Jujutsu `jj` instead of `git` when `jj` is enabled for the current repo,
  which is one of the following conditions:
    - The prompt mentions `jj`, `jj` changeids, or `jj` relative commit
      references, such as current working copy `@`, parent `@-`, or grandparent
      `@--`.
    - A `.jj/` folder is present at the root of the repo.
- Most of what you know about Git applies to Jujutsu.

### Commits

- When changing files in the same working directory as the prompter, do not
  commit your work, unless told otherwise.

# Worktrees

You may be asked to work in your own worktree, to not interfere with concurrent
changes in the current directory.

- In `jj`, the worktree concept is called workspaces, initialized and explored
  via `jj workspace`.
- Add your worktree to a system temp folder, such as via `$TMPDIR` (to avoid
  dirtying the user's folders).
- Use the same worktree for the duration of the chat, unless told otherwise.
- In your own worktree, it is safe to commit your work for the prompter to
  review.
- In your summary of your changes, give the command to see your change, print
  e.g. `jj diff -r main@origin..yourchangeidhere`.
    - (Since your commit isn't in the prompter's working directory, it won't be
      as simple for the prompter to review your work, compared to `jj diff`
      without arguments.)
    - If the user _has_ to `cd` to your worktree's temp folder to review your
      changes, say so.
        - For example, if your change requires running commands from the
          directory, or the user must review VCS-ignored files.
