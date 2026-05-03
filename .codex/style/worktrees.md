# Worktree Style

Use this workflow when asked to work in your own worktree or `jj` workspace, to
isolate your work from concurrent changes in the prompter's directory.

## Setup

- In `jj`, the worktree concept is called workspaces, initialized and explored
  via `jj workspace`.
- Add the worktree to a system temp folder, such as via `$TMPDIR`, to avoid
  dirtying the user's folders.
- Base work on the previous commit, e.g. `jj new @-`, unless told otherwise.
- Use the same worktree for the duration of the chat, unless told otherwise.
- If dependencies are missing in the worktree, run the repo's README setup
  commands from scratch (e.g. `npm install`).
    - Never symlink or otherwise share dependency setup with the prompter's
      worktree.

## Commits

- In your own worktree, commit your work every turn for the prompter to review.
- Do not squash your commits unless explicitly asked in the current turn.
- Use the commit message style from [commit-messages.md](commit-messages.md).

## Turn Summary

- Print exact commands to see the committed changes.
- Prefer exact changeids or changeid ranges instead of relative ranges such as
  `@-` or `main..@-`.
- The first 8 characters of a changeid are fine.
- Comment each command with the commit subject.

```sh
jj diff -r main@origin..changeid3  # Update foo bar in baz

jj diff -r changeid1  # Update foo
jj diff -r changeid2  # Fix bar
```

It should be rare that the prompter has to `cd` into the temp worktree to review
changes. Mention that only when a command must run from the worktree, or when
the prompter must inspect VCS-ignored files.
