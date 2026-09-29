local M = {}

function M.setup()
  local autocmd = _G.UserUtils.autocmd

  autocmd("FileType", {
    pattern = "go",
    callback = function()
      vim.keymap.set("n", "<leader>ci", function()
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
              local result = vim.fn.systemlist({
                "impl",
                inputs[2] .. " " .. inputs[1],
                inputs[3],
              })

              if vim.v.shell_error == 0 and #result > 0 then
                vim.api.nvim_put(result, "l", false, true)
              end
            end)
          end)
        end)
      end, { desc = "Generate go implementation" })
    end,
  })
end

return M
