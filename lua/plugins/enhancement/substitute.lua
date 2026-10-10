return {
  {
    "gbprod/substitute.nvim",
    lazy = true,
    module = "substitute",
    config = function()
      require("config.enhancement.substitute").setup()
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    lazy = true,
    cmd = { "GrugFar", "GrugFarWithin" },
    config = function()
      require("config.enhancement.grug-far").setup()
    end,
  },
}
