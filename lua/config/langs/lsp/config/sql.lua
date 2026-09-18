local conf = require("config.langs.lsp.conf")
local M = {}

function M.setup()
  vim.lsp.config("sqls", {
    on_attach = function(client, bufnr)
      conf.on_attach(client, bufnr)

      local ok, sqls = pcall(require, "sqls")
      if ok then
        sqls.on_attach(client, bufnr)
      end
    end,
    capabilities = conf.capabilities,
  })
end

return M
