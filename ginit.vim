" Enable Mouse
set mouse=a

" Set Editor Font
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    GuiFont! Iosevka NF:h13:l
endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Disable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 0
endif

if exists(':GuiWindowOpacity')
    GuiWindowOpacity 1.0
endif

nnoremap <silent><RightMouse> :CodeActionMenu<CR>
inoremap <silent><RightMouse> <Esc>:CodeActionMenu<CR>
xnoremap <silent><RightMouse> :CodeActionMenu<CR>gv
snoremap <silent><RightMouse> <C-G>:CodeActionMenu<CR>gv
