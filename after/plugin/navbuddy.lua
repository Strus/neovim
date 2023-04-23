local navbuddy = require("nvim-navbuddy")

navbuddy.setup {
  lsp = {
    auto_attach = true,
  },
}

vim.keymap.set('n', '<leader>fs', ':Navbuddy<CR>', { silent = true })
