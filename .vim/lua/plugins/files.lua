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
    config = function(_, opts)
      local author_email = vim.env.GIT_AUTHOR_EMAIL
      local committer_email = vim.env.GIT_COMMITTER_EMAIL
      local lock_identity = vim.env.DOTFILES_GIT_IDENTITY_LOCK == "1"

      require("mise").setup(opts)

      if not lock_identity then
        return
      end

      local function restore_git_identity()
        if author_email and author_email ~= "" then
          vim.env.GIT_AUTHOR_EMAIL = author_email
        end
        if committer_email and committer_email ~= "" then
          vim.env.GIT_COMMITTER_EMAIL = committer_email
        end
      end

      restore_git_identity()
      local group = vim.api.nvim_create_augroup("dotfiles_git_identity_lock", { clear = true })
      vim.api.nvim_create_autocmd("DirChanged", {
        group = group,
        callback = restore_git_identity,
      })
    end,
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
