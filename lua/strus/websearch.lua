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

vim.keymap.set('n', '<leader>sg', function() vim.cmd('Search ' .. vim.fn.expand("<cword>")) end,
  { silent = true })
vim.keymap.set('n', '<leader>sp', function() vim.cmd('SearchPython ' .. vim.fn.expand("<cword>")) end,
  { silent = true })
vim.keymap.set('n', '<leader>sc', function() vim.cmd('SearchCpp ' .. vim.fn.expand("<cword>")) end,
  { silent = true })
vim.keymap.set('n', "<leader>ss", function()
  return ":Search " .. vim.fn.input("Google search: ") .. "<cr>"
end, { expr = true })

return M
