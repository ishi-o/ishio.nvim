local conf = require("config.langs.lsp.conf")

local M = {}

function M.setup()
  vim.lsp.config("powershell_es", {
    on_attach = conf.on_attach,
    capabilities = conf.capabilities,
    bundle_path = vim.fs.normalize(
      vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services/PowerShellEditorServices"
    ),
    settings = {
      powershell = {
        codeFormatting = {
          preset = "OTBS",
        },
        scriptAnalysis = {
          enable = true,
        },
      },
    },
  })
end

return M
