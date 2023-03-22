local function cwd()
    return [["P: " .. vim.fn.getcwd()]]
end

require('lualine').setup({
    options = {
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        theme = 'onedark',
    },
    sections = {
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
            {
                cwd(),
                separator = { left = '', right = '' }
            },
        },
        lualine_y = { 'diagnostics', 'progress' },
    },
})
