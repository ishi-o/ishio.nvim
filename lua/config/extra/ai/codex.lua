local M = {}
function M.setup()
  require("nvim-codex-lsp")
  require("mini.codex").setup({
    input = {
      enabled = true,
    },
    output = {
      enabled = true,
    },
  })
end

return M
