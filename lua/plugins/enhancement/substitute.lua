return {
  {
    "gbprod/substitute.nvim",
    lazy = true,
    module = "substitute",
    config = function()
      require("config.enhancement.substitute.substitute").setup()
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    lazy = true,
    cmd = { "GrugFar", "GrugFarWithin" },
    config = function()
      require("config.enhancement.substitute.grug-far").setup()
    end,
  },
}
