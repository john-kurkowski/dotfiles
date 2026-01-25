return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        astro = { "biomejs", "stylelint" },
        css = { "stylelint", "biomejs" },
        javascript = { "biomejs" },
        javascriptreact = { "biomejs" },
        lua = { "luacheck" },
        python = { "mypy" },
        typescript = { "biomejs" },
        typescriptreact = { "biomejs" },
        vue = { "biomejs" },
      }

      -- Compute linter command.
      --
      -- Some linters compute their command per-buffer (e.g. picking a
      -- project-local virtualenv or tool) Guard with pcall to keep
      -- env-not-ready errors from breaking autocmds.
      --
      ---@param name string           -- nvim-lint linter name
      ---@param bufnr integer         -- current buffer number
      ---@return string|nil           -- resolved executable name or nil if unavailable
      local function get_linter_cmd(name, bufnr)
        local linter = lint.linters[name]
        local cmd = linter and linter.cmd
        if type(cmd) == "function" then
          local ok, v = pcall(cmd, bufnr)
          cmd = ok and v or nil
        end
        if type(cmd) == "table" then
          cmd = cmd[1]
        end
        return type(cmd) == "string" and cmd or nil
      end

      -- Try lint only for executables that exist.
      --
      -- This avoids session startup spam and abort.
      ---@return nil
      local function try_lint_existing()
        local bufnr = vim.api.nvim_get_current_buf()
        local ft = vim.bo[bufnr].filetype -- string
        for _, name in ipairs(lint.linters_by_ft[ft] or {}) do
          local cmd = get_linter_cmd(name, bufnr)
          if cmd and vim.fn.executable(cmd) == 1 then
            lint.try_lint(name)
          end
        end
      end

      vim.api.nvim_create_autocmd({
        "BufEnter",
        "BufWritePost",
        "TextChanged",
        "TextChangedI",
      }, {
        callback = try_lint_existing,
      })
    end,
  },
}
