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
      ---@param bufnr? integer
      local function try_lint_existing(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        local ft = vim.bo[bufnr].filetype -- string
        for _, name in ipairs(lint.linters_by_ft[ft] or {}) do
          local cmd = get_linter_cmd(name, bufnr)
          if cmd and vim.fn.executable(cmd) == 1 then
            -- Prefer nvim-lint bufnr-aware API if available; otherwise, run in buffer context.
            local ok = pcall(lint.try_lint, name, { bufnr = bufnr })
            if not ok then
              vim.api.nvim_buf_call(bufnr, function()
                lint.try_lint(name)
              end)
            end
          end
        end
      end

      -- Debounced linting: immediate on enter/save; debounced while typing per-buffer
      local lint_timers = {}

      local function debounced_lint(bufnr, ms)
        ms = ms or 300
        local id = lint_timers[bufnr]
        if id then
          vim.fn.timer_stop(id)
        end
        lint_timers[bufnr] = vim.fn.timer_start(ms, function()
          vim.schedule(function()
            try_lint_existing(bufnr)
          end)
        end)
      end

      local grp = vim.api.nvim_create_augroup("LintingAutocmds", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        group = grp,
        callback = function(args)
          try_lint_existing(args.buf)
        end,
      })

      vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = grp,
        callback = function(args)
          debounced_lint(args.buf, 300)
        end,
      })

      vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
        group = grp,
        callback = function(args)
          local id = lint_timers[args.buf]
          if id then
            vim.fn.timer_stop(id)
            lint_timers[args.buf] = nil
          end
        end,
      })
    end,
  },
}
