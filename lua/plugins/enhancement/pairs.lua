return {
  {
    "windwp/nvim-autopairs",
    config = function()
      require("config.enhancement.autopairs").setup()
    end,
  },
}
