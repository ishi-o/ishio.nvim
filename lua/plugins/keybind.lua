return {
  {
    "folke/which-key.nvim",
    lazy = true,
    event = "VeryLazy",
    config = function()
      require("config.keybind").setup()
    end,
  },
}
