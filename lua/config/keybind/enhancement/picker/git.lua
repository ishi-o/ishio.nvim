return {
  {
    cond = function()
      return _G.UserUtils.plugin_installed("fzf-lua")
    end,
    {
      "<leader>gb",
      function()
        require("fzf-lua").git_branches()
      end,
      desc = "Git Branches",
    },
    {
      "<leader>gl",
      function()
        require("fzf-lua").git_commits()
      end,
      desc = "Git Log",
    },
    {
      "<leader>gs",
      function()
        require("fzf-lua").git_status()
      end,
      desc = "Git Status",
    },
    {
      "<leader>gS",
      function()
        require("fzf-lua").git_stash()
      end,
      desc = "Git Stash",
    },
    {
      "<leader>gd",
      function()
        require("fzf-lua").git_diff()
      end,
      desc = "Git Diff",
    },
    {
      "<leader>gf",
      function()
        require("fzf-lua").git_bcommits()
      end,
      desc = "Git Log File",
    },
  },
}
