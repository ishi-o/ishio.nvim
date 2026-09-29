local M = {}

function M.setup()
  local ok, auto_session = pcall(require, "auto-session")
  if not ok then
    return
  end

  auto_session.setup({
    pre_save_cmds = {
      function()
        local data = {}

        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          local paths = {}
          local ok, buffers = pcall(vim.api.nvim_tabpage_get_var, tab, "bufferline_buffers")

          if ok and type(buffers) == "table" then
            for key, enabled in pairs(buffers) do
              local bufnr = tonumber(key)

              if enabled and bufnr and vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
                paths[#paths + 1] = vim.api.nvim_buf_get_name(bufnr)
              end
            end
          end

          table.sort(paths)
          data[#data + 1] = paths
        end

        vim.g.bufferline_tab_buffers = vim.json.encode(data)
      end,
      function()
        -- Close overseer tasks
        local ok2, overseer_task_list = pcall(require, "overseer.task_list")
        if ok2 then
          local tasks = overseer_task_list.list_tasks()
          local cmds = {}
          for _, task in ipairs(tasks) do
            local json = vim.json.encode(task:serialize())
            json = string.gsub(json, "\\/", "/")
            json = string.gsub(json, "'", "\\'")
            table.insert(cmds, string.format("lua require('overseer').new_task(vim.json.decode('%s')):start()", json))
          end
          return cmds
        end
      end,
      function()
        -- Close avante sidebar
        local ok3, avante = pcall(require, "avante")
        if ok3 and avante then
          avante.close_sidebar()
        end
        return true
      end,
      function()
        -- Close terminal and kitty-scrollback buffers
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          local buftype = vim.bo[bufnr].buftype
          local filetype = vim.bo[bufnr].filetype
          if buftype == "terminal" or filetype == "kitty-scrollback" then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end
      end,
    },
    pre_restore_cmds = {
      function()
        local ok4, overseer = pcall(require, "overseer")
        if ok4 then
          for _, task in ipairs(overseer.list_tasks({})) do
            task:dispose(true)
          end
        end
      end,
    },
    post_restore_cmds = {
      function()
        local raw = vim.g.bufferline_tab_buffers
        if type(raw) ~= "string" or raw == "" then
          return
        end

        local ok, data = pcall(vim.json.decode, raw)
        if not ok or type(data) ~= "table" then
          return
        end

        local tabs = vim.api.nvim_list_tabpages()

        for index, paths in ipairs(data) do
          local tab = tabs[index]
          if tab then
            local buffers = {}

            for _, path in ipairs(paths) do
              local bufnr

              for _, candidate in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_valid(candidate) and vim.api.nvim_buf_get_name(candidate) == path then
                  bufnr = candidate
                  break
                end
              end

              if not bufnr and path ~= "" then
                bufnr = vim.fn.bufadd(path)
              end

              if bufnr then
                vim.bo[bufnr].buflisted = true
                buffers[tostring(bufnr)] = true
              end
            end

            vim.api.nvim_tabpage_set_var(tab, "bufferline_buffers", buffers)
          end
        end

        vim.cmd.redrawtabline()
      end,
    },
    save_extra_data = function()
      return vim.g.bufferline_tab_buffers
    end,
    restore_extra_data = function(_, raw)
      if type(raw) == "string" then
        vim.g.bufferline_tab_buffers = raw
      end
    end,
    suppress_dirs = {
      "~/",
      "~/opt",
      "~/tmp",
      "/tmp",
      "/",
    },
  })
end

return M
