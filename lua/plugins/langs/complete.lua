return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		lazy = false,
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				optional = true
			},
		},
		config = function()
			require("config.langs.complete.blink")
		end,
	},
}
