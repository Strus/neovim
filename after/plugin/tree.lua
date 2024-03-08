local tree = require('nvim-tree')
local tree_api = require('nvim-tree.api')

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.8

local function my_on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  tree_api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<LeftRelease>', tree_api.node.open.edit, opts('Edit'))
  vim.keymap.set('n', '<Esc>', tree_api.tree.close, opts('Close'))
  vim.keymap.set('n', '<leader>ft', tree_api.tree.close, opts('Close'))
  vim.keymap.set('n', '<leader>fT', tree_api.tree.close, opts('Close'))
end

tree.setup({
  on_attach = my_on_attach,
  renderer = {
    indent_width = 4,
  },
  view = {
    float = {
      enable = true,
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local window_w = screen_w * WIDTH_RATIO
        local window_h = screen_h * HEIGHT_RATIO
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.opt.lines:get() - window_h) / 2)
            - vim.opt.cmdheight:get()
        return {
          border = 'rounded',
          relative = 'editor',
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int,
        }
      end,
    },
    width = function()
      return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
    end,
  },
  git = {
    enable = false,
  },
  hijack_directories = {
    enable = false,
  },
  filters = {
    git_ignored = false,
  },
})

vim.keymap.set('n', '<leader>ft', function()
  tree_api.tree.toggle(true, false, vim.fn.getcwd())
end)
vim.keymap.set('n', '<leader>fT', function()
  tree_api.tree.toggle(true, false, vim.fn.expand('%:p:h'))
end)
