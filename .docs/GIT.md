# Git

## Aliases

I get the most of the following aliases. They are defined in
[.zshenv](../.zshenv). I copied a lot of them from
[Oh My Zsh's Git plugin](https://github.com/ohmyzsh/ohmyzsh/blob/509a5549008c178e982bc8f728a07a2e2dbc58a9/plugins/git/git.plugin.zsh).

<table>
<thead>
<tr>
<th>Alias</th>
<th>Full Command</th>
<th>Description</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>gco [-b] &lt;branch&gt;</code>
</td>
<td>
<code>git checkout [--branch] &lt;branch&gt;</code>
</td>
<td>
Create and switch branches
</td>
<td></td>
</tr>
<tr>
<td>
<code>gsh [&lt;object&gt;]</code>
</td>
<td>
<code>git show [&lt;object&gt;]</code>
</td>
<td>
Show what the latest commit did, or what <code>&lt;object&gt;</code> did
</td>
<td></td>
</tr>
<tr>
<td>
<code>gst</code>
</td>
<td>
<code>git status</code>
</td>
<td>
Get a sense where I'm at
</td>
<td></td>
</tr>
<tr>
<td>
<code>gupp</code>
</td>
<td>
<small>(complex)</small>
</td>
<td>
Get latest
</td>
<td>

-   ⚠️ This is destructive, for a couple reasons.
    1. It defaults to rebasing. I think
       [a clean history is best, but the backspace key does carry risk](https://blog.izs.me/2012/12/git-rebase/).
       To get out of trouble, `git rebase --abort` or `git reflog`.
    1. It cleans up deleted branches, e.g. a merged upstream pull request. A
       clean local repo is best. However, if you have local, unpushed commits on
       that _other_ branch, the command could drop your changes.
-   If you want to be safer, drop down to `git fetch` and `git merge`, which
    will modify only your current branch, and without rewriting history.

</td>
</tr>
</tbody>
</table>

## Commits

I tend to commit from my editor, Vim.
[Fugitive](https://github.com/tpope/vim-fugitive) adds a dedicated Vim window
for selecting files to stage and commit. It is nice to select files visually.
While committing, it is nice to reference the code side by side. It has quick
shortcuts for amending; I often don't get the commit right the first time.

## Additional Commands

<table>
<thead>
<tr>
<th>Command</th>
<th>Install</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>git fixup &lt;object&gt;</code>
</td>
<td>
<code>brew install git-fixup</code>
</td>
<td>

Generate a fixup commit for <code>&lt;object&gt;</code>. Without arguments, find
commits your currently staged changes are likely fixing up. Once committed, the
fixups can be squashed with <code>git rebase --autosquash</code> or <code>git
revise --autosquash</code>.

If you know the unpushed commit to fixup's message, say its first word, you can
quickly target it by that word instead of the commit SHA. If the first word of
the commit was `Rename`, you can `git fixup :/Rename`.

In Vim, Fugitive's status window lists unpushed commits, you can visually target
the commit you want, and there is a mapping to
`git fixup the-commit-under-the-cursor`.

</td>
</tr>
<tr>
<td>
<code>git revise [-i|--autosquash] &lt;target&gt;</code>
</td>
<td>
<code>brew install git-revise</code>
</td>
<td>
Like rebase, but for not changing any code, only changing commit contents and
order, since <code>&lt;target&gt;</code>. Because the code doesn't change, the
command is faster than rebase and it doesn't trigger filesystem changes, e.g.
app rebuilds.
</td>
</tr>
<tr>
<td>
<code>git recent</code>
</td>
<td>
<code>brew install git-recent</code>
</td>
<td>
List recent branches. Answers, "Wait, what was I working on yesterday?" "What
was the branch name again of that PR that finally got reviewed?"
</td>
</tr>
</tbody>
</table>
