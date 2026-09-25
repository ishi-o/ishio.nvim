return {
  name = "Run",
  builder = function()
    local file_name = vim.fn.expand("%:t:r")
    local executable_suffix = vim.fn.has("win32") == 1 and ".exe" or ""
    local build_dir = "./build/"
    local output_file = build_dir .. file_name .. executable_suffix
    return {
      cmd = output_file,
      components = {
        "open_output",
        "default",
      },
    }
  end,
  condition = {
    filetype = { "c", "cpp" },
  },
}
