local M = {}

function M.setup()
  local bufferline = require("bufferline")
  local bufferline_config = require("bufferline.config")

  bufferline.setup({
    options = {
      custom_filter = function(buf)
        if bufferline_config.options.mode ~= "buffers" then
          return vim.bo[buf].buflisted
        end

        local buffers = vim.t.bufferline_buffers
        if not buffers or next(buffers) == nil then
          return vim.bo[buf].buflisted
        end

        return vim.bo[buf].buflisted
          and (vim.api.nvim_get_current_buf() == buf or buffers[tostring(buf)] == true)
      end,
      name_formatter = function(item)
        if bufferline_config.options.mode ~= "tabs" then
          return item.name
        end

        local buffer = next(_G.UserUtils.get_tab_buffers(item.tabnr))
        if not buffer then
          return item.name
        end

        local path = vim.api.nvim_buf_get_name(buffer)
        return path ~= "" and vim.fn.fnamemodify(path, ":t") or "[No Name]"
      end,
      hover = {
        enabled = true,
        reveal = { "close" },
      },

      indicator = { icon = "▌" },

      offsets = {
        {
          filetype = "neo-tree",
          text = "Directory",
          highlight = "Directory",
          separator = true,
        },
      },

      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return icon .. count
      end,

      separator_style = "thick",
    },
  })
end

return M
