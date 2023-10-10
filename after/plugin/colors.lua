vim.o.termguicolors = true
vim.o.background = "dark"

vim.api.nvim_create_autocmd("UIEnter", {
    group = vim.api.nvim_create_augroup("set_terminal_bg", {}),
    callback = function()
        local bg = vim.api.nvim_get_hl_by_name("Normal", true)["background"]
        if not bg then
            return
        end

        os.execute('tmux setw synchronize-panes on')
        os.execute(string.format('printf "\\033]11;#%06x\\007"', bg))
        if os.getenv("TMUX") then
            os.execute(string.format('printf "\\ePtmux;\\e\\033]11;#%06x\\007\\e\\\\"', bg))
        end
        os.execute('tmux setw synchronize-panes off')

        return true
    end,
})

local function onedark()
    local onedark_util = require('onedark.util')
    local dimValue = 0.30
    require('onedark').setup({
        colors = {
            diff = {
                add = onedark_util.darken("#109868", dimValue),
                delete = onedark_util.darken("#9A353D", dimValue),
                change = '#282c34',
            },
            git = { change = '#e0af68', add = '#109868', delete = '#9A353D', conflict = '#bb7a61' },
        }
    })

    local links = {
        ['@lsp.type.namespace'] = '@namespace',
        ['@lsp.type.type'] = '@type',
        ['@lsp.type.class'] = '@type',
        ['@lsp.type.enum'] = '@type',
        ['@lsp.type.interface'] = '@type',
        ['@lsp.type.struct'] = '@structure',
        ['@lsp.type.parameter'] = '@parameter',
        ['@lsp.type.variable'] = '@variable',
        ['@lsp.type.property'] = '@property',
        ['@lsp.type.enumMember'] = '@constant',
        ['@lsp.type.function'] = '@function',
        ['@lsp.type.method'] = '@method',
        ['@lsp.type.macro'] = '@macro',
        ['@lsp.type.decorator'] = '@function',
    }
    for newgroup, oldgroup in pairs(links) do
        vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
    end
end

local function everforest()
    vim.g.everforest_background = 'hard'
    vim.g.everforest_better_performance = 1

    vim.cmd.colorscheme("everforest")
end

local themes = {
    onedark,
    everforest,
    function() vim.cmd.colorscheme("carbonfox") end,
    function() vim.cmd.colorscheme("nordfox") end,
    function() vim.cmd.colorscheme("kanagawa-dragon") end,
}

themes[math.random(#themes)]()

vim.api.nvim_create_user_command('RandomTheme', themes[math.random(#themes)], {})
