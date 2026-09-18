local conf = require("config.langs.lsp.conf")
local M = {}

function M.setup()
  vim.lsp.config("bashls", {
    on_attach = conf.on_attach,
    capabilities = conf.capabilities,
    filetypes = { "bash", "sh", "zsh" },
  })
end

return M
