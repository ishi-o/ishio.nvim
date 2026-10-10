local M = {}

function M.setup()
  local ok, octo = pcall(require, "octo")
  if not ok then
    return
  end

  octo.setup({
    picker = "fzf-lua",
    use_local_fs = false,
    enable_builtin = true,
  })
end

function M.toggle_use_local_fs()
  local ok, octo_config = pcall(require, "octo.config")
  if not ok then
    return
  end

  octo_config.values.use_local_fs = not octo_config.values.use_local_fs
  vim.notify("octo use_local_fs: " .. tostring(octo_config.values.use_local_fs))
end

return M
