return {
  {
    "ishianecho/mini.codex",
    dependencies = {
      "ishianecho/codex-prompt-lsp",
    },
    cmd = "Codex",
    enabled = false,
    config = function()
      require("config.extra.codex").setup()
    end,
  },
}
