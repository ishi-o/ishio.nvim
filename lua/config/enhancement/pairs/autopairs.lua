local M = {}

function M.setup()
  local ok, Rule = pcall(require, "nvim-autopairs.rule")
  if not ok then
    return
  end

  local ok2, npairs = pcall(require, "nvim-autopairs")
  if not ok2 then
    return
  end

  npairs.setup({
    disable_filetype = { "bigfile" },
    disable_in_macro = true,
    disable_in_visualblock = true,
    check_ts = true,
  })
  npairs.add_rule(Rule("“", "”", "markdown"))
  npairs.add_rule(Rule("‘", "’", "markdown"))
  npairs.add_rule(Rule("$", "$", "markdown"))
  npairs.add_rule(Rule("$$", "$$", "tex"))
end

return M
