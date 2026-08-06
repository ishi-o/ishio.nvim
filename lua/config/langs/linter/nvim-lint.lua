local lint = require("lint")
lint.linters_by_ft = {
	c = { "cpplint" },
	cpp = { "cpplint" },
	css = { "stylelint" },
	docker = { "hadolint" },
	go = { "golangcilint" },
	html = { "htmlhint" },
	javascript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	json = { "jsonlint" },
	-- lua = { "luacheck" },
	markdown = { "markdownlint-cli2" },
	-- proto = { "buf_lint" },	-- lsp support
	python = { "ruff" },
	scss = { "stylelint" },
	typescript = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	yaml = { "yamllint" },
}
lint.linters.cpplint.args = {
	"--filter=-whitespace/tab,-whitespace/indent",
	"--linelength=120",
}
lint.linters.markdownlint.args = {
	"--disable",
	"MD010",
	"MD046",
	"--stdin",
}
lint.linters["markdownlint-cli2"].args = {
	"--config",
	os.getenv("HOME") .. "/.config/markdownlint/.markdownlint-cli2.jsonc",
	"--stdin",
}
lint.linters["yamllint"].args = {
	"--config",
	os.getenv("HOME") .. "/.config/yaml/.yamllint.yaml",
	"--stdin",
}
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
	callback = function()
		lint.try_lint()
	end,
})
