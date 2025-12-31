-- Text, text objects, motion, and yank
return {
  { "AndrewRadev/splitjoin.vim" },
  { "andymass/vim-matchup" },
  { "ap/vim-css-color" },

  -- Enhanced motion
  {
    "justinmk/vim-sneak",
    init = function()
      vim.g['sneak#label'] = 1
    end,
  },

  { "kana/vim-textobj-user" },

  {
    "maxbrunsfeld/vim-yankstack",
    init = function()
      vim.g.yankstack_yank_keys = {'c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y'}
      vim.keymap.set('n', 'p', '<Plug>yankstack_substitute_older_paste')
      vim.keymap.set('n', 'P', '<Plug>yankstack_substitute_newer_paste')
    end,
  },

  { "michaeljsmith/vim-indent-object" },
  { "preservim/vim-textobj-quote" },
  { "tpope/vim-commentary" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "tpope/vim-unimpaired" },
  { "wellle/targets.vim" },
}
