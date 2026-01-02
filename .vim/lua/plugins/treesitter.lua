function table.except(super, sub)
  local result = {}
  local seenInResult = {}
  local lookupSub = {}

  for _, value in ipairs(sub) do
    lookupSub[value] = true
  end

  for _, value in ipairs(super) do
    if not lookupSub[value] and not seenInResult[value] then
      table.insert(result, value)
      seenInResult[value] = true
    end
  end

  return result
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    lazy = false,
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})

      local should_install = {
        "astro",
        "bash",
        "css",
        "glimmer",
        "html",
        "javascript",
        "json",
        "json5",
        "just",
        "make",
        "markdown",
        "python",
        "ruby",
        "rust",
        "scss",
        "svelte",
        "swift",
        "toml",
        "tsx",
        "typescript",
        "vue",
        "yaml",
      }

      treesitter.install(table.except(should_install, treesitter.get_installed()))

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
            vim.treesitter.start(args.buf)
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
    config = function()
      -- put your config here
    end,
  },
}
