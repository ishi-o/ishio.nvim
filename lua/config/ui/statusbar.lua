local ok, lualine = pcall(require, "lualine")
if not ok then
	return
end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		ignore_focus = {},
		always_divide_middle = true,
		-- true <-> vim.opt.laststatus = 3
		globalstatus = true,
		-- globalstatus = false,
		disabled_filetypes = {
			statusline = {
				"dap-repl",
				"NvimTree",
				"alpha",
				"dashboard",
			},
			winbar = {
				"dap-repl",
				"dapui_breakpoints",
				"dapui_console",
				"dapui_scopes",
				"dapui_watches",
				"dapui_stacks",
				"neo-tree",
				"AvanteTodos",
				"AvanteInput",
				"AvanteSelectedFiles",
				"snacks_picker_input",
				"snacks_picker_list",
				"snacks_layout_box",
				"toggleterm",
				"aerial",
				"snacks_terminal",
				"grug-far",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = {
			{
				"filename",
				path = 1,
				symbols = {
					modified = " [+]",
					readonly = " [-]",
					unnamed = "[unnamed]",
				},
				fmt = function(str)
					local filename = str:match("([^/]*)$")
					local path = str:sub(1, -(#filename + 1))
					return path .. "%#markdownBold# " .. filename .. " %*"
				end,
			},
		},
		lualine_x = {
			function()
				local r = vim.fn.reg_recording()
				if r ~= "" then
					return "recording:@" .. r
				else
					return ""
				end
			end,
			"lsp_status",
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn", "info", "hint" },
				symbols = {
					error = " ",
					warn = " ",
					info = " ",
					hint = " ",
				},
				colored = true,
				always_visible = false,
			},
			"filetype",
			"encoding",
			"fileformat",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { "nvim-tree", "toggleterm", "fzf" },
})
