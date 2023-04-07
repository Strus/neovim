local M = {}

M.fugitiveOpened = false
M.filePath = nil

function M.openFileHistory(rich)
    M.filePath = vim.api.nvim_buf_get_name(0)
    if rich == false then
        vim.cmd('Git log --pretty=format:"%Cred%h%Creset %ad | %s [%an]" --date=short -- %')
    else
        vim.cmd('Git log -- %')
    end
    M.fugitiveOpened = true
end

function M.openLog(rich)
    M.filePath = vim.api.nvim_buf_get_name(0)
    if rich == false then
        vim.cmd('Git log --pretty=format:"%Cred%h%Creset %ad | %s [%an]" --date=short')
    else
        vim.cmd('Git log')
    end
    M.fugitiveOpened = true
end

function M.openBlame()
    M.filePath = vim.api.nvim_buf_get_name(0)
    vim.cmd('Git blame --date=short')
    M.fugitiveOpened = true
end

function M.openDiff(split)
    vim.cmd('norm! 0')
    local hash = vim.fn.expand('<cword>')
    if split == false then
        vim.cmd('tabnew ' .. M.filePath)
    else
        vim.cmd('sp ' .. M.filePath)
        vim.cmd('call feedkeys("\\<C-w>J")')
    end
    vim.cmd('Gvdiffsplit ' .. hash)
end

-- vim.keymap.set('n', '<leader>gh', function() M.openFileHistory(false) end, { silent = true })
-- vim.keymap.set('n', '<leader>gH', function() M.openFileHistory(true) end, { silent = true })
-- vim.keymap.set('n', '<leader>gl', function() M.openLog(false) end, { silent = true })
-- vim.keymap.set('n', '<leader>gL', function() M.openLog(true) end, { silent = true })
-- vim.keymap.set('n', '<leader>gb', function() M.openBlame() end, { silent = true })
-- vim.keymap.set('n', '<leader>gd', function() M.openDiff(false) end, { silent = true })

vim.keymap.set('n', '<leader>gh', ':Git log --pretty=format:"%Cred%h%Creset %ad | %s [%an]" --date=short -- %<CR>',
    { silent = true })
vim.keymap.set('n', '<leader>gH', ':Git log -- %<CR>', { silent = true })
vim.keymap.set('n', '<leader>gl', ':Git log --pretty=format:"%Cred%h%Creset %ad | %s [%an]" --date=short<CR>',
    { silent = true })
vim.keymap.set('n', '<leader>gL', ':Git log<CR>', { silent = true })
vim.keymap.set('n', '<leader>gb', ':Git blame --date=short<CR>', { silent = true })
vim.keymap.set('n', '<leader>gp', ':Git pull --recurse-submodules<CR>', { silent = true })
vim.keymap.set('n', '<leader>gu', ':Git pull --recurse-submodules<CR>', { silent = true })
vim.keymap.set('n', '<leader>gs', ':G<CR>', { silent = true })

vim.api.nvim_create_user_command('Push', '20 split | terminal git push', {})
vim.api.nvim_create_user_command('Pull', '20 split | terminal git pull --recurse-submodules', {})
