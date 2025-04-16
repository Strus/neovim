local dap = require('dap')
local dapui = require('dapui')

require("dapui").setup({
  layouts = {
    {
      elements = {
        -- "console",
        "breakpoints",
        "watches",
        "stacks",
        "scopes"
      },
      size = 60, -- 40 columns
      position = "right",
    },
    {
      elements = {
        -- { id = "scopes", size = 0.3 },
        { id = "repl", size = 1.0 },
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    element = "scopes",
  },
})

-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   require('onedark').hideInactiveStatusline = false
--   dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   require('onedark').hideInactiveStatusline = true
--   dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   require('onedark').hideInactiveStatusline = true
--   dapui.close()
-- end

vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

vim.fn.sign_define('DapBreakpoint', {
  text = '',
  texthl = 'DapBreakpoint',
  linehl = 'DapBreakpoint',
  numhl = 'DapBreakpoint'
})
vim.fn.sign_define('DapBreakpointCondition',
  { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected',
  { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

vim.keymap.set('n', '<leader>db', ':DapToggleBreakpoint<CR>', { silent = true })
vim.keymap.set('n', '<leader>dl', ':lua require("dap").list_breakpoints()<CR>:copen<CR>', { silent = true })


dap.adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python',     -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch',
    name = 'Run',
    -- -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
    program = vim.fn.expand("%:p"),
  },
}
