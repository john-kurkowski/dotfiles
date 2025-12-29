require("lint").linters_by_ft = {
  astro = { "biomejs", "eslint", "stylelint" },
  css = { "stylelint", "biomejs" },
  javascript = { "biomejs", "eslint" },
  javascriptreact = { "biomejs", "eslint" },
  python = { "mypy", "ruff" },
  typescript = { "biomejs", "eslint" },
  typescriptreact = { "biomejs", "eslint" },
  vue = { "biomejs", "eslint" },
}

vim.api.nvim_create_autocmd({
  "BufEnter",
  "BufWritePost",
  "TextChanged",
  "TextChangedI",
}, {
  callback = function()
    require("lint").try_lint()
  end,
})
