local M = {}

local map = vim.keymap.set
-- Native LSP completion is kept here for later re-enablement.
-- It is temporarily disabled while blink.cmp is active.
--[[
local completion_kind = vim.lsp.protocol.CompletionItemKind
local snippet_format = vim.lsp.protocol.InsertTextFormat.Snippet
local completion_popup_group = vim.api.nvim_create_augroup("config_lsp_completion_popup", { clear = true })

local function raise_completion_preview(bufnr)
	vim.schedule(function()
		if not vim.api.nvim_buf_is_valid(bufnr) or vim.api.nvim_get_current_buf() ~= bufnr then
			return
		end

		local preview_winid = vim.fn.complete_info({ "preview_winid" }).preview_winid
		if not preview_winid or preview_winid == 0 or not vim.api.nvim_win_is_valid(preview_winid) then
			return
		end

		local config = vim.api.nvim_win_get_config(preview_winid)
		if config.relative == "" then
			return
		end

		-- The insert completion menu uses zindex 100; the native LSP detail
		-- popup defaults to 50, so it would otherwise be hidden underneath it.
		config.zindex = 101
		pcall(vim.api.nvim_win_set_config, preview_winid, config)
	end)
end

local function setup_completion_preview(bufnr)
	if vim.b[bufnr].config_lsp_completion_preview then
		return
	end
	vim.b[bufnr].config_lsp_completion_preview = true

	vim.api.nvim_create_autocmd("CompleteChanged", {
		group = completion_popup_group,
		buffer = bufnr,
		callback = function()
			raise_completion_preview(bufnr)
		end,
	})
end

local function next_snippet_tabstop(text)
	local max_index = 0
	for index in text:gmatch("%${(%d+)") do
		max_index = math.max(max_index, tonumber(index))
	end
	for index in text:gmatch("%$(%d+)") do
		max_index = math.max(max_index, tonumber(index))
	end
	return max_index + 1
end

local function auto_bracket_completion(item)
	if item.kind ~= completion_kind.Function and item.kind ~= completion_kind.Method then
		return {}
	end

	-- Keep the old blink.cmp behavior for Markdown, where parentheses are not useful.
	if vim.bo.filetype == "markdown" then
		return {}
	end

	local text
	if item.textEdit and type(item.textEdit.newText) == "string" then
		text = item.textEdit.newText
	elseif type(item.insertText) == "string" and item.insertText ~= "" then
		text = item.insertText
	else
		text = item.label
	end
	if type(text) ~= "string" or text == "" or text:find("%(") or text:find("\n") then
		return {}
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	if line:sub(cursor[2] + 1, cursor[2] + 1) == "(" then
		return {}
	end

	if item.insertTextFormat == snippet_format then
		text = text .. ("(${%d})"):format(next_snippet_tabstop(text))
	else
		-- Convert plain text items into snippets so the cursor lands inside ().
		text = text .. "($0)"
	end

	if item.textEdit then
		item.textEdit.newText = text
	else
		item.insertText = text
	end
	item.insertTextFormat = snippet_format
	return {}
end
]]

M.on_attach = function(client, bufnr)
	-- map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
	-- map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
	-- map("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
	-- map("n", "gy", vim.lsp.buf.type_definition, { buffer = bufnr })
	-- map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
	map("n", "K", function()
		vim.lsp.buf.hover({
			border = "single",
		})
	end, { buffer = bufnr })
	map("n", "gK", function()
		vim.lsp.buf.signature_help({
			border = "single",
		})
	end, { buffer = bufnr })
	-- map("n", "gs", vim.lsp.buf.document_symbol, { buffer = bufnr })
	-- map("n", "gai", vim.lsp.buf.incoming_calls, { buffer = bufnr })
	-- map("n", "gao", vim.lsp.buf.outgoing_calls, { buffer = bufnr })
	map("n", "<F2>", vim.lsp.buf.rename, { buffer = bufnr })
	map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
	map("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr })
	map("n", "<leader>C", vim.lsp.buf.code_action, { buffer = bufnr })
	map("n", "<leader>cc", vim.lsp.buf.code_action, { buffer = bufnr })

	-- Native LSP completion is kept here for later re-enablement.
	--[[
	-- Enable LSP-driven auto-completion on every printable character.
	if client:supports_method("textDocument/completion")
		and client.server_capabilities.completionProvider
	then
		local provider = client.server_capabilities.completionProvider
		local existing = provider.triggerCharacters or {}
		local chars, seen = {}, {}
		local add_trigger = function(char)
			if not seen[char] then
				seen[char] = true
				table.insert(chars, char)
			end
		end
		for code = 32, 126 do
			add_trigger(string.char(code))
		end
		for _, char in ipairs(existing) do
			add_trigger(char)
		end
		provider.triggerCharacters = chars

		setup_completion_preview(bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr, {
			autotrigger = true,
			convert = auto_bracket_completion,
		})
	end
	]]

	if client.server_capabilities.documentSymbolProvider then
		local ok, navic = pcall(require, "nvim-navic")
		if ok then
			navic.attach(client, bufnr)
		end
	end

	if client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	if client:supports_method("textDocument/codeLens") then
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
	end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, "blink.cmp")
if ok then
	M.capabilities = vim.tbl_deep_extend("force", M.capabilities, blink.get_lsp_capabilities())
end
M.capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

return M
