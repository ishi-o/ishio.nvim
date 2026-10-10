local conf = require("config.langs.lsp.shared")
local M = {}

function M.setup()
  vim.lsp.config("lemminx", {
    on_attach = conf.on_attach,
    capabilities = conf.capabilities,
    filetypes = {
      "xml",
      "xsd",
      "xsl",
      "xslt",
      "svg",
    },
  })
end

return M
