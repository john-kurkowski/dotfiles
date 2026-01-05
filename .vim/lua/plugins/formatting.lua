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

      -- Use project root as cwd for each formatter (mise shims resolve version)
      formatters = (function()
        local function project_root_from_buf(bufnr)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local dir = vim.fs.dirname(fname)
          local root = vim.fs.find(
            { ".mise.toml", ".mise.yaml", "pyproject.toml", "package.json", "Cargo.toml", ".git" },
            { upward = true, path = dir }
          )[1]
          return root and vim.fs.dirname(root) or dir
        end

        local function root_cwd()
          return function(ctx)
            return project_root_from_buf(ctx.buf)
          end
        end

        return {
          biome = { cwd = root_cwd() },
          prettier = { cwd = root_cwd() },
          stylelint = { cwd = root_cwd() },
          fixjson = { cwd = root_cwd() },
          stylua = { cwd = root_cwd() },
          ruff_format = { cwd = root_cwd() },
          rustfmt = { cwd = root_cwd() },
          shfmt = { cwd = root_cwd() },
        }
      end)(),

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
