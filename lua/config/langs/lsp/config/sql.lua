local conf = require("config.langs.lsp.conf")
local M = {}

function M.setup()
  vim.lsp.config("sqls", {
    capabilities = conf.capabilities,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("config_sqls_lsp", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "sqls" then
        conf.on_attach(client, args.buf)
      end
    end,
  })
end

return M
