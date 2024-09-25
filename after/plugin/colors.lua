vim.o.termguicolors = true
vim.o.background = "dark"

vim.api.nvim_create_autocmd("UIEnter", {
  group = vim.api.nvim_create_augroup("set_terminal_bg", {}),
  callback = function()
    local bg = vim.api.nvim_get_hl_by_name("Normal", true)["background"]
    if not bg then
      return
    end

    os.execute('tmux setw synchronize-panes on')
    os.execute(string.format('printf "\\033]11;#%06x\\007"', bg))
    if os.getenv("TMUX") then
      os.execute(string.format('printf "\\ePtmux;\\e\\033]11;#%06x\\007\\e\\\\"', bg))
    end
    os.execute('tmux setw synchronize-panes off')

    return true
  end,
})

local themes = {
  function() vim.cmd.colorscheme("carbonfox") end,
  function() vim.cmd.colorscheme("nordfox") end,
}

require('onedark').setup {
  style = 'cool'
}
require('onedark').load()
vim.cmd.colorscheme("onedark")

-- themes[math.random(#themes)]()
-- vim.api.nvim_create_user_command('RandomTheme', themes[math.random(#themes)], {})
