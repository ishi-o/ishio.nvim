return {
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("config.enhancement.session").setup()
    end,
  },
}
