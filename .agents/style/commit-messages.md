# Commit Message Style

- Use a concise, imperative subject that describes the change.
- Add a body only when the subject and diff do not explain why the change was
  needed or a reviewer-relevant scope boundary or tradeoff. Usually one short
  paragraph or 1–3 bullets is enough.
- Use narrative prose for rationale; use imperative bullets for distinct changes
  worth naming, with a sub-bullet for an unusual reason. Omit obvious diff details
  and routine test/snapshot updates unless testing is the primary deliverable.
- Keep durable knowledge needed to maintain a local implementation near the
  code. Do not copy review discussion, temporary project status, planned later
  work, or WIP history into the message.

## Examples

A self-explanatory subject needs no body:

> Fix missing property in CLI `--json` output

Add a short body when the motivation is external to the diff:

> Prefer `brew shellenv` to manual paths
>
> Fixes Homebrew shell completion paths missing on Apple Silicon. Continues to
> prioritize host-specific and tool-specific binaries.

## Pull Requests

Use this style as a starting point for PR titles and descriptions, then adapt to
repository templates and reviewer needs.

Adapted in part from [How to Write a Git Commit Message](https://cbea.ms/git-commit/).
