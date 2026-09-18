local M = {}

function M.setup()
  local ok, mcphub = pcall(require, "mcphub")
  if not ok then
    return
  end

  vim.env.ALLOWED_DIRECTORY = vim.fn.getcwd()
  vim.env.REPOSITORY_PATH = vim.fn.getcwd()

  mcphub.setup({
    extensions = {
      avante = {
        make_slash_commands = true,
      },
    },
  })
end

return M
