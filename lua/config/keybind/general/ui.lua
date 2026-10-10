return {
  {
    "<leader>ur",
    function()
      vim.cmd("redraw")
      vim.cmd("noh")
      vim.cmd("diffupdate")
    end,
    desc = "Redraw, Noh, Diff update",
  },
  {
    "<leader>ud",
    function()
      local current_config = vim.diagnostic.config().virtual_lines
      local new_config
      if current_config == false then
        new_config = { current_line = true }
      else
        new_config = false
      end
      vim.diagnostic.config({ virtual_lines = new_config })
    end,
    desc = "Toggle diagnostic (virtual lines)",
  },
  {
    "<leader>uc",
    function()
      local bg = vim.opt.background:get() or "light"
      if bg == "light" then
        vim.opt.background = "dark"
      else
        vim.opt.background = "light"
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#E8DFC8", fg = "#5C6A72" })
        vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
      end
    end,
    desc = "Switch colorscheme (light / dark)",
  },
  {
    "<leader>uC",
    function()
      require("fzf-lua").colorschemes()
    end,
    desc = "Colorschemes",
  },
  {
    cond = function()
      return _G.UserUtils.plugin_installed("bufferline.nvim")
    end,
    {
      "<leader>u<tab>",
      function()
        local bufferline_config = require("bufferline.config")
        local mode = bufferline_config.options.mode == "tabs" and "buffers" or "tabs"
        bufferline_config.user.options = vim.tbl_deep_extend("force", bufferline_config.user.options, { mode = mode })
        bufferline_config.options.mode = mode
        bufferline_config.apply(true)
        vim.cmd.redrawtabline()
      end,
      desc = "Toggle tabline mode (buffers / tabs)",
    },
  },
}
