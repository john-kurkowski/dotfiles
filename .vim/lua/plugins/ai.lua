return {
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
