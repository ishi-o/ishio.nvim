return {
  {
    cond = function()
      return _G.UserUtils.plugin_installed("fzf-lua")
    end,
    {
      "<leader>sb",
      function()
        require("fzf-lua").lines()
      end,
      desc = "Buffer Lines",
    },
    {
      "<leader>sg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>sw",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "Word under cursor",
      mode = { "n" },
    },
    {
      "<leader>sw",
      function()
        require("fzf-lua").grep_visual()
      end,
      desc = "Visual selection",
      mode = { "x" },
    },
    {
      '<leader>s"',
      function()
        require("fzf-lua").registers()
      end,
      desc = "Registers",
    },
    {
      "<leader>s/",
      function()
        require("fzf-lua").search_history()
      end,
      desc = "Search History",
    },
    {
      "<leader>sa",
      function()
        require("fzf-lua").autocmds()
      end,
      desc = "Autocmds",
    },
    {
      "<leader>sc",
      function()
        require("fzf-lua").command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>sC",
      function()
        require("fzf-lua").commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>sd",
      function()
        require("fzf-lua").diagnostics_workspace()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>sD",
      function()
        require("fzf-lua").diagnostics_document()
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>sh",
      function()
        require("fzf-lua").helptags()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>sH",
      function()
        require("fzf-lua").highlights()
      end,
      desc = "Highlights",
    },
    {
      "<leader>sj",
      function()
        require("fzf-lua").jumps()
      end,
      desc = "Jumps",
    },
    {
      "<leader>sk",
      function()
        require("fzf-lua").keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>sl",
      function()
        require("fzf-lua").loclist()
      end,
      desc = "Location List",
    },
    {
      "<leader>sm",
      function()
        require("fzf-lua").marks()
      end,
      desc = "Marks",
    },
    {
      "<leader>sM",
      function()
        require("fzf-lua").manpages()
      end,
      desc = "Man Pages",
    },
    {
      "<leader>sq",
      function()
        require("fzf-lua").quickfix()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>sR",
      function()
        require("fzf-lua").resume()
      end,
      desc = "Resume",
    },
    {
      "<leader>su",
      function()
        require("fzf-lua").undotree()
      end,
      desc = "Undo History",
    },
  },
}
