local M = {}

function M.setup()
  local ok, claudecode = pcall(require, "claudecode")
  if not ok then
    return
  end

  claudecode.setup({
    terminal = {
      side = "right",
      width = 0.45,
      height = 0.5,
    },

    command = "claude",
    keymaps = {
      toggle = {
        normal = "<leader>aa",
        terminal = "<C-aa>",
      },
      send = {
        normal = "<leader>as",
        visual = "<leader>as",
      },
      diff = {
        accept = "<leader>ad",
        reject = "<leader>ar",
      },
    },

    auto_focus = true,
    close_on_exit = false,
    highlights = {
      terminal = "ClaudeCodeTerminal",
    },
    log_level = "info",
  })

  vim.api.nvim_set_hl(0, "ClaudeCodeTerminal", { link = "NormalFloat" })
end

return M
