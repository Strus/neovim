vim.keymap.set('i', '<C-f>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
-- vim.cmd([[let g:copilot_filetypes = { '*': v:false }]])
-- vim.keymap.set('i', '<C-a>', '<Plug>(copilot-suggest)')

vim.keymap.set({ 'n', 'v' }, '<leader>ac', ':CodeCompanionChat<CR>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>aa', ':CodeCompanion ', { silent = false })
vim.keymap.set({ 'n', 'v' }, '<leader>aA', ':CodeCompanionActions<CR>', { silent = false })
-- vim.keymap.set({ 'n', 'v' }, '<leader>ae', ':CopilotChatExplain<CR>', { silent = true })
-- vim.keymap.set({ 'n', 'v' }, '<leader>aA', ':CopilotChatCode<CR>', { silent = true })

require("codecompanion").setup({
  display = {
    diff = {
      provider = "mini_diff",
    },
  },
  opts = {
    log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
  },
  adapters = {
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            -- default = "claude-3.5-sonnet",
            default = "gpt-4o",
          },
        },
      })
    end,
  },
})
