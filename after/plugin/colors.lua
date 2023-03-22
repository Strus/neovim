vim.o.termguicolors = true
local util = require('onedark.util')

local dimValue = 0.30
require('onedark').setup({
    colors = {
        diff = {
            add = util.darken("#109868", dimValue),
            delete = util.darken("#9A353D", dimValue),
            change = '#282c34',
        },
        git = { change = '#e0af68', add = '#109868', delete = '#9A353D', conflict = '#bb7a61' },
    }
})
