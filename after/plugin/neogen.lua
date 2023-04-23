require('neogen').setup {
  enabled = true,
  input_after_comment = true,
  languages = {
    python = {
      template = {
        annotation_convention = "reST",
      },
    },
  }
}

vim.keymap.set("n", "<leader>cd", ":Neogen<CR>", { silent = true })
