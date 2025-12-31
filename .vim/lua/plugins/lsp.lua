return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.lsp.enable('astro')
      vim.lsp.enable('biome')
      vim.lsp.enable('eslint')
      vim.lsp.enable('pylsp')
      vim.lsp.enable('pyright')
      vim.lsp.enable('ruff')
      vim.lsp.enable('ts_ls')
      vim.lsp.enable('vue_ls')
    end,
  },
}
