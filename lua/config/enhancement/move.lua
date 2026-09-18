local M = {}

function M.setup()
  local ok, mini_move = pcall(require, "mini.move")
  if not ok then
    return
  end

  mini_move.setup({
    mappings = {
      left = "<C-S-h>",
      right = "<C-S-l>",
      down = "<C-S-j>",
      up = "<C-S-k>",

      line_left = "<C-S-h>",
      line_right = "<C-S-l>",
      line_down = "<C-S-j>",
      line_up = "<C-S-k>",
    },

    options = {
      reindent_linewise = true,
    },
  })
end

return M
