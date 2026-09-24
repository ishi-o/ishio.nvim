local conf = require("config.langs.lsp.conf")
local M = {}

function M.setup()
  local ok, schemastore = pcall(require, "schemastore")

  vim.lsp.config("ts_ls", {
    on_attach = conf.on_attach,
    capabilities = conf.capabilities,
  })

  vim.lsp.config("jsonls", {
    on_attach = conf.on_attach,
    capabilities = conf.capabilities,
    settings = ok and {
      json = {
        schemas = schemastore.json.schemas(),
        validate = { enable = true },
      },
    } or nil,
  })
end

return M
