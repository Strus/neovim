require("toggleterm").setup({
  function(term)
    if term.direction == "horizontal" then
      return 20
    elseif term.direction == "vertical" then
      return 150
    end
  end,
  open_mapping = [[<M-0>]],
  insert_mappings = [[<M-0>]],
  terminal_mappings = [[<M-0>]],
  direction = "vertical",
  float_opts = {
    border = 'double',
    width = 150,
    height = 50,
    winblend = 0,
  },
  shading_factor = '-80',
  start_in_insert = true,
  persist_mode = true
})

vim.keymap.set("t", "<ESC>", "<C-\\><C-N>")
vim.keymap.set("n", "<M-)>", ":ToggleTerm direction=float<CR>", { silent = true })
vim.keymap.set("i", "<M-)>", ":ToggleTerm direction=float<CR>", { silent = true })
vim.keymap.set("n", "<leader>vv", ":ToggleTerm direction=horizontal<CR>", { silent = true })
vim.keymap.set("i", "<M-0>", ":ToggleTerm direction=vertical<CR>", { silent = true })
