## Testing instructions

- While implementing an application code feature or fix, add or update tests to
  cover your changes.
- Tests should verify observable behavior, not re-run the implementation under
  test to compute expected values.
    - Prefer fixed expected literals or independently constructed expectations.

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
- When writing a commit message, use the following style:
    - Separate subject from body with a blank line.
    - Capitalize the first letter of the subject line.
    - Do not end the subject line with a period.
    - Use the imperative mood in the subject line.
    - Use the body to explain what and why. Minimize the how (that's more what
      the diff is for).
    - For detailed examples and preferred patterns, see
      `style/commit-messages.md`.
- Do not squash your work, unless told otherwise.
    - I.e. never rewrite version control history. Never `jj squash`,
      `jj absorb`, `jj rebase`, `jj describe`, `git commit --amend`,
      `git rebase`, `git reset --hard`, `git cherry-pick --no-commit` followed
      by history edits, or force-push prep.
    - (This lets the reviewer see what you did at each turn.)
- Repo-specific format
    - Your prompt may include a ticket/issue number. Include the reference in
      any commit(s) you make in the style of other recent commits in the repo.

### Worktrees

You may be asked to work in your own worktree, to isolate your work and not
interfere with concurrent changes in the current directory.

- In `jj`, the worktree concept is called workspaces, initialized and explored
  via `jj workspace`.
- Add your worktree to a system temp folder, such as via `$TMPDIR` (to avoid
  dirtying the user's folders).
- Base your work on the previous commit, e.g. `jj new @-`, unless told
  otherwise.
    - If you base your work on the working copy, i.e. `jj new @`, be careful, as
      `@` might still be in progress, and the worktrees could get out of sync.
- Use the same worktree for the duration of the chat, unless told otherwise.
- If dependencies are missing in the worktree, run the repo's README setup
  commands from scratch (e.g. `npm install`).
    - Never symlink or otherwise share your worktree's setup with the prompter's
      worktree.
- In your own worktree, it is safe to commit, so commit your work every turn for
  the prompter to review.
- In your turn summary, print the command to see your committed changes.
    - Prefer exact changeids or changeid ranges, instead of relative ranges,
      e.g. `trksomvv` or `main..trksomvv`, _not_ `@-` or `main..@-`.
    - The first 8 characters of a changeid are fine, for display brevity.
    - Comment with the commit subject.
    - For example:

        ```sh
        jj diff -r main@origin..changeid3  # Update foo bar in baz`

        # Or, if there are multiple commits to review in this turn:

        jj diff -r changeid1  # Update foo
        jj diff -r changeid2  # Fix bar
        jj diff -r changeid3  # Clean up baz
        ```

    - (Since your commit isn't in the prompter's working directory, it won't be
      as simple for the prompter to review your work, compared to `jj diff`
      without arguments.)
    - It should be very rare that the user _has_ to `cd` to your worktree's temp
      folder to review your changes.
        - For example, if your change requires running commands from the
          directory, or the user must review VCS-ignored files.

### Pull Requests

- Default to additive commits.
    - For follow-up work on an existing PR branch/bookmark, create a new child
      commit and push fast-forward only.
    - Do not rewrite version control history, especially not on an
      already-pushed change. Never `jj squash`, `jj absorb`, `jj rebase`,
      `jj describe`, `git commit --amend`, `git rebase`, `git reset --hard`,
      `git cherry-pick --no-commit` followed by history edits, or force-push
      prep, unless explicitly asked in the current turn.
    - Do not force-push, unless told otherwise.
    - If history rewrite seems beneficial, ask first. Present the exact command
      you would run, then wait for approval.
- After a PR is already opened, avoid pushing on every commit, unless told
  otherwise.
    - Wait to be prompted to push.
    - In your turn summary, mention unpushed changes, if any.
    - (This conserves CI minutes, retriggering AI code review, and sending
      emails to human subscribers.)
- After a PR is already opened, do not perform any remote write action without
  my explicit approval in the current turn.
    - Remote write actions include:
        - GitHub writes (`update_pull_request`, `add_*comment*`, review
          submission, merge, etc.)
        - VCS pushes (`git push`, `jj git push`)
        - Commenting on the PR
    - Before any remote write, show me:
        1. The exact action
        2. The exact text/payload/command
        3. A short reason
    - Wait for my explicit approve before executing.
    - Default behavior: local edits/tests are allowed; remote writes are not.
