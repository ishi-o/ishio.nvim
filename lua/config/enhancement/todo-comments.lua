local M = {}

function M.setup()
  local ok, todo_comments = pcall(require, "todo-comments")
  if ok then
    todo_comments.setup()
  end
end

return M
