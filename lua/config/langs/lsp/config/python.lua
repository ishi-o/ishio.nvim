local conf = require("config.langs.lsp.conf")
local M = {}

function M.setup()
  vim.lsp.config("ty", {
    on_attach = conf.on_attach,
    capabilities = conf.capabilities,
    settings = {
      ty = {
        inlayHints = {
          variableTypes = true,
          callArgumentNames = true,
        },
      },
    },
  })
end

return M
