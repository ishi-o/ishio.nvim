local M = {}

function M.setup()
  local ok, project_nvim = pcall(require, "project_nvim")
  if not ok then
    return
  end

  project_nvim.setup({
    detection_methods = { "pattern", "lsp" },
    patterns = {
      ".git",
      "package.json",
      "pyproject.toml",
      "Cargo.toml",
      "Makefile",
      "CMakeLists.txt",
    },
  })
end

return M
