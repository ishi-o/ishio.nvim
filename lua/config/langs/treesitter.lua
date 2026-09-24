local M = {}

local function start_treesitter(bufnr, language)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype == "" then
    return
  end

  local loaded, err = vim.treesitter.language.add(language)
  if not loaded then
    vim.notify(("[Treesitter] Could not load %s: %s"):format(language, err or "unknown error"), vim.log.levels.WARN)
    return
  end

  local ok, start_err = pcall(vim.treesitter.start, bufnr, language)
  if not ok then
    vim.notify(("[Treesitter] Could not start %s: %s"):format(language, start_err), vim.log.levels.WARN)
  end
end

function M.setup()
  local conf = require("config.langs.treesitter_conf")
  local autocmd = _G.UserUtils.autocmd
  local treesitter = require("nvim-treesitter")
  local pending = {}

  autocmd("FileType", {
    pattern = conf.fts,
    callback = function(args)
      local bufnr = args.buf
      local filetype = vim.bo[bufnr].filetype
      local language = vim.treesitter.language.get_lang(filetype) or filetype

      pending[language] = pending[language] or {}
      table.insert(pending[language], { bufnr = bufnr, filetype = filetype })

      if #pending[language] > 1 then
        return
      end

      local ok, task = pcall(treesitter.install, { language })
      if not ok then
        pending[language] = nil
        vim.notify(("[Treesitter] Could not install %s: %s"):format(language, task), vim.log.levels.ERROR)
        return
      end

      task:await(function(err, installed)
        vim.schedule(function()
          local buffers = pending[language]
          pending[language] = nil

          if err or installed == false then
            vim.notify(
              ("[Treesitter] Could not install %s: %s"):format(language, err or "unknown error"),
              vim.log.levels.ERROR
            )
            return
          end

          for _, item in ipairs(buffers or {}) do
            if vim.api.nvim_buf_is_valid(item.bufnr) and vim.bo[item.bufnr].filetype == item.filetype then
              start_treesitter(item.bufnr, language)
            end
          end
        end)
      end)
    end,
  })
end

return M
