return {
  {
    "nanotee/sqls.nvim",
    ft = { "sql", "mysql" },
  },
  {
    "tpope/vim-dadbod",
    cmd = { "DB" },
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
    keys = {
      { "<leader>Du", "<cmd>DBUIToggle<CR>", desc = "Database UI" },
    },
    init = function()
      require("config.extra.database").setup()
    end,
  },
}
