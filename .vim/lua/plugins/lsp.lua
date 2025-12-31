return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.diagnostic.config({ virtual_lines = { current_line = true }, })

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
