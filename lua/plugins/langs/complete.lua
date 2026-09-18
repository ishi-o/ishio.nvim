return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    lazy = false,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        enabled = false,
      },
      {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = {
          "tpope/vim-dadbod",
        },
      },
    },
    config = function()
      require("config.langs.complete.blink").setup()
    end,
  },
}
