return {
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    init = function()
      vim.g.mkdp_auto_close = 1
      -- Configure markdown fenced languages for syntax highlighting
      vim.g.markdown_fenced_languages = {
        'bash=sh',
        'css',
        'handlebars=html',
        'hbs=html',
        'html',
        'javascript',
        'js=javascript',
        'json',
        'rust',
        'sh',
        'python',
        'zsh',
      }
    end,
  },
}
