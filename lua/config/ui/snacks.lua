local M = {}

function M.setup()
  require("snacks").setup({
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    dim = { enabled = false },
    explorer = { enabled = false },
    image = { enabled = true },
    indent = { enabled = true },
    input = { enabled = false },
    notifier = { enabled = false },
    picker = { enabled = false },
    scope = { enabled = true },
    scroll = { enabled = true },
    words = { enabled = true },
    zen = { enabled = false },
  })
end

return M
