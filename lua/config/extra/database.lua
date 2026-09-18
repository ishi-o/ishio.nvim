local M = {}

function M.setup()
  -- vim.g.db_ui_execute_on_save = 0
  -- vim.g.db_ui_show_help = 0
  -- vim.g.db_ui_use_nerd_fonts = 1
  vim.g.db_ui_save_location = vim.fn.stdpath("state") .. "/db_ui"
end

return M
