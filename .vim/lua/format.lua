require('conform').setup({
  formatters_by_ft = {
    astro = { 'biome', 'stylelint', 'prettier' },
    css = { 'stylelint', 'biome', 'prettier' },
    html = { 'prettier' },
    javascript = { 'biome', 'prettier' },
    javascriptreact = { 'biome', 'prettier' },
    json = { 'fixjson', 'biome', 'prettier' },
    markdown = { 'prettier' },
    python = { 'ruff_format' },
    rust = { 'rustfmt' },
    sh = { 'shfmt' },
    svelte = { 'biome', 'prettier' },
    typescript = { 'biome', 'prettier' },
    typescriptreact = { 'biome', 'prettier' },
    vue = { 'biome', 'prettier' },
  },

  -- Format on save
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

-- Manual format keymap
vim.keymap.set({ 'n', 'v' }, '<leader>fo', function()
  require('conform').format({ async = true, lsp_fallback = true })
end, { desc = 'Format buffer' })
