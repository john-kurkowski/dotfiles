return {
  {
    "cocopon/iceberg.vim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.opt.background = "dark"
      vim.opt.cursorline = true
      vim.opt.cursorlineopt = "number"
      vim.cmd.colorscheme("iceberg")

      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
        fg = "#3e445e",
        italic = true,
      })

      local terminal_palettes = {
        horizon = {
          "#000000",
          "#e95678",
          "#29d398",
          "#fab795",
          "#26bbd9",
          "#ee64ac",
          "#59e1e3",
          "#e5e5e5",
          "#666666",
          "#ec6a88",
          "#3fdaa4",
          "#fbc3a7",
          "#3fc4de",
          "#f075b5",
          "#6be4e6",
          "#e5e5e5",
        },
      }

      -- Optional machine-local override via env, e.g. in .mise.local.toml:
      -- [env]
      -- NVIM_TERMINAL_THEME = "horizon"
      local terminal_theme = (vim.env.NVIM_TERMINAL_THEME or ""):lower()
      local palette = terminal_palettes[terminal_theme]
      if palette then
        for i, color in ipairs(palette) do
          vim.g["terminal_color_" .. (i - 1)] = color
        end
      end
    end,
  },
}
