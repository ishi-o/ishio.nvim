local M = {}

function M.setup()
  local ok, ksb = pcall(require, "kitty-scrollback")
  if ok then
    ksb.setup()
  end
end

return M
