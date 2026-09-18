return {
  {
    "nanotee/sqls.nvim",
    ft = { "sql", "mysql" },
  },
  {
    "tpope/vim-dadbod",
    cmd = { "DB" },
    init = function()
      require("config.extra.database").setup()
    end,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
  },
}
