require('telescope').setup({
    defaults = {
        path_display = { "smart" },
        layout_strategy = "vertical",
        dynamic_preview_title = true,
        mappings = {
            n = {
                ['<C-x>'] = require('telescope.actions').delete_buffer,
            },
            i = {
                ['<C-x>'] = require('telescope.actions').delete_buffer,
                ['<C-j>'] = require('telescope.actions').cycle_history_next,
                ['<C-k>'] = require('telescope.actions').cycle_history_prev,
            },
        }
    },
    pickers = {
        lsp_references = {
            fname_width = 150
        },
        oldfiles = {
            path_display = { "smart" },
            layout_strategy = "center",
            preview = {
                hide_on_startup = true,
            }
        },
        buffers = {
            path_display = { "tail" },
            layout_strategy = "center",
            preview = {
                hide_on_startup = true,
            }
        }
    },
})

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>gc', builtin.git_branches, {})
vim.keymap.set('n', '<leader>fF', ':lua require("telescope.builtin").find_files({hidden=true})<CR>', { silent = true })
vim.keymap.set('n', '<leader>ff',
    ':lua require("telescope.builtin").find_files({hidden=true, glob_pattern="!*test*"})<CR>', { silent = true })
vim.keymap.set('n', '<leader>fT', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ft', ':lua require("telescope.builtin").live_grep({glob_pattern="!*test*"})<CR>',
    { silent = true })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, {})
-- vim.keymap.set('n', '<leader>fs', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>fe', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fc', builtin.commands, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
vim.keymap.set('n', '<C-f>', builtin.grep_string, {})
vim.keymap.set('n', '<leader><C-f>', function()
    builtin.grep_string({ search = vim.fn.input("Find in files: ") });
end)
vim.keymap.set('n', '<leader><Tab>', builtin.buffers, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})

require('telescope').load_extension('projects')
vim.keymap.set('n', '<leader>pp', function() require 'telescope'.extensions.projects.projects {} end)

vim.cmd("autocmd User TelescopePreviewerLoaded setlocal wrap")

require('telescope').load_extension('fzf')

local function on_nvim_open(data)
    if data.file == '' or data.file == nil then
        require('telescope').extensions.projects.projects({})
        return
    end

    local is_directory = vim.fn.isdirectory(data.file) == 1
    if is_directory then
        vim.cmd.cd(data.file)
        require("telescope.builtin").find_files({ hidden = true })
        return
    end
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = on_nvim_open })
