return {
  {
    "ishi-o/mini.codex",
    dependencies = {
      "ishi-o/codex-prompt-lsp",
    },
    cmd = "Codex",
    config = function()
      require("config.extra.ai.codex").setup()
    end,
  },
}
