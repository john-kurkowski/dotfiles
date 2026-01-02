return {
  -- Fuzzy find

  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end,
  },

  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    init = function()
      vim.g.fzf_session_path = "~/.vim/session//"

      -- Custom Rg command with preview
      vim.cmd([[
        command! -bang -nargs=* Rg
          \ call fzf#vim#grep(
          \   'rg --column --line-number --no-heading --color=always ' . <q-args>, 1,
          \   <bang>0 ? fzf#vim#with_preview('up:60%')
          \           : fzf#vim#with_preview('right:50%:hidden', '?'),
          \   <bang>0)

        command! -bang -nargs=? -complete=dir Files
          \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
      ]])

      -- Key mappings
      vim.keymap.set("n", "<Leader>i", ":Sessions<CR>", { silent = true })
      vim.keymap.set("n", "<C-P>", ":Files<CR>", { silent = true })
      vim.keymap.set("n", "<Leader>p", ":Buffers<CR>", { silent = true, noremap = true })
    end,
  },

  -- Search sessions with FZF
  {
    "dominickng/fzf-session.vim",
    dependencies = { "junegunn/fzf.vim" },
  },

  -- Search highlighting improvements

  {
    "inkarkat/vim-SearchHighlighting",
    dependencies = {
      "inkarkat/vim-ingo-library",
    },
  },

  {
    "wincent/loupe",
  },
}
