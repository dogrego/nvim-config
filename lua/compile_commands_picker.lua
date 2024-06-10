local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values

local compileCommands = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Choose compile_commands",
        finder = finders.new_oneshot_job({"bash", "-c", "cd $WS_ROOT && find -name compile_commands.json -printf '%h\n'"}, opts),
        sorter = conf.file_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                clients = vim.lsp.buf_get_clients()
                vim.g.clangd_compile_commands_dir = "${WS_ROOT}/" .. selection[1]
                vim.cmd("LspRestart")
            end)
            return true
        end
    }):find()
end

return function()
    compileCommands(require("telescope.themes").get_dropdown())
end
