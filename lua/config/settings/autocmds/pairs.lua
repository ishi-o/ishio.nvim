local M = {}

function M.setup()
  local autocmd = _G.UserUtils.autocmd

  local namespace = vim.api.nvim_create_namespace("bracket_hl")

  autocmd("CursorHold", {
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      if vim.bo[buf].filetype == "bigfile" then
        return
      end

      vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)

      local open = vim.fn.searchpairpos("[[({]", "", "[])}]", "nbW")
      local close = vim.fn.searchpairpos("[[({]", "", "[])}]", "nW")

      if open[1] ~= 0 and close[1] ~= 0 then
        vim.api.nvim_buf_set_extmark(buf, namespace, open[1] - 1, open[2] - 1, {
          end_col = open[2],
          hl_group = "MatchParen",
        })
        vim.api.nvim_buf_set_extmark(buf, namespace, close[1] - 1, close[2] - 1, {
          end_col = close[2],
          hl_group = "MatchParen",
        })
      end
    end,
  })
  autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      local map = vim.keymap.set
      map("i", "（", "（）<Esc>i", { buffer = true, silent = true, desc = "Insert pair （）" })
      map("i", "【", "【】<Esc>i", { buffer = true, silent = true, desc = "Insert pair 【】" })
      map("i", "《", "《》<Esc>i", { buffer = true, silent = true, desc = "Insert pair 《》" })
    end,
  })
end

return M
