require("compile-mode").setup({
  -- you can disable colors by uncommenting this line
  -- no_baleia_support = true,
  default_command = "",
})

vim.keymap.set('n', "<leader>cC", ":Compile<CR>")
vim.keymap.set('n', "<leader>cc", ":Recompile<CR>")
