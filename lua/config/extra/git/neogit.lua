local M = {}

function M.setup()
  local ok, neogit = pcall(require, "neogit")
  if not ok then
    return
  end

  neogit.setup({
    diff_viewer = "diffview",
    integrations = {
      diffview = true,
      telescope = false,
    },
  })
end

return M
