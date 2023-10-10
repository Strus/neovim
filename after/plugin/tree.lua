local tree = require('nvim-tree')
local tree_api = require('nvim-tree.api')

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<LeftRelease>', api.tree.edit, opts('Edit'))
  vim.keymap.set('n', '<Esc>', api.tree.close, opts('Close'))
  vim.keymap.set('n', '<M-1>', api.tree.close, opts('Close'))
  vim.keymap.set('n', '<M-!>', api.tree.close, opts('Close'))
end

-- pass to setup along with your other options
require("nvim-tree").setup {
  ---
  on_attach = my_on_attach,
  ---
}

tree.setup({
  view = {
    width = 50,
    float = {
      enable = true,
      open_win_config = {
        row = 0,
        col = 0,
        width = 48,
        height = 66,
      }
    },
  },
  git = {
    enable = false,
  },
  hijack_directories = {
    enable = false,
  },
})

vim.keymap.set('n', '<M-1>', function()
  tree_api.tree.toggle(true, false, vim.fn.getcwd())
end)
vim.keymap.set('n', '<M-2>', function()
  tree_api.tree.toggle(true, false, vim.fn.expand('%:p:h'))
end)
