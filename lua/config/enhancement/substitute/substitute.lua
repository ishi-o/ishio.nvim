local M = {}

function M.setup()
  local ok, substitute = pcall(require, "substitute")
  if ok then
    substitute.setup()
  end
end

return M
