local copilot = pcall(require, "copilot") and require("copilot") or nil
if not copilot then
  return
end

vim.g.copilot_nes_debounce = 500
require("copilot").setup({
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = "<C-f>",
      dismiss = "<Esc>",
    },
    nes = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept_and_goto = "<C-f>",
        accept = false,
        dismiss = "<Esc>",
      },
    },
    sh = false,
  },
})
