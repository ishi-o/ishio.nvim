local M = {}

local conf = require("config.langs.lsp.conf")

function M.setup()
  require("maa-pipeline.nvim").setup({
    stop_hotkey = "Ctrl+Alt+S",
  })

  vim.lsp.config("maa_pipeline", {
    capabilities = conf.capabilities,
    on_attach = conf.on_attach,
    init_options = {
      -- locale = "zh",
      runtime = {
        daemon = true,
      },
    },
  })
  vim.lsp.enable("maa_pipeline")
end

return M
