local utils = require('strus.utils')
local fff = require('fff')

fff.setup({
  prompt = '> ',
  layout = {
    height = 1.0,
    width = 1.0,
    preview_size = 0.6,
    preview_position = 'top',
  },
  preview = {
    wrap_lines = true,
  },
  keymaps = {
    cycle_previous_query = { '<C-k>' },
  },
  grep = {
    modes = { 'fuzzy', 'plain' },
  },
})

vim.keymap.set('n', '<leader>ff', function() fff.find_files() end)
vim.keymap.set('n', '<leader>fg', function()
  fff.live_grep({ query = '!submodules/ ' })
end)
vim.keymap.set('n', '<leader>fG', function()
  fff.live_grep({ query = '!submodules/ ' })
end)
vim.keymap.set('x', '<leader>fg', function()
  fff.live_grep({ query = '!submodules/ ' .. utils.get_selected_text() })
end)
vim.keymap.set('x', '<leader>fG', function()
  fff.live_grep({ query = '!submodules/ ' .. utils.get_selected_text() })
end)
vim.keymap.set('n', '<leader>f8', function()
  fff.live_grep({ query = '!submodules/ ' .. vim.fn.expand('<cword>') })
end)
vim.keymap.set('n', '<leader>f*', function()
  fff.live_grep({ query = '!submodules/ ' .. vim.fn.expand('<cword>') })
end)

-- Open fff when nvim is opened with a directory (was: telescope find_files on VimEnter)
vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      local dir = vim.fn.fnamemodify(data.file, ':p')
      vim.cmd.cd(dir)
      -- Wipe the directory buffer (netrw) so it doesn't interfere with fff
      vim.cmd.enew()
      vim.api.nvim_buf_delete(data.buf, { force = true })
      fff.find_files()
    end
  end,
})
