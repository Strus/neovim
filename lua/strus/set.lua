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
vim.opt.fileformats = "unix,dos"

vim.opt.autoindent = false
vim.opt.smartindent = false

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
vim.opt.splitright = true

vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    pcall(vim.cmd, "checktime")
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
    nargs = '?',
  }
)

-- command! -nargs=1 ToClip :let @+=@<args>

vim.cmd [[
set tabline=%!MyTabLine()  " custom tab pages line
function MyTabLine()
    let s = '' " complete tabline goes here
    " loop through each tab page
    for t in range(tabpagenr('$'))
        " set highlight
        if t + 1 == tabpagenr()
                let s .= '%#TabLineSel#'
        else
                let s .= '%#TabLine#'
        endif
        " set the tab page number (for mouse clicks)
        let s .= '%' . (t + 1) . 'T'
        let s .= ' '
        " set page number string
        let s .= t + 1 . ' '
        " get buffer names and statuses
        let n = ''      "temp string for buffer names while we loop and check buftype
        let m = 0       " &modified counter
        let bc = len(tabpagebuflist(t + 1))     "counter to avoid last ' '
        " loop through each buffer in a tab
        for b in tabpagebuflist(t + 1)
            " buffer types: quickfix gets a [Q], help gets [H]{base fname}
            " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
            if getbufvar( b, "&buftype" ) == 'help'
                let n = '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
            elseif getbufvar( b, "&buftype" ) == 'quickfix'
                let n = '[Q]'
            else
                let n = fnamemodify(bufname(b), ':t')
            endif
            " check and ++ tab's &modified count
            if getbufvar( b, "&modified" )
                let m += 1
            endif
            " no final ' ' added...formatting looks better done later
            if bc > 1
                let n .= ' '
            endif
            let bc -= 1
            break
        endfor
        " add modified label [n+] where n pages in tab are modified
        if m == 1
            let s .= '[+]'
        endif
        " select the highlighting for the buffer names
        " my default highlighting only underlines the active tab
        " buffer names.
        if t + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        " add buffer names
        let s .= n
        " switch to no underlining and add final space to buffer list
        let s .= ' '
    endfor
    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'
    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
            let s .= '%=%#TabLineFill#%999Xclose'
    endif
    return s
endfunction
]]
