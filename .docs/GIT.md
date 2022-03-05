# Git

## Aliases

I get the most of the following aliases. They are defined in
[.zshenv](../.zshenv). I copied a lot of them from [Oh My Zsh's Git
plugin](https://github.com/ohmyzsh/ohmyzsh/blob/509a5549008c178e982bc8f728a07a2e2dbc58a9/plugins/git/git.plugin.zsh).

<table>
<thead>
<tr>
<th>Command</th>
<th>Description</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>

`gco`

</td>
<td>
Create and switch branches
</td>
<td></td>
</tr>
<tr>
<td>

`gsh [<object>]`

</td>
<td>

Show what the latest commit did, or what `<object>` did

</td>
<td></td>
</tr>
<tr>
<td>

`gst`

</td>
<td>
Get a sense where I'm at
</td>
<td></td>
</tr>
<tr>
<td>

`gupp`

</td>
<td>
Get latest
</td>
<td>

-   ⚠️ This is destructive, for a couple reasons.
    1. It defaults to rebasing. I think [a clean history is best, but the
       backspace key does carry
       risk](https://blog.izs.me/2012/12/git-rebase/). To get out of trouble,
       `git rebase --abort` or `git reflog`.
    1. It cleans up deleted branches, e.g. a merged upstream pull request.
       A clean local repo is best. However, if you have local, unpushed
       commits on that _other_ branch, the command could drop your changes.
-   If you want to be safer, drop down to `git fetch` and `git merge`, which
    will only modify your current branch, and without rewriting history.

</td>
</tr>
</tbody>
</table>

## Commits

I tend to commit from my editor, Vim.
[Fugitive](https://github.com/tpope/vim-fugitive) adds a dedicated Vim window
for selecting files to stage and commit. It is nice to select files visually.
While committing, it is nice to reference the code side by side. It has quick
shortcuts for amending.
