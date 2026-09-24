require("config.lazy").setup()
require("config.utils").setup()
require("config.settings").setup()
require("lazy").setup({
  spec = {
    { import = "plugins/keybind" },
  },
})
