local wt_exe = (vim.env.SCOOP or vim.fn.expand("~/scoop")) ..
  "/apps/windows-terminal/current/wt.exe"

local ffi = require("ffi")

ffi.cdef[[
void keybd_event(
  unsigned char bVk,
  unsigned char bScan,
  unsigned long dwFlags,
  unsigned long long dwExtraInfo
);
]]

local function send_shifted_key(virtual_key)
  ffi.C.keybd_event(0x10, 0, 0, 0)
  ffi.C.keybd_event(virtual_key, 0, 0, 0)
  ffi.C.keybd_event(virtual_key, 0, 2, 0)
  ffi.C.keybd_event(0x10, 0, 2, 0)
end

local function invoke_wt(args)
  if vim.fn.filereadable(wt_exe) == 0 then
    wt_exe = "wt.exe"
  end
  vim.fn.system(vim.list_extend({ wt_exe, "-w", "0" }, args))
end

local function move_or_terminal(dir)
  local kitty_dir_map = { h = "left", j = "bottom", k = "top", l = "right" }
  local wt_dir_map = { h = "left", j = "down", k = "up", l = "right" }
  local current = vim.fn.winnr()
  vim.cmd("wincmd " .. dir)
  if vim.fn.winnr() == current then
    if vim.env.KITTY_WINDOW_ID then
      vim.fn.system("kitty @ focus-window --match neighbor:" .. kitty_dir_map[dir])
    elseif vim.env.WT_SESSION then
      invoke_wt({ "move-focus", wt_dir_map[dir] })
    end
  end
end

local function is_full_height()
  local height = vim.o.lines - vim.o.cmdheight
  if (vim.o.laststatus == 1 and #vim.api.nvim_tabpage_list_wins(0) > 1) or vim.o.laststatus > 1 then
    height = height - 1
  end
  if (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1) or vim.o.showtabline == 2 then
    height = height - 1
  end
  return vim.api.nvim_win_get_height(0) == height
end

local function resize_or_terminal(dir)
  local amount = 2
  local horizontal = dir == "h" or dir == "l"
  local fills_axis = horizontal and vim.api.nvim_win_get_width(0) == vim.o.columns or is_full_height()
  if fills_axis then
    if vim.env.WT_SESSION then
      send_shifted_key(({ h = 37, j = 40, k = 38, l = 39 })[dir])
    elseif vim.env.KITTY_WINDOW_ID then
      vim.fn.system({
        "kitty",
        "@",
        "resize-window",
        "--axis", horizontal and "horizontal" or "vertical",
        "--increment", (dir == "l" or dir == "j") and amount or -amount,
      })
    end
    return
  end
  local grow = vim.fn.winnr() ~= vim.fn.winnr(dir)
  local cmd = horizontal and "vertical resize " or "resize "
  vim.cmd(cmd .. (grow and "+" or "-") .. amount)
end

local function swap_buf(dir)
  local curwin = vim.api.nvim_get_current_win()
  local curbuf = vim.api.nvim_get_current_buf()
  vim.cmd("wincmd " .. dir)
  if vim.api.nvim_get_current_win() == curwin then
    return
  end
  local otherbuf = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_buf(0, curbuf)
  vim.api.nvim_win_set_buf(curwin, otherbuf)
end

local function smart_close()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  if #wins > 1 then
    vim.api.nvim_win_close(win, false)
  else
    vim.api.nvim_buf_delete(buf, {})
  end
end

return {
  {
    {
      "<leader>V",
      function()
        vim.ui.input({ prompt = "Horizontal split file: ", completion = "file" }, function(filename)
          if filename == nil then
            return
          end
          vim.api.nvim_cmd({
            cmd = "split",
            args = filename == "" and {} or { filename },
          }, {})
        end)
      end,
      desc = "Horizontal Split (input filename)",
    },
    {
      "<leader>v",
      function()
        vim.ui.input({ prompt = "Vertical split file: ", completion = "file" }, function(filename)
          if filename == nil then
            return
          end
          vim.api.nvim_cmd({
            cmd = "vsplit",
            args = filename == "" and {} or { filename },
          }, {})
        end)
      end,
      desc = "Vertical Split (input filename)",
    },
    { "<leader>-", "<cmd>split<CR>", desc = "Horizontal Split" },
    { "<leader>|", "<cmd>vsplit<CR>", desc = "Vertical Split" },
    { "<leader>q", smart_close, desc = "Delete window" },
    {
      "<C-h>",
      function()
        move_or_terminal("h")
      end,
      desc = "Focus on the left page",
      hidden = true,
    },
    {
      "<C-j>",
      function()
        move_or_terminal("j")
      end,
      desc = "Focus on the page below",
      hidden = true,
    },
    {
      "<C-k>",
      function()
        move_or_terminal("k")
      end,
      desc = "Focus on the page above",
      hidden = true,
    },
    {
      "<C-l>",
      function()
        move_or_terminal("l")
      end,
      desc = "Focus on the right page",
      hidden = true,
    },
    {
      "<A-h>",
      function()
        resize_or_terminal("h")
      end,
      desc = "Window resize left",
    },
    {
      "<A-j>",
      function()
        resize_or_terminal("j")
      end,
      desc = "Window resize down",
    },
    {
      "<A-k>",
      function()
        resize_or_terminal("k")
      end,
      desc = "Window resize up",
    },
    {
      "<A-l>",
      function()
        resize_or_terminal("l")
      end,
      desc = "Window resize right",
    },
    {
      "<leader>H",
      function()
        swap_buf("h")
      end,
      desc = "Window swap left",
      hidden = true,
    },
    {
      "<leader>J",
      function()
        swap_buf("j")
      end,
      desc = "Window swap down",
      hidden = true,
    },
    {
      "<leader>K",
      function()
        swap_buf("k")
      end,
      desc = "Window swap up",
      hidden = true,
    },
    {
      "<leader>L",
      function()
        swap_buf("l")
      end,
      desc = "Window swap right",
      hidden = true,
    },
  },
}
