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
- Split tests when a scenario grows to cover multiple independent behaviors;
  avoid hiding a new feature inside an existing case just to reduce test count.
- Do not test 3rd party library behavior, unless the application customizes it
  or depends on it as a deliberate public contract.

## Code Comments

- Write comments for future maintainers, not for the current review thread.
- Use comments to explain durable local knowledge: contracts, invariants,
  tradeoffs, external API quirks, response-shape normalization, fallback
  ordering, or other details needed to safely edit nearby code.
- Avoid comments that narrate the agent's work, review history, tickets, PRs,
  migrations, or temporary rationale. Put historical context in commit messages
  or PR descriptions instead.
- Before adding a code comment, ask whether it will still help a maintainer six
  months from now without knowing the current discussion. If not, omit it.
- Mention tickets only for durable TODOs, or when no clearer explanation exists.
- Before finalizing a branch or PR, re-review docs and comments changed in the
  current change set. Remove explanations that only justified an intermediate
  API shape, review discussion, or earlier iteration.

## Version Control

- STOP before the first VCS operation of a session, including read-only commands
  and VCS commands buried inside a larger shell pipeline. Silently run
  `ls -d .jj` (or equivalent) first and re-confirm in each session.
    - If `.jj/` exists at the repository root, use `jj` for all VCS operations.
      Neither the presence of `.git/` nor harness-provided Git output
      substitutes for the `.jj/` check.
    - Perform this check without commentary. Do not announce whether `.jj/`
      exists, which VCS you selected, or that you will use `jj` instead of Git.
      Mention VCS selection only when it blocks the task or requires user
      action.
    - A detached-HEAD `git status` is normal and expected inside a
      `jj`-colocated repo — never warn about it or suggest switching branches.
- Treat local VCS metadata writes as sandbox-sensitive.
    - Every `jj` command may update working-copy metadata because each command
      snapshots the working copy. Request sandbox escalation on the first
      attempt for all `jj` commands. Narrow approval rules may automatically
      allow inspection commands; semantic VCS writes remain subject to their
      normal authorization requirements.
    - Read-only Git inspection commands such as `git status`, `git log`,
      `git diff`, and `git show` should run normally first.
    - For local semantic VCS writes, request sandbox escalation on the first
      attempt instead of waiting for a sandbox failure. This applies to
      operations that create, rewrite, move, or describe commits, branches,
      bookmarks, tags, refs, or the index.
        - Examples include `jj new`, `jj squash`, `jj absorb`, `jj desc`,
          `jj rebase`, `jj bookmark`, `git commit`, `git commit --amend`,
          `git rebase`, `git cherry-pick`, `git merge`, `git branch`,
          `git switch -c`, and `git tag`.
        - Use a narrow `prefix_rule` for the specific subcommand when requesting
          approval.
        - Note this does not override the rules elsewhere in these instructions
          requiring explicit user approval before history rewrites, destructive
          operations, pushes, or other remote writes.

### Commits

- When changing files in the same working directory as the prompter, do not
  commit your work, unless told otherwise.
- Never rewrite version control history unless explicitly asked in the current
  turn. This includes `jj edit`, `jj squash`, `jj absorb`, `jj rebase`,
  `jj describe`, `git commit --amend`, `git rebase`, `git reset --hard`, and
  `git cherry-pick --no-commit` followed by history edits.
- Before creating or updating a commit message, read
  [~/.agents/style/commit-messages.md](~/.agents/style/commit-messages.md).

### Worktrees

- When I ask you to work in your own worktree or `jj` workspace, follow
  [~/.agents/style/worktrees.md](~/.agents/style/worktrees.md).

### Pull Requests (PRs)

- Treat commit subjects as the starting point for PR titles, and commit messages
  as the starting point for PR descriptions.
    - If you only have vague commit subjects or bodies,
      [~/.agents/style/commit-messages.md](~/.agents/style/commit-messages.md)
      is also a good primer how to write PR titles and descriptions.
    - Then, expand the PR title/description according to org/repository
      guidelines/templates, linked issues, testing notes, rollout details, or
      reviewer-specific context.
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
    - A single approval may cover a batch of related remote writes when every
      action in the batch is shown up front.
        - If a later command needs information produced by an earlier command,
          describe the deterministic follow-up in the same approval request.
        - For example, after `gh pr create` returns PR number `<N>`, you may
          update the PR body by replacing `<PR_NUMBER>` with `<N>` in a
          previously shown deploy-preview URL, without asking for a second
          approval.
- Before overwriting remote content (PR descriptions, issue comments, etc.),
  always fetch the current version first. Never reconstruct from memory or a
  stale local copy. The user may have edited it concurrently.
