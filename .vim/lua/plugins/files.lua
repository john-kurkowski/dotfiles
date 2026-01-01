return {
  -- Project root detection and `cd`
  {
    "airblade/vim-rooter",
    init = function()
      vim.g.rooter_cd_cmd = 'lcd'
      vim.g.rooter_patterns = {
        '.git',
        'Cargo.toml',
        'Gemfile',
        'Makefile',
        'package.json',
        'pyvenv.cfg',
      }
      vim.g.rooter_silent_chdir = 1
    end,
  },

  -- Set env upon `cd`
  { "ejrichards/mise.nvim" },

  -- Project-local Vim overrides
  { "embear/vim-localvimrc" },

  -- File navigation
  {
    "stevearc/oil.nvim",
    opts = {},
    init = function()
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },
}
