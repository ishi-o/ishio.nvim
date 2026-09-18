local M = {}

function M.setup()
  local ok, copilot = pcall(require, "copilot")
  if not ok then
    return
  end

  copilot.setup({
    suggestion = {
      enabled = true,
      hide_during_completion = false,
      auto_trigger = true,
      keymap = {
        accept = false,
        next = "<A-j>",
        prev = "<A-k>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      AvanteInput = false,
      help = true,
      markdown = true,
      snacks_picker_input = false,
      TelescopePrompt = false,
    },
  })
end

return M
