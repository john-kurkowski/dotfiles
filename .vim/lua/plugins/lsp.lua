return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.diagnostic.config({ virtual_text = true })

      vim.lsp.enable("astro")
      vim.lsp.enable("biome")
      vim.lsp.enable("eslint")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("pylsp")
      vim.lsp.enable("pyright")
      vim.lsp.enable("ruff")
      vim.lsp.enable("ty")
      vim.lsp.enable("vtsls")
      vim.lsp.enable("vue_ls")
    end,

    init = function()
      -- Retrigger LSP attach after session restore.
      --
      -- Neovim's native LSP config attaches on FileType events, but these
      -- don't fire when restoring a session.
      vim.api.nvim_create_autocmd("SessionLoadPost", {
        callback = function()
          vim.cmd("doautocmd FileType")
        end,
      })
    end,
  },
}
