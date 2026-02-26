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
- When writing a commit message, use the following style (adapted from
  https://cbea.ms/git-commit/):
    - Separate subject from body with a blank line.
    - Capitalize the first letter of the subject line.
    - Do not end the subject line with a period.
    - Use the imperative mood in the subject line.
    - Use the body to explain what and why. Minimize the how (that's more what
      the diff is for).
        - List _what_ changed with imperative bullets and sub-bullets (similar
          to the subject line).
        - If a change seems out of the ordinary of the rest of the commit, add a
          sub-bullet explaining _why_ it was done.
        - If test case or test snapshot changes only cover the application
          changes in the same commit, no need to enumerate them.
        - Bigger picture narrative about the _why_ of the change can be in a
          non-bulleted paragraph at the beginning and/or end of the body.
        - If any part of the diff is self-descriptive, no need for narrative
          and/or enumeration as bullets in the body. If the whole diff is
          self-descriptive, no need for a body at all.
    - Example, with narrative about _why_:
        > Prefer `brew shellenv` to manual paths
        >
        > Fixes Homebrew shell completion paths missing on Apple Silicon. Future
        > proofs with Homebrew and Apple standard paths. Continues to prioritize
        > host-specific and tool-specific binaries.
    - Example, with bullets about _what_ and sub-bullets about _why_:
        > Externalize machine-local config to env vars
        >
        > - Require setting committer email via env var
        > - Allow setting Neovim terminal theme via env var
        > - Document mise as a prerequisite of setting up this repo
        >     - While mise is not technically necessary to use these dotfiles
        >       (you could just `export` environment variables), I've tested
        >       mise for a long time and it's become a fire-and-forget part of
        >       my workflow
- Do not squash your work, unless told otherwise.
    - (This lets the reviewer see what you did at each turn.)
- Repo-specific format
    - Your prompt may include a ticket/issue number. Include the reference in
      any commit(s) you make in the style of other recent commits in the repo.

# Worktrees

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
