local cmp = require('cmp')
local flutter = require('flutter-tools')
local lsp = require('lsp-zero')
local rt = require("rust-tools")

M = {}
function M.setLspMappings(bufnr, format_keymap_cmd, debug_keymap_cmd)
    local opts = { buffer = bufnr, remap = false }
    local silentOpts = { buffer = bufnr, remap = false, silent = true }

    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', '<C-b>', function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', '<leader>fs', function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
    -- vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', '<leader>ca', ':CodeActionMenu<CR>', silentOpts)
    vim.keymap.set('x', '<leader>ca', ':CodeActionMenu<CR>', silentOpts)
    -- vim.keymap.set('n', '<leader>fr', function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', '<leader>cr', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('i', '<C-n>', function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set('n', 'gh', ':ClangdSwitchSourceHeader<CR>', silentOpts)
    vim.keymap.set('n', '<leader>cf', ':' .. format_keymap_cmd .. '<CR>', silentOpts)

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.c,*.h,*.cpp,*.hpp",
        callback = function()
            vim.cmd("lua vim.lsp.buf.format()")
            -- vim.cmd("LspZeroFormat")
        end
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.dart,*.lua",
        callback = function()
            vim.cmd("lua vim.lsp.buf.format()")
        end
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.rs",
        callback = function()
            vim.cmd("RustFmt")
        end
    })
    vim.keymap.set('n', '<leader>dr', ':' .. debug_keymap_cmd .. '<CR>', { silent = true })
end

lsp.preset({
    name = 'recommended',
    manage_nvim_cmp = false,
})
lsp.on_attach(
    function(client, bufnr)
        M.setLspMappings(bufnr, "LspZeroFormat", "DapContinue")
    end
)

lsp.nvim_workspace()

-- vim.lsp.set_log_level('debug')
lsp.setup()

_G.inlineDiagnostics = false
function _G.toggleInlineDiagnostics()
    if (_G.inlineDiagnostics == true) then
        _G.inlineDiagnostics = false
    else
        _G.inlineDiagnostics = true
    end
    vim.diagnostic.config({
        virtual_text = _G.inlineDiagnostics,
    })
end

vim.keymap.set('n', '<C-e>', ":lua toggleInlineDiagnostics()<CR>", { silent = true })

require('fidget').setup {}

local cmp_config = lsp.defaults.cmp_config({
    mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- elseif luasnip.expand_or_jumpable() then
                -- luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
})
cmp.setup(cmp_config)


vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
    end
})


flutter.setup({
    on_attach = M.setLspMappings(bufnr, "lua vim.lsp.buf.format()", "FlutterVisualDebug")
})


local codelldb_path = vim.fn.expand('~/.local/share/nvim/mason/bin/codelldb')
local liblldb_path = vim.fn.expand('~/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.dylib')
local opts = {
    server = {
        on_attach = M.setLspMappings(bufnr, "RustFmt", "RustDebuggables"),
        settings = {
            ["rust-analyzer"] = {
                check = {
                    command = "clippy",
                    extraArgs = { "--all", "--", "-W", "clippy::all" }
                }
            }
        }
    },
    dap = {
        adapter = require('rust-tools.dap').get_codelldb_adapter(
            codelldb_path, liblldb_path)
    },
}

rt.setup(opts)

vim.g.code_action_menu_show_details = false
vim.g.code_action_menu_show_diff = true
vim.g.code_action_menu_show_action_kind = false

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }
require("lspconfig").clangd.setup({ capabilities = capabilities })
