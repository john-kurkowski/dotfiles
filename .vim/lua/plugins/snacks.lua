local snacks_terminal_cwd = vim.uv.cwd()

return {
  -- Sundry Vim capabilities, like floating terminal, focus mode, and buffer deletion
  {
    "folke/snacks.nvim",

    opts = {
      bufdelete = { enabled = true },

      dim = {
        -- e.g. `:lua Snacks.dim.enable()`

        enabled = true,
      },

      gitbrowse = {
        -- e.g. `:lua Snacks.gitbrowse({ what = "permalink" })`

        enabled = true,
      },

      terminal = { enabled = true },
    },

    init = function()
      vim.api.nvim_create_user_command("BufdeleteHidden", function()
        local current = vim.api.nvim_get_current_buf()
        local visible = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          visible[vim.api.nvim_win_get_buf(win)] = true
        end

        require("snacks").bufdelete.delete({
          filter = function(buf)
            return buf ~= current and vim.bo[buf].buflisted and not visible[buf]
          end,
        })
      end, { desc = "Delete hidden listed buffers" })
    end,

    keys = {
      {
        "<C-`>",
        function()
          Snacks.terminal.toggle("jj status; exec $SHELL -l", {
            -- Snacks terminal IDs include `count` and `cwd`; pin both so this
            -- keymap always toggles one float. Use startup cwd so `:cd` /
            -- `:lcd` later do not create a second terminal ID.
            count = 1,
            cwd = snacks_terminal_cwd,

            win = { position = "float", border = "rounded" },
          })
        end,
        mode = { "n", "t" },
        desc = "Terminal",
      },
    },
  },
}
