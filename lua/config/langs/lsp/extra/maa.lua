local M = {}

local conf = require("config.langs.lsp.conf")

function M.setup()
  require("maa-pipeline.nvim").setup()

  vim.lsp.config("maa_pipeline", {
    capabilities = conf.capabilities,
    on_attach = conf.on_attach,
    init_options = {
      locale = "zh",
    },
  })
  vim.lsp.enable("maa_pipeline")
end

return M
