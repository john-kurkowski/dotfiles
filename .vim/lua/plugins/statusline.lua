return {
  {
    "itchyny/lightline.vim",
    lazy = false,
    priority = 999,
    init = function()
      vim.g.lightline = {
        colorscheme = "iceberg",
        active = {
          left = {
            { "mode", "paste" },
            { "gitbranch", "readonly", "absolutepath", "modified" },
          },
          right = {
            { "lineinfo" },
            { "linter_warnings", "linter_errors", "linter_ok" },
          },
        },
        component = {
          lineinfo = "%c%V",
        },
        component_expand = {
          linter_warnings = "LightlineLinterWarnings",
          linter_errors = "LightlineLinterErrors",
          linter_ok = "LightlineLinterOK",
        },
        component_function = {
          gitbranch = "LightlineFugitive",
          readonly = "LightlineReadonly",
        },
        component_type = {
          linter_warnings = "warning",
          linter_errors = "error",
        },
        inactive = {
          left = {
            { "absolutepath", "modified" },
          },
          right = {
            { "lineinfo" },
          },
        },
        separator = {
          left = "",
          right = "",
        },
        subseparator = {
          left = "",
          right = "",
        },
      }

      -- Define lightline functions in VimScript
      vim.cmd([[
        function! LightlineLinterWarnings() abort
          if !has('nvim')
            return ''
          endif
          let l:counts = luaeval('(vim.diagnostic.count(0)[vim.diagnostic.severity.WARN] or 0)')
          return l:counts == 0 ? '' : '◆ ' . l:counts
        endfunction

        function! LightlineLinterErrors() abort
          if !has('nvim')
            return ''
          endif
          let l:counts = luaeval('(vim.diagnostic.count(0)[vim.diagnostic.severity.ERROR] or 0)')
          return l:counts == 0 ? '' : '✗ ' . l:counts
        endfunction

        function! LightlineLinterOK() abort
          if !has('nvim')
            return ''
          endif
          let l:total = luaeval('#vim.diagnostic.get(0)')
          return l:total == 0 ? '✓' : ''
        endfunction

        function! LightlineReadonly()
          return &readonly ? '' : ''
        endfunction

        function! LightlineFugitive()
          let branch = FugitiveHead()
          return branch !=# '' ? ' '.branch : ''
        endfunction

        " Auto-refresh when diagnostics change
        autocmd User LspDiagnosticsChanged call lightline#update()
        autocmd DiagnosticChanged * call lightline#update()
      ]])
    end,
  },
}
