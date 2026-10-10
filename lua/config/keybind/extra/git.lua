return {
  {
    { "<leader>gg", "<cmd>Neogit<CR>", desc = "Show: neogit ui" },
    {
      "<leader>gD",
      function()
        local absolute_file = vim.api.nvim_buf_get_name(0)
        if absolute_file == "" or vim.bo.buftype ~= "" then
          vim.notify("Current buffer is not a file", vim.log.levels.WARN)
          return
        end

        local file = vim.fn.fnamemodify(absolute_file, ":.")
        local branches = vim.fn.systemlist({
          "git",
          "-C",
          vim.fn.fnamemodify(absolute_file, ":h"),
          "branch",
          "--all",
          "--format=%(refname:short)",
        })
        vim.ui.select(branches, {
          prompt = "Diff current file against branch: ",
        }, function(branch)
          branch = branch and vim.trim(branch)
          if not branch or branch == "" then
            return
          end

          require("diffview").open({ branch, "--", file })
        end)
      end,
      desc = "Diff file against branch",
    },
    {
      cond = function()
        return _G.UserUtils.plugin_installed("octo.nvim")
      end,
      { "<leader>ghi", "<cmd>Octo issue list<CR>", desc = "List issues" },
      { "<leader>ghp", "<cmd>Octo pr list<CR>", desc = "List pull requests" },
      { "<leader>ghd", "<cmd>Octo discussion list<CR>", desc = "List discussions" },
      { "<leader>ghn", "<cmd>Octo notification list<CR>", desc = "List notifications" },
      {
        "<leader>ghs",
        function()
          require("octo.utils").create_base_search_command({ include_current_repo = true })
        end,
        desc = "Search GitHub",
      },
      {
        "<leader>ght",
        function()
          require("config.extra.git.octo").toggle_use_local_fs()
        end,
        desc = "Toggle use_local_fs",
      },
    },
    {
      { "[h", "<cmd>Gitsigns prev_hunk<CR>", desc = "Prev hunk" },
      { "]h", "<cmd>Gitsigns next_hunk<CR>", desc = "Next hunk" },
      { "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", mode = { "n", "x" }, desc = "Stage hunk" },
      { "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", mode = { "n", "x" }, desc = "Reset hunk" },
      { "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>", desc = "Stage buffer" },
      { "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset buffer" },
      { "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk" },
      { "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
      { "<leader>hb", '<cmd>lua require("gitsigns").blame_line({ full = true })<CR>', desc = "Blame line" },
      { "<leader>hB", "<cmd>Gitsigns blame<CR>", desc = "Blame buffer" },
      { "<leader>hd", "<cmd>Gitsigns diffthis<CR>", desc = "Diff this" },
      { "<leader>hD", '<cmd>lua require("gitsigns").diffthis("~")<CR>', desc = "Diff line ~" },
      { "ih", ":<C-u>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "GitSigns Select Hunk" },
    },
  },
}
