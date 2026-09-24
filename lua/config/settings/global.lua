local M = {}

function M.setup()
  vim.g.mapleader = " "
  vim.g.have_nerd_font = true

  vim.filetype.add({
    extension = {
      json = "jsonc",
    },
  })
  vim.treesitter.language.register("json", { "jsonc" })
end

return M
