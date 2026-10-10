local M = {}

function M.setup()
  require("config.settings.autocmds.init").setup()
  require("config.settings.global").setup()
  require("config.settings.opts").setup()
  require("config.langs.diagnostic").setup()
  require("config.ui.statusline").setup()
end

return M
