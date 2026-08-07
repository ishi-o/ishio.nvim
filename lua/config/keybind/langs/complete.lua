-- Native completion keymaps are kept here for later re-enablement.
-- They are temporarily disabled while blink.cmp is active.
--[[
local function pum_visible(mode)
	if mode == "c" then
		return vim.fn.cmdcomplete_info().pum_visible == 1
	end
	return vim.fn.pumvisible() == 1
end

local function hide_completion()
	vim.api.nvim_select_popupmenu_item(-1, false, true, {})
end

local function accept_completion()
	if not pum_visible("i") then
		return "<Tab>"
	end

	local selected = vim.fn.complete_info({ "selected" }).selected or -1
	if selected == -1 then
		selected = 0
	end
	vim.api.nvim_select_popupmenu_item(selected, true, true, {})
	return ""
end

local function select_completion(delta, mode, fallback)
	if not pum_visible(mode) then
		if mode == "c" then
			-- wildtrigger() is the non-invasive native command-line completion
			-- trigger.  It also works for search command-lines.
			vim.fn.wildtrigger()
			-- On a fresh command-line the first trigger may only create the menu;
			-- if it is already available, apply this keypress to it as well.
			if not pum_visible("c") then
				return ""
			end
		else
			return fallback
		end
	end

	local info
	if mode == "c" then
		info = vim.fn.cmdcomplete_info()
	else
		info = vim.fn.complete_info({ "selected", "items" })
	end

	local selected = info.selected or -1
	local items = (mode == "c" and info.matches or info.items) or {}
	local item_count = #items
	local target

	if selected == -1 then
		-- With no selected item, moving forward starts at the first item and
		-- moving backward starts at the last item.
		target = delta > 0 and 0 or item_count - 1
	elseif delta > 0 and selected == item_count - 1 then
		-- Match blink.cmp: clear the selection before cycling.
		target = -1
	elseif delta < 0 and selected == 0 then
		target = -1
	else
		target = selected + delta
	end

	if target >= -1 and target < item_count then
		vim.api.nvim_select_popupmenu_item(target, mode ~= "c", false, {})
	end
	return ""
end

local function toggle_insert_completion()
	if pum_visible("i") then
		hide_completion()
	else
		vim.lsp.completion.get()
	end
end

local function toggle_cmdline_completion()
	if pum_visible("c") then
		hide_completion()
		return ""
	else
		vim.fn.wildtrigger()
		return ""
	end
end

local function snippet_jump_or_select(direction, fallback)
	if vim.snippet.active({ direction = direction }) then
		vim.snippet.jump(direction)
		return ""
	end
	if pum_visible("i") then
		return select_completion(direction, "i", "")
	end
	return fallback
end

return {
	{
		mode = "i",
		{
			"<Tab>",
			accept_completion,
			expr = true,
			desc = "Accept completion or Tab",
		},
		{
			"<A-j>",
			function()
				return select_completion(1, "i", "<A-j>")
			end,
			expr = true,
			desc = "Next completion item",
		},
		{
			"<A-k>",
			function()
				return select_completion(-1, "i", "<A-k>")
			end,
			expr = true,
			desc = "Prev completion item",
		},
		{
			"<C-n>",
			function()
				return snippet_jump_or_select(1, "<C-n>")
			end,
			expr = true,
			desc = "Next snippet or completion item",
		},
		{
			"<C-p>",
			function()
				return snippet_jump_or_select(-1, "<C-p>")
			end,
			expr = true,
			desc = "Prev snippet or completion item",
		},
		{
			"<C-y>",
			toggle_insert_completion,
			desc = "Toggle completion menu",
		},
	},
	{
		mode = "c",
		{
			"<Tab>",
			function()
				return select_completion(1, "c", "<Tab>")
			end,
			expr = true,
			desc = "Next completion item",
		},
		{
			"<S-Tab>",
			function()
				return select_completion(-1, "c", "<S-Tab>")
			end,
			expr = true,
			desc = "Prev completion item",
		},
		{
			"<C-y>",
			toggle_cmdline_completion,
			expr = true,
			desc = "Toggle completion menu",
		},
	},
}
]]

return {
	{
		mode = "i",
		{ "<Tab>", desc = "Confirm complete" },
		{ "<A-k>", desc = "Prev complete item" },
		{ "<A-j>", desc = "Next complete item" },
	},
	{
		mode = "c",
		{ "<Tab>", desc = "Prev complete item" },
		{ "<S-Tab>", desc = "Next complete item" },
	},
	{ "<C-y>", desc = "Toggle: complete panel", mode = { "i", "c" } },
}
