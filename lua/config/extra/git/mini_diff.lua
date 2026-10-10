local M = {}

function M.setup()
  local ok, mini_diff = pcall(require, "mini.diff")
  if not ok then
    return
  end

  mini_diff.setup({})
end

return M
