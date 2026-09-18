# CLI and VCS access troubleshooting

Read when a command fails in a restricted environment or needs VCS metadata
access outside permitted paths. Use the current host's permission mechanism;
unrestricted execution does not need an approval ritual to imitate a sandbox.

## Diagnose access

Sandboxing can block credential stores, CLI state/cache writes, desktop-app
sockets, localhost callback listeners, DNS, HTTPS, or WebSockets. An apparent
missing credential can therefore be an access failure. Use a non-secret status
check with the necessary host access before diagnosing the account. If that
check succeeds, continue the authorized operation with the same required access.

Keep approvals command-specific; do not broadly allow a CLI, shell, or
interpreter. If access is denied or unavailable, report that limit separately
from authentication or service failures. Never print tokens, change credential
storage, or initiate login merely to test sandbox access.

## VCS metadata

`jj` commands can snapshot the working copy, including inspection commands.
When its metadata is outside permitted writable paths, request metadata-write
access on the first attempt. Read-only Git inspection normally needs no write
access. Local semantic writes also need access to their metadata storage:
creating or describing commits, changing the index, moving refs/bookmarks,
creating branches, and rewriting history.

Filesystem permission and semantic authorization are separate. Access to the
metadata does not authorize history rewrites, destructive operations, or pushes.
Use the personal and repository VCS rules to decide which actions are allowed.
