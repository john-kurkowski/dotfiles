# Commit Message Style

## Body structure

- Default to the shortest message that gives the reviewer needed context.
- Use the body to explain what changed and why. Minimize the how.
- Prefer no body if the whole diff is self-descriptive.
- If a body is needed, keep it brief. One short paragraph or 1-3 bullets is
  usually enough.
- List _what_ changed with imperative bullets and sub-bullets, similar to the
  subject line.
- If a change seems out of the ordinary relative to the rest of the commit, add
  a sub-bullet explaining _why_ it was done.
- If test case or test snapshot changes only cover the application changes in
  the same commit, no need to enumerate them.
- Do not mention adding or updating tests when they only cover the same feature
  or bugfix as the rest of the commit.
- If a commit is primarily or entirely about test code, the commit message can
  describe the tests directly.
- Do not pad the body with obvious diff details.
- Do not copy PR descriptions, reviewer discussion, or squash-merge WIP commit
  history into the commit message.
- Bigger picture narrative about the _why_ can be in a non-bulleted paragraph at
  the beginning and/or end of the body.
- If any part of the diff is self-descriptive, no need for narrative and/or
  enumeration for that part of the commit.

## Examples

### Narrative _why_, when the rationale matters

Source:
[dotfiles `ca7b7ca`](https://github.com/john-kurkowski/dotfiles/commit/ca7b7ca13ac0b715e64f508188291a142d37b065)

> Prefer `brew shellenv` to manual paths
>
> Fixes Homebrew shell completion paths missing on Apple Silicon. Future proofs
> with Homebrew and Apple standard paths. Continues to prioritize host-specific
> and tool-specific binaries.

### Bullets for _what_, with a sub-bullet for unusual _why_

Source:
[dotfiles `cc1eff3`](https://github.com/john-kurkowski/dotfiles/commit/cc1eff3276227bdc0d952d81a6ffa20978f0eee9)

> Externalize machine-local config to env vars
>
> - Require setting committer email via env var
> - Allow setting Neovim terminal theme via env var
> - Document mise as a prerequisite of setting up this repo
>     - While mise is not technically necessary to use these dotfiles (you could
>       just `export` environment variables), I've tested mise for a long time
>       and it's become a fire-and-forget part of my workflow

### No body, when the diff is self-descriptive

Source:
[tldextract `a545c67`](https://github.com/john-kurkowski/tldextract/commit/a545c67d87223616fc13e90692886b3ca9af18bb)

> Fix missing property in CLI `--json` output

### One short paragraph, when one sentence clarifies intent

Source:
[music `102f3d6`](https://github.com/john-kurkowski/music/commit/102f3d683ac38cea5792d1f31fc55a84e57fd58c)

> Reorganize README
>
> Hook readers earlier.

### Minimal body, when a tiny bit of context prevents confusion

Source:
[music `406e237`](https://github.com/john-kurkowski/music/commit/406e23758817abc2d9a3545d5e78da182fe8135f)

> Require Python 3.12
>
> - Upgrade from `TypeVar` to type parameter syntax
>
> This project also uses `typing.override`, so 3.12 was technically already
> required.

## Acknowledgments

This style is adapted in part from cbeams's excellent
[How to Write a Git Commit Message](https://cbea.ms/git-commit/). It adds some
personal preferences and acknowledges repo-specific preferences.
