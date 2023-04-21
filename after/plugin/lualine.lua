local function cwd()
    return [["P: " .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')]]
end

require('lualine').setup({
    options = {
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
            {
                cwd(),
                separator = { left = '', right = '' }
            },
        },
        lualine_y = { 'progress' },
    },
})
