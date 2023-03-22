vim.g.language = 'en_US.utf8'

vim.opt.conceallevel = 0
vim.opt.concealcursor = 'nc'

vim.opt.termguicolors = true
vim.opt.fillchars = 'fold: ,vert:│,eob: ,msgsep:‾'

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*.dart",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end
})

vim.opt.autoindent = false
vim.opt.smartindent = false

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes:1'

vim.opt.updatetime = 50
vim.opt.colorcolumn = '120'

vim.opt.wildmenu = true

vim.opt.splitbelow = true
