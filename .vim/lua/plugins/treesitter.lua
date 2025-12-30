return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Pin to legacy master branch.
    -- TODO: upgrade to breaking main branch.
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "andymass/vim-matchup", -- for matchup integration
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
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
        },
        highlight = {
          enable = true,
        },
        incremental_selection = { enable = true },
        indent = { enable = true },
        matchup = { enable = true },
        textobjects = { enable = true },
      })

      -- Custom parser for justfiles
      require("nvim-treesitter.parsers").get_parser_configs().just = {
        install_info = {
          url = "https://github.com/IndianBoy42/tree-sitter-just",
          files = { "src/parser.c", "src/scanner.cc" },
          branch = "main",
          use_makefile = true,
        },
        maintainers = { "@IndianBoy42" },
      }
    end,
  },
}
