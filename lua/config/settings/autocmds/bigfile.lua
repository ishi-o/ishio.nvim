local M = {}

function M.setup()
  local autocmd = _G.UserUtils.autocmd

  vim.filetype.add({
    pattern = {
      [".*"] = {
        function(path, bufnr)
          if vim.b[bufnr].bigfile then
            return "bigfile"
          end
        end,
        { priority = math.huge },
      },
    },
  })

  autocmd("BufReadPre", {
    callback = function(args)
      local buf = args.buf
      local path = vim.api.nvim_buf_get_name(buf)
      if path == "" then
        return
      end

      local ok, stats = pcall(vim.loop.fs_stat, path)
      if not ok or not stats then
        return
      end

      if stats.size > 1.5 * 1024 * 1024 then
        vim.b[buf].bigfile = true
        vim.bo[buf].filetype = "bigfile"

        if vim.fn.exists(":NoMatchParen") ~= 0 then
          vim.cmd([[NoMatchParen]])
        end

        vim.opt_local.foldmethod = "manual"
        vim.opt_local.statuscolumn = ""
        vim.opt_local.conceallevel = 0
        vim.b[buf].completion = false
        vim.b[buf].minianimate_disable = true
        vim.b[buf].minihipatterns_disable = true

        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(buf) then
            vim.bo[buf].syntax = "off"
          end
        end)
      end
    end,
  })
end

return M
