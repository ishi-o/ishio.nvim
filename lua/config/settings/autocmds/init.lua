local M = {}

function M.setup()
  require("config.settings.autocmds.goimpl").setup()
  require("config.settings.autocmds.pairs").setup()
  require("config.settings.autocmds.tab").setup()
end

return M
