-- require("copilot").setup({
--   suggestion = {
--     auto_trigger = false,
--     keymap = {
--       accept = "<C-l>",
--     },
--   },
-- })
--
vim.keymap.set('i', '<C-l>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
-- vim.cmd([[let g:copilot_filetypes = { '*': v:false }]])

vim.keymap.set({ 'n', 'v' }, '<leader>ac', ':CopilotChat<CR>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>ae', ':CopilotChatExplain<CR>', { silent = true })
