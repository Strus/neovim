local copilot = pcall(require, "copilot") and require("copilot") or nil
if not copilot then
  return
end

vim.g.copilot_nes_debounce = 500
require("copilot").setup({
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = "<C-f>",
      dismiss = "<Esc>",
    },
    nes = {
      enabled = true,
      keymap = {
        accept_and_goto = "<C-f>",
        accept = false,
        dismiss = "<Esc>",
      },
    },
    sh = false,
  },
})

vim.api.nvim_create_user_command(
  'CursorOpenFile',
  function()
    local file_path = vim.fn.expand('%:p')
    local line_num = vim.fn.line('.')
    local cmd = string.format('cursor -r --goto "%s:%s"', file_path, line_num)
    vim.fn.jobstart(cmd, { detach = true })
  end,
  {
    nargs = 0,
  }
)

vim.api.nvim_create_user_command(
  'Cursor',
  function()
    local workspace_path = vim.fn.getcwd()
    local cmd = string.format('cursor -r "%s"', workspace_path)
    vim.fn.jobstart(cmd, { detach = true })
  end,
  {
    nargs = 0,
  }
)

vim.keymap.set({ 'n', 'v' }, '<leader>aA', ':Cursor<CR>', { silent = true })
