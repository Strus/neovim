require('nvim_comment').setup()

vim.keymap.set('v', '<C-_>', ':CommentToggle<CR>', { silent = true })
vim.keymap.set('n', '<C-_>', ':CommentToggle<CR>j', { silent = true })
vim.keymap.set('v', '<C-/>', ':CommentToggle<CR>', { silent = true })
vim.keymap.set('n', '<C-/>', ':CommentToggle<CR>j', { silent = true })


vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
    pattern = "*.c,*.cpp,*.h,*.hpp",
    callback = function()
        vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
    end
})
