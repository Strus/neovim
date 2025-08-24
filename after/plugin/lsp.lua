local cmp = require('cmp')
local luasnip = require('luasnip')

-- local function setLspMappings(bufnr, format_keymap_cmd, debug_keymap_cmd)
--   local opts = { buffer = bufnr, remap = false }
--   local silentOpts = { buffer = bufnr, remap = false, silent = true }
--
--   vim.keymap.set('n', '<leader>fD', vim.lsp.buf.declaration, opts)
--   vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--   -- vim.keymap.set('n', '<leader>fs', function() vim.lsp.buf.workspace_symbol() end, opts)
--   vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
--   vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
--   vim.keymap.set({ 'n', 'x' }, '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
--   -- vim.keymap.set('n', '<leader>ca', ':CodeActionMenu<CR>', silentOpts)
--   -- vim.keymap.set('x', '<leader>ca', ':CodeActionMenu<CR>', silentOpts)
--   vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
--   vim.keymap.set('i', '<C-n>', vim.lsp.buf.signature_help, opts)
--   vim.keymap.set('n', 'gh', ':ClangdSwitchSourceHeader<CR>', silentOpts)
--   vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, silentOpts)
--   vim.keymap.set('n', '<leader>dr', ':' .. debug_keymap_cmd .. '<CR>', { silent = true })
--
--   local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })
--   vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = '*.rs,*.lua,*.c,*.cpp,*.h,*.hpp,*.py,*.json,*.ts,*.tsx,*.js,*.jsx,*.rb',
--     callback = function()
--       vim.lsp.buf.format({ async = false })
--       MiniTrailspace.trim()
--       MiniTrailspace.trim_last_lines()
--     end,
--     group = format_group,
--   })
--
--   vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = '*.erb',
--     callback = function()
--       MiniTrailspace.trim()
--       MiniTrailspace.trim_last_lines()
--     end,
--     group = format_group,
--   })
-- end

vim.cmd([[autocmd FileType ruby setlocal indentkeys-=.]])

local opts = { remap = false }
local silentOpts = { remap = false, silent = true }

vim.keymap.set('n', '<leader>fD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
-- vim.keymap.set('n', '<leader>fs', function() vim.lsp.buf.workspace_symbol() end, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set({ 'n', 'x' }, '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
-- vim.keymap.set({ 'n', 'x' }, '<leader>ca', ':CodeActionMenu<CR>', silentOpts)
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
vim.keymap.set('i', '<C-n>', vim.lsp.buf.signature_help, opts)
vim.keymap.set('n', 'gh', ':ClangdSwitchSourceHeader<CR>', silentOpts)
vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, silentOpts)

local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = '*.rs,*.lua,*.c,*.cpp,*.h,*.hpp,*.py,*.json,*.ts,*.tsx,*.js,*.jsx,*.rb,*.swift',
  callback = function()
    vim.lsp.buf.format({ async = false })
    MiniTrailspace.trim()
    MiniTrailspace.trim_last_lines()
  end,
  group = format_group,
})

require('mason').setup()
require('mason-lspconfig').setup()

-- TODO
vim.lsp.config('basedpyright', {
  settings = {
    analysis = {
      diagnosticMode = "workspace",
      autoImportCompletions = true,
      disableOrganizeImports = true,
    },
  },
})

vim.lsp.config('html', {
  filetypes = { 'html', "templ", "eruby" },
})

-- vim.lsp.config('herb_ls', { force_setup = true })

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

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  completion = {
    autocomplete = false,
  },
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'luasnip',                keyword_length = 3 },
    { name = 'nvim_lsp_signature_help' },
    { name = 'codecompanion' },
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-f>'] = cmp.mapping(function(fallback)
      -- if cmp.visible() then
      --   vim.fn['copilot#Accept'](fallback)
      -- else
      fallback()
      -- end
    end, { 'i', 's' }),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-l>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
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

local completionDelay = 300
local timer = nil
function _G.setAutoCompleteDelay(delay)
  completionDelay = delay
end

function _G.getAutoCompleteDelay()
  return completionDelay
end

vim.api.nvim_create_autocmd({ "TextChangedI", "CmdlineChanged" }, {
  pattern = "*",
  callback = function()
    if timer then
      vim.loop.timer_stop(timer)
      timer = nil
    end

    timer = vim.loop.new_timer()
    timer:start(
      _G.getAutoCompleteDelay(),
      0,
      vim.schedule_wrap(function()
        cmp.complete({ reason = cmp.ContextReason.Auto })
      end)
    )
  end,
})


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

vim.g.code_action_menu_show_details = false
vim.g.code_action_menu_show_diff = true
vim.g.code_action_menu_show_action_kind = false

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }
require("lspconfig").clangd.setup({ capabilities = capabilities })

require("clangd_extensions").setup({
  extensions = {
    inlay_hints = {
      only_current_line = true,
    },
  }
})
