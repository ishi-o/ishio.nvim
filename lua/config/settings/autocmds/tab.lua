local M = {}

function M.setup()
  local autocmd = _G.UserUtils.autocmd
  local pending_tab_buffers = {}

  autocmd({ "BufEnter", "BufWinEnter" }, {
    callback = _G.UserUtils.track_tab_buffers,
  })

  autocmd({ "BufDelete", "BufWipeout", "OptionSet" }, {
    callback = function(args)
      if args.event == "OptionSet" then
        if args.option ~= "buflisted" or vim.bo[args.buf].buflisted then
          return
        end
      end

      _G.UserUtils.remove_tab_buffer(args.buf, vim.api.nvim_get_current_tabpage())
    end,
  })

  autocmd("TabClosedPre", {
    callback = function()
      pending_tab_buffers[#pending_tab_buffers + 1] = _G.UserUtils.get_tab_buffers()
    end,
  })

  autocmd("TabClosed", {
    callback = function()
      local buffers = table.remove(pending_tab_buffers, 1)
      if not buffers then
        return
      end

      local buffers_in_other_tabs = {}
      for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        for buf in pairs(_G.UserUtils.get_tab_buffers(tab)) do
          buffers_in_other_tabs[buf] = true
        end
      end

      local skipped_buffers = {}
      for buf in pairs(buffers) do
        if not buffers_in_other_tabs[buf] and vim.api.nvim_buf_is_valid(buf) then
          local is_terminal = vim.bo[buf].buftype == "terminal"
          local ok = is_terminal or not vim.bo[buf].modified

          if ok then
            ok = pcall(vim.api.nvim_buf_delete, buf, { force = is_terminal })
          end

          if not ok then
            local name = vim.api.nvim_buf_get_name(buf)
            skipped_buffers[#skipped_buffers + 1] = name ~= "" and name or "[No Name]"
          end
        end
      end

      if #skipped_buffers > 0 then
        vim.notify("Buffers kept after closing tab: " .. table.concat(skipped_buffers, ", "), vim.log.levels.WARN)
      end
    end,
  })
end

return M
