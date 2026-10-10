local M = {}

function M.setup()
  require("config.settings.autocmds.bigfile").setup()
  require("config.settings.autocmds.goimpl").setup()
  require("config.settings.autocmds.indent").setup()
  require("config.settings.autocmds.pairs").setup()
  require("config.settings.autocmds.tab").setup()
  require("config.settings.autocmds.session").setup()
end

return M
