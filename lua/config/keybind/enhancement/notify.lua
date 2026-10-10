return {
  {
    cond = function()
      return _G.UserUtils.plugin_installed("noice.nvim") and _G.UserUtils.plugin_installed("fzf-lua")
    end,
    {
      "<leader>n",
      "<cmd>Noice fzf<CR>",
      desc = "Notification History",
    },
    {
      "<leader>fn",
      "<cmd>Noice fzf<CR>",
      desc = "Notification History",
    },
  },
}
