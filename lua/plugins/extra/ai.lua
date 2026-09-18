return {
  {
    dir = "~/Code/mini.codex/",
    cmd = "Codex",
    config = function()
      require("mini.codex").setup({
        input = {
          enabled = true,
        },
        output = {
          enabled = true,
        },
      })
    end,
  },
  {
    dir = "~/Code/codex-prompt-lsp/",
    opts = {},
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("config.extra.ai.mcphub").setup()
    end,
  },
}
