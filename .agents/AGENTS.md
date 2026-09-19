## Testing instructions

- For application features and fixes, add or update tests for changed observable
  behavior or durable contracts. If the available tests cannot observe the
  change, use proportionate manual QA and report the remaining gap.
- Use fixed expected values or independently constructed expectations; do not
  rerun the implementation to calculate its own expected result.
- Cover enduring behavior, boundaries, and regressions. Avoid assertions that
  merely record internal scaffolding, migration progress, or review context.
- Keep independent behaviors in separate cases. Test third-party behavior only
  where the application customizes it or deliberately exposes it as a contract.

## Code Comments

- Explain non-obvious contracts, constraints, or tradeoffs a future maintainer
  needs. Lead explanatory comments and JSDoc with what the code does or
  represents, then the durable context.
- Put change history and review rationale in commits or PR descriptions. Mention
  tickets only for durable TODOs or when no clearer explanation exists.
- Before finalizing a branch or PR, re-review changed docs and comments; remove
  explanations that only justified an intermediate implementation or discussion.

## Restricted execution and CLI access

- Sandbox authentication or connectivity failures do not establish that the
  user's host session is broken. Before asking for login, changing access
  methods, or abandoning the task, use a non-secret diagnostic with the host
  access needed to distinguish an environment restriction from an account or
  service failure. Do not print tokens or start a new login flow as a
  diagnostic.
- When session evidence or documented environment restrictions establish that an
  operation requires access unavailable in the current sandbox, request the
  necessary command-specific access on the first attempt. Do not deliberately
  repeat a known access failure. Before retrying a mutation, inspect whether it
  took effect or use an idempotent retry.
- Use the host's permission controls and narrowest command-specific scope.
  Request expanded access only when the operation needs resources outside the
  permitted paths or capabilities. Never broaden sandbox settings or change
  credential storage as a workaround. Execution access does not authorize
  additional actions; report denied or unavailable access accurately.
- For CLI access failures or VCS metadata permission details, read
  [CLI troubleshooting](~/.agents/references/cli-troubleshooting.md).
- `gh auth status` is an approved read-only diagnostic. For REST reads through
  `gh api`, pass `--method GET`. Classify GraphQL queries and mutations by their
  contents; a transport method alone does not establish whether they write.

## External services and computer use

- Prefer the narrowest suitable access method for external services:
    1. A connected, app-specific integration or MCP tool.
    2. An authenticated CLI or API already available in the environment.
    3. A browser automation surface owned by the agent.
    4. Computer Use against the user's live desktop, only when the preceding
       options are unavailable or cannot complete the task.
- Do not use Computer Use merely because a browser link is supplied. First check
  whether a relevant integration or CLI can read or act on the service.
- When falling back, use the least invasive option that can complete the task.
  State a concrete blocker only if a preferred option is unavailable or
  insufficient.
- Distinguish agent-owned browser automation from Computer Use. A visible
  browser controlled through the native desktop is Computer Use. For rendered
  web-app QA and screenshots, prefer a hidden or headless browser context with
  an explicit viewport and direct artifact output. Use native desktop control
  only when the required interaction cannot be completed through an integration,
  CLI/API, or agent-owned browser automation.

## Agent-owned local processes

- The agent owns the lifecycle of every development server, watcher, or other
  long-running local process it starts. Unless the user explicitly asks to leave
  it running, stop it and verify its listener is closed before finishing. Never
  stop a process the agent did not start without explicit approval.

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
- Commands that update repository state need write access to the files that
  store it. Even `jj` inspection commands can write there by snapshotting the
  working copy. Before running any `jj` command in a sandbox, check whether
  those files are within the allowed write paths. If they aren't, request access
  for that command on the first attempt; don't wait for it to fail. Existing
  write permission is enough; no extra approval is needed. See
  [CLI troubleshooting](~/.agents/references/cli-troubleshooting.md) for
  details.

### Before and after comparison

- In a clean default workspace, prefer sequential comparison in that workspace
  when it will not disrupt the user's work. Record its starting revision and
  branch/bookmark or workspace identity, and restore that exact starting state
  afterward. Do not treat creating a new child of the starting revision as
  restoring the original workspace.
- Reuse a dev server only when dependencies, configuration, and startup state
  are compatible across revisions. Otherwise restart it and update dependencies
  as required, respecting process ownership. Use a separate workspace when
  switching would disturb existing work or simultaneous versions are needed.
- Use a VCS-supported restoration operation within the existing history rules.
  If exact restoration would need otherwise unauthorized history changes, choose
  an isolated workspace instead.

### Commits

- When changing files in the same working directory as the prompter, do not
  commit your work, unless told otherwise.
- Never rewrite version control history unless explicitly asked in the current
  turn. This includes `jj edit`, `jj squash`, `jj absorb`, `jj rebase`,
  `jj describe`, `git commit --amend`, `git rebase`, `git reset --hard`, and
  `git cherry-pick --no-commit` followed by history edits.
- Before creating or updating a commit message, read
  [~/.agents/references/commit-messages.md](~/.agents/references/commit-messages.md).

### Worktrees

- When I ask you to work in your own worktree or `jj` workspace, follow
  [~/.agents/references/worktrees.md](~/.agents/references/worktrees.md).

### Pull Requests (PRs)

- Start PR titles and descriptions from relevant commit messages, then adapt to
  the final scope, repository template, linked issues, and reviewer needs.
  [Commit message style](~/.agents/references/commit-messages.md) also applies
  here.
- Write ticket references and same-repository commit hashes without backticks so
  they autolink; use backticks for commands and code identifiers.
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

- Give each receiving task the objective, essential decisions and context, hard
  constraints, artifact pointers, and observable success criteria. Do not assume
  it shares conversation history, instructions, or the same runtime.
- Keep handoffs concise. Point to repository instructions and relevant files
  rather than copying them; leave routine discovery and implementation choices
  to the receiving agent.
