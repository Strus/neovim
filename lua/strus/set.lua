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
    pattern = { "*.dart", "*.lua" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end
})

vim.opt.autoindent = false
vim.opt.smartindent = false

vim.opt.wrap = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.showbreak = '↪  '

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

vim.opt.autoread = true
vim.api.nvim_create_autocmd({"FocusGained","BufEnter","CursorHold","CursorHoldI"}, {
    pattern = "*",
    callback = function()
        vim.cmd("checktime")
    end
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    pattern = "*",
    callback = function()
        vim.cmd('echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None')
    end
})

vim.api.nvim_create_user_command(
    'Replace',
    function(args)
        local cfdo_args = '%s/'
        for w in args.args:gmatch("%S+") do cfdo_args = cfdo_args .. w .. '/' end
        cfdo_args = cfdo_args .. 'ge | update'
        vim.cmd.cfdo(cfdo_args)
    end,
    {
        nargs='?'
    }
)
