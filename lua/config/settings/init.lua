local M = {}

function M.setup()
  require("config.settings.global").setup()
  require("config.settings.opts").setup()
  require("config.settings.autocmds").setup()
  require("config.langs.diagnostic").setup()
  require("config.ui.statusbar").setup()
  require("config.settings.user_cmds").setup()
end

return M
