return {
  {
    "cocopon/iceberg.vim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.opt.background = 'dark'
      vim.opt.cursorline = true
      vim.opt.cursorlineopt = 'number'
      vim.cmd.colorscheme('iceberg')
    end,
  },
}
