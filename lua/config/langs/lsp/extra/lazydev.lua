local M = {}

function M.setup()
  require("lazydev").setup({
    library = {
      "lazy.nvim",
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })
end

return M
