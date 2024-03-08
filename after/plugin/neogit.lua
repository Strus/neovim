require("neogit").setup({
  disable_context_highlighting = true,
  git_services = {
    ["git.dev.box.net"] = "https://git.dev.box.net/${owner}/${repository}/compare/${branch_name}?expand=1",
    ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
  },
  kind = "split",
  sections = {
    untracked = {
      folded = true,
    },
  },
})

-- vim.keymap.set('n', '<leader>gs', ':Neogit<CR>', { silent = true })
vim.keymap.set('n', '<leader>gl', ':Neogit log<CR>', { silent = true })
