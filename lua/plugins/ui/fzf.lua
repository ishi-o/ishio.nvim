return {
  {
    "ibhagwan/fzf-lua",
    lazy = true,
    cmd = "FzfLua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("config.ui.fzf").setup()
    end,
  },
}
