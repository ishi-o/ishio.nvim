local M = {}

function M.setup()
  local autocmd = _G.UserUtils.autocmd
  local ns = vim.api.nvim_create_namespace("indent")
  local cache = {}

  local function line_of(buf, lnum)
    return vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1]
  end

  local function cols_of(line, sw)
    local cols, i, level = {}, 1, 0
    while i <= #line do
      local ch = line:sub(i, i)
      if ch == "\t" then
        cols[#cols + 1] = i - 1
        level = level + 1
      elseif ch == " " then
        if level % sw == 0 then
          cols[#cols + 1] = i - 1
        end
        level = level + 1
      else
        break
      end
      i = i + 1
    end
    return cols
  end

  local function pads_of(ws, sw, ts)
    local pads, level, vcol = {}, 0, 0
    for i = 1, #ws do
      local ch = ws:sub(i, i)
      if ch == "\t" then
        pads[#pads + 1] = vcol
        vcol = vcol + ts
        level = level + 1
      elseif ch == " " then
        if level % sw == 0 then
          pads[#pads + 1] = vcol
        end
        vcol = vcol + 1
        level = level + 1
      end
    end
    return pads
  end

  local function draw(buf, lnum, text)
    vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
      virt_text = { { text, "Comment" } },
      virt_text_pos = "overlay",
      hl_mode = "combine",
    })
  end

  vim.api.nvim_set_decoration_provider(ns, {
    on_win = function(_, _, buf, top, bottom)
      if vim.bo[buf].buftype ~= "" then
        return false
      end

      local sw = vim.bo[buf].shiftwidth
      if sw == 0 then
        sw = vim.bo[buf].tabstop
      end
      local ts = vim.bo[buf].tabstop

      local bc = cache[buf]
      if not bc or bc.sw ~= sw then
        bc = { sw = sw, lines = {} }
        cache[buf] = bc
      end

      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

      for lnum = top + 1, bottom do
        local line = line_of(buf, lnum)
        if not line then
          break
        end

        if line:match("^%s*$") then
          local ws = line:match("^%s*") or ""
          if #ws == 0 then
            local prev = vim.fn.prevnonblank(lnum)
            local next_ = vim.fn.nextnonblank(lnum)
            local ref = prev > 0 and prev or next_
            if ref > 0 then
              ws = line_of(buf, ref):match("^%s*") or ""
            end
          end
          if #ws > 0 then
            for _, pad in ipairs(pads_of(ws, sw, ts)) do
              draw(buf, lnum, string.rep(" ", pad) .. "▏")
            end
          end
        else
          local c = bc.lines[lnum]
          local cols
          if c and c.text == line then
            cols = c.cols
          else
            cols = cols_of(line, sw)
            bc.lines[lnum] = { text = line, cols = cols }
          end
          for _, col in ipairs(cols) do
            vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, col, {
              virt_text = { { "▏", "Comment" } },
              virt_text_pos = "overlay",
              hl_mode = "combine",
            })
          end
        end
      end

      return true
    end,
  })

  autocmd("BufDelete", {
    callback = function(args)
      cache[args.buf] = nil
    end,
  })

  autocmd("ColorScheme", {
    callback = function()
      cache = {}
      vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    end,
  })
end

return M
