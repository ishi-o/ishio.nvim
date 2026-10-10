local M = {}

function M.setup()
  if not vim.env.KITTY_WINDOW_ID then
    return
  end

  local set_user_var = function(value)
    if value then
      io.stdout:write("\27]1337;SetUserVar=IS_NVIM=MQ==\7")
    else
      io.stdout:write("\27]1337;SetUserVar=IS_NVIM\7")
    end
    io.stdout:flush()
  end

  local autocmd = _G.UserUtils.autocmd

  autocmd({ "VimEnter", "VimResume" }, {
    callback = function()
      set_user_var(true)
    end,
  })

  autocmd({ "VimLeavePre", "VimSuspend" }, {
    callback = function()
      set_user_var(false)
    end,
  })
end

return M
