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

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my.lsp', {}),
        callback = function(args)
          local opts = { buffer = args.buf }

          -- Navigation
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

          -- Documentation
          vim.keymap.set('n', 'gk', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, opts)

          -- Refactoring
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

          -- Diagnostics
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
        end,
      })
    end,
  },
}
