return {
  {
    "ishi-o/mini.codex",
    cmd = "Codex",
    config = function()
      require("mini.codex").setup()
    end,
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("config.extra.ai.mcphub")
    end,
  },
}
