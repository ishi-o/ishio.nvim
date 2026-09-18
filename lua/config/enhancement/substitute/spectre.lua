local M = {}

function M.setup()
  local ok, spectre = pcall(require, "spectre")
  if ok then
    spectre.setup()
  end
end

return M
