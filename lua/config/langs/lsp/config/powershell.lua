local conf = require("config.langs.lsp.conf")

local M = {}

function M.is_available()
  return vim.fn.executable("pwsh") == 1
end

function M.setup()
  if not M.is_available() then
    vim.notify("[PowerShell] pwsh not found; PowerShell LSP is disabled", vim.log.levels.WARN)
    return false, "pwsh not found"
  end

  vim.lsp.config("powershell_es", {
    on_attach = conf.on_attach,
    capabilities = conf.capabilities,
    bundle_path = vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"),
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

  return true
end

return M
