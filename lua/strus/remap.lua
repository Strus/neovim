function _G.toggleNuMode()
  if (vim.opt.relativenumber:get() == true) then
    vim.opt.number = true
    vim.opt.relativenumber = false
  else
    vim.opt.number = true
    vim.opt.relativenumber = true
  end
end

function _G.toggleLineNumbers()
  if (vim.opt.number:get() == true) then
    vim.opt.number = false
    vim.opt.relativenumber = false
  else
    vim.opt.number = true
    vim.opt.relativenumber = true
  end
end

function _G.toggleSignColumnAndLineNumbers()
  if (vim.opt.number:get() == true or vim.opt.signcolumn:get() ~= 'no') then
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.signcolumn = 'no'
  else
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.signcolumn = 'yes:1'
  end
end

function _G.toggleWrap()
  if (vim.opt.wrap:get() == true) then
    vim.opt.wrap = false
  else
    vim.opt.wrap = true
  end
end

function _G.toggleCursorline()
  if (vim.opt.cursorline:get() == true) then
    vim.opt.cursorline = false
  else
    vim.opt.cursorline = true
  end
end

_G.quickfixOpened = false
function _G.toggleQuickFix()
  if (_G.quickfixOpened == true) then
    _G.quickfixOpened = false
    vim.cmd("cclose")
  else
    _G.quickfixOpened = true
    vim.cmd("copen")
  end
end

vim.g.mapleader = " "

-- switch search highlighting on/off with ^h
vim.keymap.set("n", "<leader><leader><Tab>", "<C-^>")
vim.keymap.set("n", "<C-h>", ":set hlsearch! hlsearch?<CR>", { silent = true })

-- vim.keymap.set("n", "<leader>z", ":Centerpad 50<CR>", {silent=true})
vim.keymap.set("n", "<leader>z", ":NoNeckPain<CR>", { silent = true })

-- switch back/front jumps with each other
vim.keymap.set('n', '<C-i>', '<C-o>', { remap = false })
vim.keymap.set('n', '<C-o>', '<C-i>', { remap = false })

-- enter is G in Normal mode -> useful for navigating between lines by number
vim.keymap.set('n', '<CR>', 'G')

-- switch Insert->Normal mode with jj
vim.keymap.set('i', 'jj', '<Esc>')

-- vp doesn't replace paste buffer
vim.keymap.set('x', '<leader>p', 'p')
vim.keymap.set('x', 'p', '"_dP')

-- Undo breakpoints
vim.keymap.set('i', ',', ',<C-g>u')
vim.keymap.set('i', '.', '.<C-g>u')
vim.keymap.set('i', '!', '!<C-g>u')
vim.keymap.set('i', '?', '?<C-g>u')
vim.keymap.set('i', ';', ';<C-g>u')

vim.keymap.set('n', '<leader>\\', ':vs<CR> <C-w>l', { silent = true })
vim.keymap.set('n', '<leader>-', ':sp<CR> <C-w>j', { silent = true })
vim.keymap.set('n', '<leader>h', '<C-w>h', { silent = true })
vim.keymap.set('n', '<leader>j', '<C-w>j', { silent = true })
vim.keymap.set('n', '<leader>k', '<C-w>k', { silent = true })
vim.keymap.set('n', '<leader>l', '<C-w>l', { silent = true })

vim.keymap.set('n', '<leader>lm', ':lua toggleNuMode()<CR>', { silent = true })
vim.keymap.set('n', '<leader>ln', ':lua toggleLineNumbers()<CR>', { silent = true })
vim.keymap.set('n', '<leader>la', ':lua toggleSignColumnAndLineNumbers()<CR>', { silent = true })
vim.keymap.set('n', '<leader>lw', ':lua toggleWrap()<CR>', { silent = true })
vim.keymap.set('n', '<leader>lh', ':lua toggleCursorline()<CR>', { silent = true })
-- vim.keymap.set('n', '<leader>cc', ':lua toggleQuickFix()<CR>', { silent = true })
vim.keymap.set('n', '<C-l>', ':lua toggleQuickFix()<CR>', { silent = true })

vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv', { silent = true })
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv', { silent = true })

vim.keymap.set('n', 'J', 'mzJ`z')

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', 'Q', ':q')
vim.keymap.set('n', '<leader>:', 'q:')
-- vim.keymap.set('n', 'q:', ':q')
vim.keymap.set('n', '<leader>q', ':close<CR>', { silent = true })
vim.keymap.set('n', '<leader>w', ':wa<CR>', { silent = true })

vim.keymap.set('n', '<leader>rr', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>')
vim.keymap.set('v', '<leader>rr', 'y:%s/\\<<C-r>"\\>/<C-r>"/gI<Left><Left><Left>')
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

vim.keymap.set('n', '<leader>fn', ':cn<CR>', { silent = true })
vim.keymap.set('n', '<leader>fN', ':cp<CR>', { silent = true })

vim.keymap.set('n', '<leader>/', ':g/')

vim.keymap.set('n', '<leader>bt', ':tab new<CR>', { silent = true })
vim.keymap.set('n', '<leader>bl', ':tabnext<CR>', { silent = true })
vim.keymap.set('n', '<leader>bh', ':tabprevious<CR>', { silent = true })
vim.keymap.set('n', '<leader>bq', ':tabclose<CR>', { silent = true })

if vim.fn.has("mac") == 1 then
  vim.keymap.set("n", "gx", ':call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>', {})
elseif vim.fn.has("unix") == 1 then
  vim.keymap.set("n", "gx", ':call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>', {})
else
  vim.keymap.set("n", "gx", function() vim.cmd(':!start firefox ' .. vim.fn.expand("<cfile>")) end, { silent = true })
end
