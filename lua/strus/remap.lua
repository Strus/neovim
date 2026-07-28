vim.g.mapleader = " "

vim.keymap.set("n", "<leader><leader><Tab>", "<C-^>")
-- switch search highlighting on/off with ^h
vim.keymap.set("n", "<C-h>", ":set hlsearch! hlsearch?<CR>", { silent = true })

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

-- easier copy/paste from system clipboard
vim.keymap.set('x', '<leader>y', '"+y')
vim.keymap.set('x', '<leader>p', '"+p')

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

vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv', { silent = true })
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv', { silent = true })

vim.keymap.set('n', 'J', 'mzJ`z')

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', 'Q', ':q')
vim.keymap.set('n', '<leader>:', 'q:')
vim.keymap.set('n', '<leader>q', ':close<CR>', { silent = true })
vim.keymap.set('n', '<leader>w', ':wa<CR>', { silent = true })

vim.keymap.set('n', '<leader>rr', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>')
vim.keymap.set('v', '<leader>rr', 'y:%s/\\<<C-r>"\\>/<C-r>"/gI<Left><Left><Left>')
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

vim.keymap.set('n', '<leader>fn', ':cn<CR>', { silent = true })
vim.keymap.set('n', '<leader>fN', ':cp<CR>', { silent = true })

vim.keymap.set('n', '<leader>/', ':g/')

vim.keymap.set('n', '<leader>bn', ':tab new<CR>', { silent = true })
vim.keymap.set('n', '<leader>bl', ':tabnext<CR>', { silent = true })
vim.keymap.set('n', '<leader>bh', ':tabprevious<CR>', { silent = true })
vim.keymap.set('n', '<leader>bq', ':tabclose<CR>', { silent = true })
