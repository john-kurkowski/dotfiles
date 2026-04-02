# Commit Message Style

This style is adapted in part from https://cbea.ms/git-commit/, with
repo-specific preferences described below.

## Body structure

- Use the body to explain what changed and why. Minimize the how.
- List _what_ changed with imperative bullets and sub-bullets, similar to the
  subject line.
- If a change seems out of the ordinary relative to the rest of the commit, add
  a sub-bullet explaining _why_ it was done.
- If test case or test snapshot changes only cover the application changes in
  the same commit, no need to enumerate them.
- Bigger picture narrative about the _why_ can be in a non-bulleted paragraph at
  the beginning and/or end of the body.
- If any part of the diff is self-descriptive, no need for narrative and/or
  enumeration for that part of the commit.
- If the whole diff is self-descriptive, no need for a body at all.

## Examples

Example, with narrative about _why_:

> Prefer `brew shellenv` to manual paths
>
> Fixes Homebrew shell completion paths missing on Apple Silicon. Future proofs
> with Homebrew and Apple standard paths. Continues to prioritize host-specific
> and tool-specific binaries.

Example, with bullets about _what_ and sub-bullets about _why_:

> Externalize machine-local config to env vars
>
> - Require setting committer email via env var
> - Allow setting Neovim terminal theme via env var
> - Document mise as a prerequisite of setting up this repo
>     - While mise is not technically necessary to use these dotfiles (you could
>       just `export` environment variables), I've tested mise for a long time
>       and it's become a fire-and-forget part of my workflow
