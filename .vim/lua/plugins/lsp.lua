return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.diagnostic.config({ virtual_lines = { current_line = true } })

      local lspconfig = require("lspconfig")

      local function with_root_cmd_cwd()
        return function(new_config, root_dir)
          new_config.cmd_cwd = root_dir
        end
      end

      -- Node/JS/TS
      lspconfig.ts_ls.setup({
        cmd = { "mise", "x", "--", "typescript-language-server", "--stdio" },
        on_new_config = with_root_cmd_cwd(),
      })
      lspconfig.eslint.setup({
        cmd = { "mise", "x", "--", "vscode-eslint-language-server", "--stdio" },
        on_new_config = with_root_cmd_cwd(),
      })
      lspconfig.vue_ls.setup({
        cmd = { "mise", "x", "--", "vue-language-server", "--stdio" },
        on_new_config = with_root_cmd_cwd(),
      })
      lspconfig.astro.setup({
        cmd = { "mise", "x", "--", "astro-ls", "--stdio" },
        on_new_config = with_root_cmd_cwd(),
      })
      lspconfig.biome.setup({
        cmd = { "mise", "x", "--", "biome", "lsp-proxy" },
        on_new_config = with_root_cmd_cwd(),
      })

      -- Python
      lspconfig.pylsp.setup({
        cmd = { "mise", "x", "--", "pylsp" },
        on_new_config = with_root_cmd_cwd(),
      })
      lspconfig.pyright.setup({
        cmd = { "mise", "x", "--", "pyright-langserver", "--stdio" },
        on_new_config = with_root_cmd_cwd(),
      })
      lspconfig.ruff.setup({
        cmd = { "mise", "x", "--", "ruff-lsp" },
        on_new_config = with_root_cmd_cwd(),
      })

      -- Lua
      lspconfig.lua_ls.setup({
        cmd = { "mise", "x", "--", "lua-language-server" },
        on_new_config = with_root_cmd_cwd(),
      })

      -- Keep any others enabled by shorthand
      vim.lsp.enable("ty")
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
