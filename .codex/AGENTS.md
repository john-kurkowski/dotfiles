## Testing instructions

- While implementing an application code feature or fix, add or update tests to
  cover your changes.
- Tests should verify observable behavior, not re-run the implementation under
  test to compute expected values.
    - Prefer fixed expected literals or independently constructed expectations.
- Keep tests evergreen: they should describe enduring product behavior,
  contracts, invariants, or bug-prevention value for future maintainers.
- Avoid tests that only document implementation scaffolding, rollout steps,
  migration state, or “this change” mechanics.
    - Do not add coverage merely to prove an intermediate internal value exists
      unless that value is part of a stable contract or protects a meaningful
      boundary.
    - Prefer testing the durable observable behavior that depends on the
      implementation detail.
    - If a test would stop being useful once the current review context is
      forgotten, skip it or fold the relevant assertion into a broader
      behavior-focused test.

## Comments

- For any comments you write, including JSDoc or Python docstrings, keep them
  evergreen: write for future maintainers, not for the current review thread.
- Avoid comments that narrate the agent's work, review history, tickets, PRs,
  migrations, or other in-the-moment rationale.
- Put historical context in commit messages or PR descriptions, not source
  comments.
- Mention tickets only for durable TODOs, or when no clearer explanation exists.
- Describe the enduring contract, invariants, responsibilities, and tradeoffs of
  the code.

## Version Control

- For VCS operations in a repo with a `.jj/` directory at the root, silently use
  `jj` commands instead of equivalent `git` commands.

### Commits

- When changing files in the same working directory as the prompter, do not
  commit your work, unless told otherwise.
- Never rewrite version control history unless explicitly asked in the current
  turn. This includes `jj edit`, `jj squash`, `jj absorb`, `jj rebase`,
  `jj describe`, `git commit --amend`, `git rebase`, `git reset --hard`, and
  `git cherry-pick --no-commit` followed by history edits.
- Before creating or updating a commit message, read
  [~/.codex/style/commit-messages.md](~/.codex/style/commit-messages.md).

### Worktrees

- When I ask you to work in your own worktree or `jj` workspace, follow
  [~/.codex/style/worktrees.md](~/.codex/style/worktrees.md).

### Pull Requests

- Treat commit subjects as the starting point for pull request titles, and
  commit messages as the starting point for pull request descriptions. Then
  expand only for org/repository guidelines/templates, linked issues, testing
  notes, rollout details, or reviewer-specific context.
- Default to additive commits.
    - For follow-up work on an existing PR branch/bookmark, create a new child
      commit and push fast-forward only.
    - Do not force-push, unless told otherwise.
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
- Before overwriting remote content (PR descriptions, issue comments, etc.),
  always fetch the current version first. Never reconstruct from memory or a
  stale local copy. The user may have edited it concurrently.
