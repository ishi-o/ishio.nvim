return {
  {
    "nvim-mini/mini.move",
    config = function()
      require("config.enhancement.move").setup()
    end,
  },
}
