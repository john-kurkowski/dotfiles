return {
  -- Buffer management
  { "Asheq/close-buffers.vim" },

  -- Window management
  {
    "sodapopcan/vim-ifionly",
    init = function()
      vim.keymap.set('n', 'L', ':IfIOnly<CR>', { noremap = true })
    end,
  },

  -- Quickfix enhancements
  {
    "yssl/QFEnter",
    init = function()
      vim.g.qfenter_vopen_map = {'<C-v>'}
      vim.g.qfenter_hopen_map = {'<C-x>'}
      vim.g.qfenter_topen_map = {'<C-t>'}
    end,
  },
}
