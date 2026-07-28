-- local utils = require('strus.utils')
local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

telescope.setup({
  defaults = {
    path_display = { "smart" },
    layout_strategy = "vertical",
    dynamic_preview_title = true,
    show_preview = true,
    layout_config = {
      vertical = {
        preview_cutoff = 0,
        width = 0.8,
      },
      center = {
        preview_cutoff = 0,
        width = 0.8,
      },
    },
    mappings = {
      n = {
        ['<C-x>'] = actions.delete_buffer,
      },
      i = {
        ['<C-x>'] = actions.delete_buffer,
        ['<C-j>'] = actions.cycle_history_next,
        ['<C-k>'] = actions.cycle_history_prev,
      },
    },
  },
  pickers = {
    lsp_references = {
      fname_width = 150
    },
    oldfiles = {
      path_display = { "smart" },
      layout_strategy = "center",
      preview = {
        hide_on_startup = true,
      }
    },
    buffers = {
      path_display = { "smart" },
      layout_strategy = "center",
      only_cwd = true,
      sort_mru = true,
      preview = {
        hide_on_startup = true,
      }
    },
  },
  extensions = {
    marks = {
      path_display = { "smart" },
      layout_strategy = "center",
      only_cwd = true,
      sort_mru = true,
      preview = {
        hide_on_startup = true,
      }
    }
  }
})
telescope.load_extension('fzf')

telescope.load_extension('dir')
require('dir-telescope').setup({
  hidden = true,
  no_ignore = false,
  show_preview = true,
})

vim.keymap.set('n', '<leader>gc', builtin.git_branches)
vim.keymap.set('n', '<leader>fi', ":Telescope dir live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references)
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions)
vim.keymap.set('n', '<leader>fe', builtin.diagnostics)
vim.keymap.set('n', '<leader>fb', builtin.buffers)
vim.keymap.set('n', '<leader>fc', builtin.commands)
vim.keymap.set('n', '<leader>fk', builtin.keymaps)
vim.keymap.set('n', '<leader><Tab>', builtin.buffers)
vim.keymap.set('n', '<leader>fo', builtin.oldfiles)

telescope.load_extension('harpoon')
vim.keymap.set("n", "<leader>fh", ":Telescope harpoon marks<CR>")
