return {
  {
    "jannis-baum/vivify.vim",
    init = function()
      -- Configure markdown fenced languages for syntax highlighting
      vim.g.markdown_fenced_languages = {
        "bash=sh",
        "css",
        "handlebars=html",
        "hbs=html",
        "html",
        "javascript",
        "js=javascript",
        "json",
        "rust",
        "sh",
        "python",
        "zsh",
      }
    end,
  },
}
