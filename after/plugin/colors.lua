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
