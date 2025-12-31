return {
  -- Focus mode
  { "junegunn/limelight.vim", cmd = "Limelight" },

  -- Register preview
  { "junegunn/vim-peekaboo" },

  -- Enhanced substitute with preview
  { "osyo-manga/vim-over" },

  -- Diff enhancements
  { "rickhowe/diffchar.vim" },

  -- Undo tree visualizer
  {
    "sjl/gundo.vim",
    cmd = { "GundoToggle" },
    init = function()
      if vim.fn.has('python3') == 1 then
        vim.g.gundo_prefer_python3 = 1
      end
    end,
  },
}
