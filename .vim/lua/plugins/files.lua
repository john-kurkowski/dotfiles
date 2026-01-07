return {
  -- Project root detection and `cd`
  {
    "airblade/vim-rooter",
    init = function()
      vim.g.rooter_patterns = {
        ".git",
        "Cargo.toml",
        "Gemfile",
        "Makefile",
        "package.json",
        "pyvenv.cfg",
      }
      vim.g.rooter_silent_chdir = 1
    end,
  },

  -- Set env upon `cd`
  {
    "swapnilsm/mise.nvim",
    branch = "configure-scope",
    commit = "47078b0",
    opts = {
      cd_scope = { "global", "window" },
    },
  },

  -- Project-local Vim overrides
  { "embear/vim-localvimrc" },

  -- File navigation
  {
    "stevearc/oil.nvim",
    opts = {
      keymaps = {
        ["<C-h>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<C-l>"] = false,
        ["<C-p>"] = false,
        ["<C-s>"] = false,
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-v>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-x>"] = { "actions.select", opts = { vertical = true } },
      },
      view_options = {
        show_hidden = true,
      },
    },
    init = function()
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },
}
