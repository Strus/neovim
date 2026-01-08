require("neogit").setup({
  disable_context_highlighting = true,
  git_services = {
    ["git.dev.box.net"] = {
      pull_request = "https://git.dev.box.net/${owner}/${repository}/compare/${branch_name}?expand=1",
      commit = "https://git.dev.box.net/${owner}/${repository}/commit/${oid}",
      tree = "https://${host}/${owner}/${repository}/tree/${branch_name}",
    },
    ["github.com"] = {
      pull_request = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
      commit = "https://github.com/${owner}/${repository}/commit/${oid}",
      tree = "https://${host}/${owner}/${repository}/tree/${branch_name}",
    },
  },
  kind = "split",
  sections = {
    untracked = {
      folded = true,
    },
  },
})

vim.keymap.set('n', '<leader>gl', ':Neogit log<CR>', { silent = true })
