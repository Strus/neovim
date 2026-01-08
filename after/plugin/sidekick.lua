local sidekick = require("sidekick")
local cli = require("sidekick.cli")

sidekick.setup({
  nes = {
    enabled = false,
  },
  cli = {
    mux = {
      backend = "tmux",
      enabled = false,
      create = "split",
      split = {
        size = 0.4,
      }
    },
  }
})

vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", function() cli.toggle() end)
vim.keymap.set("n", "<leader>aa", function() cli.toggle() end)
vim.keymap.set("n", "<leader>ad", function() cli.close() end)
vim.keymap.set({ "n", "x" }, "<leader>at", function() cli.send({ msg = "{this}" }) end)
vim.keymap.set("n", "<leader>af", function() cli.send({ msg = "{file}" }) end)
vim.keymap.set("x", "<leader>av", function() cli.send({ msg = "{selection}" }) end)
vim.keymap.set({ "n", "x" }, "<leader>ap", function() cli.prompt() end)
