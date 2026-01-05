return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        astro = { "biomejs", "eslint", "stylelint" },
        css = { "stylelint", "biomejs" },
        javascript = { "biomejs", "eslint" },
        javascriptreact = { "biomejs", "eslint" },
        lua = { "luacheck" },
        python = { "mypy", "ruff" },
        typescript = { "biomejs", "eslint" },
        typescriptreact = { "biomejs", "eslint" },
        vue = { "biomejs", "eslint" },
      }

      -- Wrap selected linters to run via `mise x` and use project root as cwd
      local function project_root_from_buf(bufnr)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local dir = vim.fs.dirname(fname)
        local root = vim.fs.find(
          { ".mise.toml", ".mise.yaml", "pyproject.toml", "package.json", "Cargo.toml", ".git" },
          { upward = true, path = dir }
        )[1]
        return root and vim.fs.dirname(root) or dir
      end

      local function wrap_linter_with_mise(name, tool)
        local l = lint.linters[name]
        if not l then
          return
        end
        local orig_args = l.args
        l.cmd = "mise"
        l.args = function(ctx)
          local rest = type(orig_args) == "function" and orig_args(ctx) or (orig_args or {})
          local args = { "x", "--", tool or name }
          for _, a in ipairs(rest) do
            table.insert(args, a)
          end
          return args
        end
        l.cwd = function(ctx)
          return project_root_from_buf(ctx.bufnr)
        end
      end

      wrap_linter_with_mise("biomejs", "biome")
      wrap_linter_with_mise("eslint", "eslint")
      wrap_linter_with_mise("stylelint", "stylelint")
      wrap_linter_with_mise("luacheck", "luacheck")
      wrap_linter_with_mise("mypy", "mypy")
      wrap_linter_with_mise("ruff", "ruff")

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
