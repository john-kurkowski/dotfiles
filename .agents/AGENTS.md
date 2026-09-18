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

- Explain non-obvious contracts, constraints, or tradeoffs a future maintainer
  needs. Lead explanatory comments and JSDoc with what the code does or
  represents, then the durable context.
- Put change history and review rationale in commits or PR descriptions.
  Mention tickets only for durable TODOs or when no clearer explanation exists.
- Before finalizing a branch or PR, re-review changed docs and comments; remove
  explanations that only justified an intermediate implementation or discussion.

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

- Start PR titles and descriptions from relevant commit messages, then adapt to
  the final scope, repository template, linked issues, and reviewer needs.
  [Commit message style](~/.agents/style/commit-messages.md) also applies here.
- Write ticket references and same-repository commit hashes without backticks
  so they autolink; use backticks for commands and code identifiers.
- After a commit is pushed or a PR opened, default to new child commits. Rewrite
  that history only with explicit approval in the current turn.
- Push only when explicitly approved in the current turn; use fast-forward
  unless force-push is explicitly authorized. After opening a PR, wait to be
  prompted to push again and report unpushed changes in the turn summary.
- After a PR is opened, every remote write requires explicit approval in the
  current turn. Before executing, show the exact action, text/payload/command,
  and reason. This includes PR updates, comments, reviews, merges, and pushes;
  local edits and tests remain allowed.
- One approval can cover a shown batch of related writes and deterministic
  follow-ups, such as substituting a newly returned PR number into an already
  approved preview URL. Ask again if the action or payload changes materially.
- Immediately before overwriting remote content, fetch its current version and
  preserve concurrent edits. Do not reconstruct it from memory or a stale copy.

## Turn Summary

- When a turn summary refers to a Jujutsu commit, give its **change ID** first,
  followed by its commit **hash**. 8-character abbreviations are sufficient.
  - Use exact change IDs or change ID ranges; never use relative revisions
    such as `@-` or `main..@-`.

## Prompts for Other Chat Threads

- Assume the other chat thread uses the same agent type as you, with access to
  the same user-level instructions, and the same repo-level instructions and
  history. Therefore, no need to repeat that context.
- Keep the prompt concise and discovery-friendly: include the objective,
  essential context, hard constraints, and observable success criteria _unique_
  to the new task. Leave routine investigation, planning, and implementation
  choices to the receiving agent.
- Exception: if the user explicitly identifies a cross-agent task (for example,
  if you're Codex writing a prompt for Claude), provide the fuller,
  self-contained context needed for that agent to do the work well.
