local M = {}

function M.setup()
  local ok, grug_far = pcall(require, "grug-far")
  if not ok then
    return
  end

  grug_far.setup({
    windowCreationCommand = (function()
      local width = math.floor(vim.o.columns * 0.35)
      return vim.cmd(width .. "vsplit")
    end)(),
  })
end

return M
