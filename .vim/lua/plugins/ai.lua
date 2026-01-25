return {
  -- AI code completion
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    init = function()
      vim.g.codeium_no_map_tab = 1
      vim.keymap.set("i", "<M-Tab>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
    end,
  },

  -- AI code chat
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "j-hui/fidget.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionActions",
    },
    config = {
      interactions = {
        background = {
          adapter = "codex",
        },
        chat = {
          adapter = "codex",
        },
        cmd = {
          adapter = "codex",
        },
        inline = {
          adapter = "codex",
        },
      },
    },
    init = function()
      require("plugins.ai.loading"):init()
    end,
  },
}
