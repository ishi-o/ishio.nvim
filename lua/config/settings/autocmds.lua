local autocmd = _G.UserUtils.autocmd
local pending_tab_buffers = {}

autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = _G.UserUtils.track_tab_buffers,
})

autocmd("TabClosedPre", {
	callback = function()
		pending_tab_buffers[#pending_tab_buffers + 1] = _G.UserUtils.get_tab_buffers()
	end,
})

autocmd("TabClosed", {
	callback = function()
		local buffers = table.remove(pending_tab_buffers, 1)
		if not buffers then
			return
		end

		local buffers_in_other_tabs = {}
		for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
			for buf in pairs(_G.UserUtils.get_tab_buffers(tab)) do
				buffers_in_other_tabs[buf] = true
			end
		end

		local skipped_buffers = {}
		for buf in pairs(buffers) do
			if not buffers_in_other_tabs[buf] and vim.api.nvim_buf_is_valid(buf) then
				local is_terminal = vim.bo[buf].buftype == "terminal"
				local ok = is_terminal or not vim.bo[buf].modified

				if ok then
					ok = pcall(vim.api.nvim_buf_delete, buf, { force = is_terminal })
				end

				if not ok then
					local name = vim.api.nvim_buf_get_name(buf)
					skipped_buffers[#skipped_buffers + 1] = name ~= "" and name or "[No Name]"
				end
			end
		end

		if #skipped_buffers > 0 then
			vim.notify(
				"Buffers kept after closing tab: " .. table.concat(skipped_buffers, ", "),
				vim.log.levels.WARN
			)
		end
	end,
})

autocmd("FileType", {
	pattern = "http",
	callback = function()
		local map = vim.keymap.set
		map("n", "<leader>Rb", "<cmd>lua require('kulala').scratchpad()<CR>", { buffer = true })
		map("n", "<leader>Rc", "<cmd>lua require('kulala').copy()<CR>", { buffer = true })
		map("n", "<leader>RC", "<cmd>lua require('kulala').from_curl()<CR>", { buffer = true })
		map("n", "<leader>Re", "<cmd>lua require('kulala').set_selected_env()<CR>", { buffer = true })
		map("n", "<leader>Rg", "<cmd>lua require('kulala').download_graphql_schema()<CR>", { buffer = true })
		map("n", "<leader>Ri", "<cmd>lua require('kulala').inspect()<CR>", { buffer = true })
		map("n", "<leader>Rn", "<cmd>lua require('kulala').jump_next()<CR>", { buffer = true })
		map("n", "<leader>Rp", "<cmd>lua require('kulala').jump_prev()<CR>", { buffer = true })
		map("n", "<leader>Rq", "<cmd>lua require('kulala').close()<CR>", { buffer = true })
		map("n", "<leader>Rr", "<cmd>lua require('kulala').replay()<CR>", { buffer = true })
		map("n", "<leader>Rs", "<cmd>lua require('kulala').run()<CR>", { buffer = true })
		map("n", "<leader>RS", "<cmd>lua require('kulala').show_stats()<CR>", { buffer = true })
		map("n", "<leader>Rt", "<cmd>lua require('kulala').toggle_view()<CR>", { buffer = true })
	end,
})

autocmd("FileType", {
	pattern = "python",
	callback = function()
		local map = vim.keymap.set
		map("n", "<leader>cv", "<cmd>:VenvSelect<CR>", { buffer = true })
	end,
})

autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		local map = vim.keymap.set
		map("i", "（", "（）<Esc>i", { buffer = true, silent = true, desc = "Insert pair （）" })
		map("i", "【", "【】<Esc>i", { buffer = true, silent = true, desc = "Insert pair 【】" })
		map("i", "《", "《》<Esc>i", { buffer = true, silent = true, desc = "Insert pair 《》" })
		map("n", "<leader>M", "<cmd>MarkdownPreview<CR>", { buffer = true })
	end,
})

autocmd("LspProgress", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local name = client and client.name or "LSP"
		local value = ev.data.params and ev.data.params.value
		if not value then
			return
		end

		local parts = {}
		if value.kind == "end" then
			table.insert(parts, "Done")
		else
			if value.title and value.title ~= "" then
				table.insert(parts, value.title)
			end
			if value.message and value.message ~= "" then
				table.insert(parts, value.message)
			end
			if value.percentage then
				table.insert(parts, string.format("(%d%%%%)", value.percentage))
			end
		end

		if #parts == 0 then
			return
		end

		local msg = table.concat(parts, " ")
		vim.api.nvim_echo({ { ("[%s] %s"):format(name, msg) } }, false, {
			id = ("progress-lsp-%s-%s"):format(ev.data.client_id, value.title or value.kind or "progress"),
			kind = "progress",
			title = ("[%s] %s"):format(name, value.title or "Progress"),
			status = value.kind == "end" and "success" or "running",
			percent = value.percentage,
		})
	end,
})

autocmd("FileType", {
	pattern = "go",
	callback = function()
		local map = vim.keymap.set
		map("n", "<leader>ci", function()
			local inputs = {}
			local function ask(prompt, default, callback)
				vim.ui.input({ prompt = prompt, default = default }, function(value)
					if value and value ~= "" then
						table.insert(inputs, value)
						if callback then
							callback()
						end
					end
				end)
			end
			ask("Receiver type (e.g., *MyStruct): ", "*", function()
				ask("Parameter name: ", "", function()
					ask("Interface name (e.g., io.Reader): ", "", function()
						local cmd = string.format("impl '%s %s' %s", inputs[2], inputs[1], inputs[3])
						local handle = io.popen(cmd)
						if handle then
							local result = handle:read("*a")
							handle:close()
							if result and result ~= "" then
								vim.api.nvim_put(vim.split(result, "\n"), "l", false, true)
							end
						end
					end)
				end)
			end)
		end, { desc = "Generate go implementation" })
	end,
})

do
	local ns = vim.api.nvim_create_namespace("bracket_hl")

	autocmd("CursorHold", {
		callback = function()
			local buf = vim.api.nvim_get_current_buf()
			vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

			local open = vim.fn.searchpairpos("[[({]", "", "[])}]", "nbW")
			local close = vim.fn.searchpairpos("[[({]", "", "[])}]", "nW")

			if open[1] ~= 0 and close[1] ~= 0 then
				vim.api.nvim_buf_set_extmark(buf, ns, open[1] - 1, open[2] - 1, {
					end_col = open[2],
					hl_group = "MatchParen",
				})
				vim.api.nvim_buf_set_extmark(buf, ns, close[1] - 1, close[2] - 1, {
					end_col = close[2],
					hl_group = "MatchParen",
				})
			end
		end,
	})
end
