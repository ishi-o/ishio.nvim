return {
  {
    "]]",
    function()
      vim.fn.search("\\<" .. vim.fn.expand("<cword>") .. "\\>", "W")
    end,
    desc = "Next Reference",
    mode = { "n", "t" },
  },
  {
    "[[",
    function()
      vim.fn.search("\\<" .. vim.fn.expand("<cword>") .. "\\>", "bW")
    end,
    desc = "Prev Reference",
    mode = { "n", "t" },
  },
}
