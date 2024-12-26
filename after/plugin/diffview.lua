local actions = require("diffview.actions")

require("diffview").setup({
  keymaps = {
    view = {
      ["<leader>b"] = false,
      { "n", "<leader>f", actions.toggle_files, { desc = "Toggle the file panel." } },
    },
    file_panel = {
      ["<leader>b"] = false,
      { "n", "<leader>f", actions.toggle_files, { desc = "Toggle the file panel." } },
    },
    file_history_panel = {
      ["<leader>b"] = false,
      { "n", "<leader>f", actions.toggle_files, { desc = "Toggle the file panel." } },
    },
  },
})

vim.keymap.set('n', '<leader>gh', ':DiffviewFileHistory %<CR>', { silent = true })
