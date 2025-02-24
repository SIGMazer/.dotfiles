
local builtin = require('telescope.builtin')
require('telescope').load_extension('projects')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>gg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>bb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fp', "<Cmd>:Telescope projects <CR>"  )

local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
            n = {
                ["d"] = actions.delete_buffer,
            },
        },
    },
}

