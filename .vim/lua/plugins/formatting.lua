return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        astro = { "biome", "stylelint", "prettier" },
        css = { "stylelint", "biome", "prettier" },
        html = { "prettier" },
        javascript = { "biome", "prettier" },
        javascriptreact = { "biome", "prettier" },
        json = { "fixjson", "biome", "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        svelte = { "biome", "prettier" },
        typescript = { "biome", "prettier" },
        typescriptreact = { "biome", "prettier" },
        vue = { "biome", "prettier" },
      },

      -- Format on save, for most filetypes
      format_on_save = function(bufnr)
        local filetype = vim.bo[bufnr].filetype
        if filetype == "json" or filetype == "markdown" then
          return nil
        end

        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end,
    },

    init = function()
      -- Manual format keymap
      vim.keymap.set({ "n", "v" }, "<leader>fo", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })
    end,
  },
}
