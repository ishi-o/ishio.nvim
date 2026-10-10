return {
  {
    { "<leader>fs", "<cmd>lua require('config.settings.autocmds.session').search()<CR>", desc = "Session" },
    { "<leader>Sd", "<cmd>lua require('config.settings.autocmds.session').delete()<CR>", desc = "Delete" },
    { "<leader>SD", "<cmd>lua require('config.settings.autocmds.session').delete_picker()<CR>", desc = "DeletePicker" },
    { "<leader>Sr", "<cmd>lua require('config.settings.autocmds.session').restore()<CR>", desc = "Restore" },
    { "<leader>Ss", "<cmd>lua require('config.settings.autocmds.session').save()<CR>", desc = "Save" },
  },
}
