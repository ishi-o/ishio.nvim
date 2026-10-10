local M = {}

local dir = vim.fn.stdpath("state") .. "/sessions"

local function session_file()
  local cwd = vim.fn.getcwd()
  local name = cwd:gsub("/", "%%")
  return dir .. "/" .. name .. ".vim"
end

local function list_sessions()
  local files = vim.fn.glob(dir .. "/*.vim", false, true)
  local items = {}
  for _, f in ipairs(files) do
    local name = vim.fn.fnamemodify(f, ":t:r"):gsub("%%", "/")
    items[#items + 1] = { name = name, file = f }
  end
  return items
end

function M.save()
  vim.fn.mkdir(dir, "p")

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
  vim.g.BufferlineTabBuffers = vim.json.encode(data)

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local buftype = vim.bo[bufnr].buftype
    if buftype == "terminal" then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end

  local saved = vim.o.sessionoptions
  vim.o.sessionoptions = "globals,blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
  vim.cmd("mksession! " .. vim.fn.fnameescape(session_file()))
  vim.o.sessionoptions = saved
end

function M.restore()
  local file = session_file()
  if vim.fn.filereadable(file) == 0 then
    return
  end
  vim.cmd("silent! source " .. vim.fn.fnameescape(file))

  local raw = vim.g.BufferlineTabBuffers
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
end

function M.search()
  local items = list_sessions()
  if #items == 0 then
    vim.notify("No sessions", vim.log.levels.WARN)
    return
  end
  vim.ui.select(items, {
    prompt = "Session: ",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.cmd("silent! source " .. vim.fn.fnameescape(choice.file))
  end)
end

function M.delete()
  local file = session_file()
  if vim.fn.filereadable(file) == 1 then
    vim.fn.delete(file)
    vim.notify("Deleted: " .. file, vim.log.levels.INFO)
  else
    vim.notify("No session for current dir", vim.log.levels.WARN)
  end
end

function M.delete_picker()
  local items = list_sessions()
  if #items == 0 then
    vim.notify("No sessions", vim.log.levels.WARN)
    return
  end
  vim.ui.select(items, {
    prompt = "Delete session: ",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.fn.delete(choice.file)
    vim.notify("Deleted: " .. choice.name, vim.log.levels.INFO)
  end)
end

function M.setup()
  local autocmd = _G.UserUtils.autocmd

  autocmd("VimLeavePre", { callback = M.save })
  autocmd("VimEnter", {
    callback = function()
      if vim.fn.argc() == 0 and vim.fn.filereadable(session_file()) == 1 then
        M.restore()
      end
    end,
  })
end

return M
