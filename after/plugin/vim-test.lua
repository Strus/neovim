function _G.showFileInUpperSplit()
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = vim.api.nvim_buf_get_lines(0, current_pos[1] - 1, current_pos[1], false)
  local line_number = string.match(current_line[1], "%d+")
  local path = string.match(current_line[1], "\"(.+)\"")
  if line_number == nil or path == nil then
    print("No proper path to jump to")
    return
  end
  vim.cmd("wincmd k")
  if line_number ~= nil then
    vim.cmd("e +" .. line_number .. " " .. path)
    vim.cmd("set cursorline")
  else
    vim.cmd("e " .. path)
  end
  vim.cmd("wincmd j")
end

local quickfixOpened = false
function _G.toggleQuickfix()
  if quickfixOpened == true then
    quickfixOpened = false
    vim.cmd("cclose")
  else
    quickfixOpened = true
    vim.cmd("copen")
  end
end

vim.cmd [[
  function! CompileStrategy(cmd)
    Compile a:cmd
  endfunction

  let g:test#custom_strategies = {'compile': function('CompileStrategy')}
  let g:test#strategy = 'compile'
  " let g:test#strategy = 'dispatch'
  let g:test#neovim#start_normal = 1
]]


vim.keymap.set("n", "<leader>to", ":lua showFileInUpperSplit()<CR>", { silent = true })
vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { silent = true })
vim.keymap.set("n", "<leader>tt", ":TestNearest<CR>", { silent = true })
vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { silent = true })
vim.keymap.set("n", "<leader>cc", ":lua toggleQuickfix()<CR>", { silent = true })
