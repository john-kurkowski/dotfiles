return {
  -- LSP completion
  {
    "saghen/blink.cmp",
    -- Pin to latest tagged release, to automatically install optional Rust fuzzy finder.
    version = "*",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    event = "InsertEnter",
    opts = {},
  },
}
