utils = require('strus.utils')

local M = {}

function M.normalize_for_url(text)
  -- Trim leading and trailing whitespace
  text = text:match("^%s*(.-)%s*$")
  -- Replace spaces with "+"
  text = text:gsub("%s+", "+")
  -- Encode special characters
  text = text:gsub("[^%w+]", function(char)
    return string.format("%%%02X", char:byte())
  end)
  return text
end

function M.open_url(engine, text)
  local url = engine .. M.normalize_for_url(text)
  local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
  local is_macos = vim.fn.has("mac") == 1
  local is_linux = not is_windows and not is_macos

  if is_windows then
    os.execute('powershell -NoLogo -NoProfile -NonInteractive -Command Start-Process "' .. url .. '"')
  elseif is_macos then
    os.execute('open "' .. url .. '"')
  elseif is_linux then
    os.execute('xdg-open "' .. url .. '" > /dev/null 2>&1 &')
  else
    vim.notify("Unsupported operating system", vim.log.levels.ERROR)
  end
end

vim.api.nvim_create_user_command("Search", function(opts)
  M.open_url("https://www.google.com/search?q=", opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("SearchPython", function(opts)
  M.open_url("https://docs.python.org/3/search.html?q=", opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("SearchCpp", function(opts)
  M.open_url("https://www.google.com/search?q=", opts.args .. " site:cppreference.com")
end, { nargs = 1 })

vim.api.nvim_create_user_command("T3Chat", function(opts)
  M.open_url("https://t3.chat", "")
end, { nargs = 0 })

vim.api.nvim_create_user_command("GotoJira", function(opts)
  M.open_url("https://jira.inside-box.net/browse/", opts.args)
end, { nargs = 1 })

vim.keymap.set({ 'n', 'v' }, '<leader>sg', function()
  vim.cmd('Search ' .. utils.get_selected_text())
end, { silent = true })

vim.keymap.set({ 'n', 'v' }, '<leader>sp', function()
  vim.cmd('SearchPython ' .. utils.get_selected_text())
end, { silent = true })

vim.keymap.set({ 'n', 'v' }, '<leader>sc', function()
  vim.cmd('SearchCpp ' .. utils.get_selected_text())
end, { silent = true })
vim.keymap.set('n', "<leader>ss", function()
  return ":Search " .. vim.fn.input("Google search: ") .. "<cr>"
end, { expr = true })

vim.keymap.set({ 'n', 'v' }, '<leader>sj', function()
  vim.cmd('GotoJira ' .. utils.get_selected_text())
end, { silent = true })

vim.keymap.set({ 'n', 'v' }, '<leader>sa', ":T3Chat<CR>", { silent = true })

return M
