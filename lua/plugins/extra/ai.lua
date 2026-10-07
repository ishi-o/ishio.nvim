return {
  {
    "ishi-o/mini.codex",
    dependencies = {
      "ishi-o/codex-prompt-lsp",
    },
    cmd = "Codex",
    enabled = false,
    config = function()
      require("config.extra.ai.codex").setup()
    end,
  },
}
