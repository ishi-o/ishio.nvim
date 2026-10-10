return {
  {
    cond = function()
      return _G.UserUtils.plugin_installed("fzf-lua")
    end,
    {
      "gd",
      function()
        require("fzf-lua").lsp_definitions()
      end,
      desc = "Goto: definition",
    },
    {
      "gD",
      function()
        require("fzf-lua").lsp_declarations()
      end,
      desc = "Goto: declaration",
    },
    {
      "gr",
      function()
        require("fzf-lua").lsp_references()
      end,
      nowait = true,
      desc = "Goto: references",
    },
    {
      "gi",
      function()
        require("fzf-lua").lsp_implementations()
      end,
      desc = "Goto: implementation",
    },
    {
      "gt",
      function()
        require("fzf-lua").lsp_typedefs()
      end,
      desc = "Goto: type definition",
    },
    {
      "gai",
      function()
        require("fzf-lua").lsp_incoming_calls()
      end,
      desc = "Show: incoming calls",
    },
    {
      "gao",
      function()
        require("fzf-lua").lsp_outgoing_calls()
      end,
      desc = "Show: outgoing calls",
    },
  },
}
