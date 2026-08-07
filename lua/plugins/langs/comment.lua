return {
	{
		"danymat/neogen",
		lazy = true,
		module = "neogen",
		cmd = "Neogen",
		config = function()
			require("config.langs.comment.document")
		end,
	},
}
