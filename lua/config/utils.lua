local M = {}

function M.setup()
  _G.UserUtils = _G.UserUtils or {}

  function _G.UserUtils.plugin_installed(name)
    local data_path = vim.fn.stdpath("data")
    local plugin_path = data_path .. "/lazy/" .. name
    return vim.fn.isdirectory(plugin_path) == 1
  end

  _G.UserUtils.autocmd_group = _G.UserUtils.autocmd_group
    or vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

  function _G.UserUtils.autocmd(event, opts)
    opts.group = _G.UserUtils.autocmd_group
    return vim.api.nvim_create_autocmd(event, opts)
  end

  function _G.UserUtils.track_tab_buffers()
    local tab = vim.api.nvim_get_current_tabpage()
    local ok, buffers = pcall(vim.api.nvim_tabpage_get_var, tab, "bufferline_buffers")
    buffers = ok and type(buffers) == "table" and buffers or {}

    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].buflisted then
      buffers[tostring(buf)] = true
      vim.api.nvim_tabpage_set_var(tab, "bufferline_buffers", buffers)
    end
  end

  function _G.UserUtils.get_tab_buffers(tab)
    tab = tab or vim.api.nvim_get_current_tabpage()
    local ok, buffers = pcall(vim.api.nvim_tabpage_get_var, tab, "bufferline_buffers")
    local result = {}

    if ok and type(buffers) == "table" then
      for key, enabled in pairs(buffers) do
        local bufnr = tonumber(key)
        if enabled and bufnr and vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
          result[bufnr] = true
        end
      end
    end

    return result
  end

  function _G.UserUtils.remove_tab_buffer(buf, tab)
    tab = tab or vim.api.nvim_get_current_tabpage()
    local ok, buffers = pcall(vim.api.nvim_tabpage_get_var, tab, "bufferline_buffers")

    if ok and type(buffers) == "table" and buffers[tostring(buf)] then
      buffers[tostring(buf)] = nil
      vim.api.nvim_tabpage_set_var(tab, "bufferline_buffers", buffers)
    end
  end
end

return M
