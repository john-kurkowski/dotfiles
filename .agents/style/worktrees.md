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
- Use the commit message style from
  [~/.agents/style/commit-messages.md](~/.agents/style/commit-messages.md).

## Turn Summary

It should be rare that the prompter has to `cd` into the temp worktree to review
changes. Turn summary-reported change IDs or commit hashes are `diff`-able from
any other directory. Mention `cd` only when a command must run from the
worktree, or when the prompter must inspect VCS-ignored files.

## Git-Dependent Scripts In JJ Workspaces

Some scripts may shell out to `git` even when the active checkout is a
non-colocated jj workspace without a `.git` directory. If a check fails with
`fatal: not a git repository`, do not give up immediately. For read-only scripts
that do not depend on the workspace’s `HEAD` or index, retry with Git pointed at
the original colocated repository and the current jj workspace as the work tree:

```sh
GIT_DIR=/path/to/original/repo/.git \
GIT_WORK_TREE="$PWD" \
<command>
```

If the command runs through a task runner that filters environment variables,
also pass whatever setting is needed for that runner to preserve `GIT_DIR` and
`GIT_WORK_TREE`. Prefer the runner's own environment-variable override when it
has one, so the workaround can live in the command environment instead of every
runner invocation. For example, Turbo projects can use `TURBO_ENV_MODE=loose`.
Other monorepo tooling may have its own workaround when it is sensitive to
environment filtering.

If a tool depends on the workspace’s `HEAD` or index, or may write Git metadata,
use a disposable Git repository in a system temp directory instead of pointing
it at the original checkout. Set its `HEAD` to the workspace commit, initialize
a separate index, preserve the original remote URL, and point its work tree at
the jj workspace. Pass `GIT_DIR`, `GIT_WORK_TREE`, and `GIT_INDEX_FILE` through
the runner as above. Verify that status and the comparison range match the
intended workspace state, then remove the temporary repository when finished.
