local M = {}

function M.setup()
  local ok, fzf_lua = pcall(require, "fzf-lua")
  if not ok then
    return
  end

  fzf_lua.setup({})
  fzf_lua.register_ui_select()
end

return M
