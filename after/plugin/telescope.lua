utils = require('strus.utils')

require('telescope').setup({
  defaults = {
    path_display = { "smart" },
    layout_strategy = "vertical",
    dynamic_preview_title = true,
    show_preview = true,
    layout_config = {
      vertical = {
        preview_cutoff = 0,
        width = 0.6,
      },
      center = {
        preview_cutoff = 0,
        width = 0.4,
      },
    },
    mappings = {
      n = {
        ['<C-x>'] = require('telescope.actions').delete_buffer,
      },
      i = {
        ['<C-x>'] = require('telescope.actions').delete_buffer,
        ['<C-j>'] = require('telescope.actions').cycle_history_next,
        ['<C-k>'] = require('telescope.actions').cycle_history_prev,
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

local builtin = require('telescope.builtin')
require('telescope').load_extension('dir')
require('dir-telescope').setup({
  hidden = true,
  no_ignore = false,
  show_preview = true,
})

vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>gc', builtin.git_branches, {})
vim.keymap.set('n', '<leader>fF',
  ':lua require("telescope.builtin").find_files({hidden=true, glob_pattern="!*{submodules,x64}*"})<CR>',
  { silent = true })
vim.keymap.set('n', '<leader>ff',
  ':lua require("telescope.builtin").find_files({hidden=true, glob_pattern="!*{test,submodules,x64}*"})<CR>',
  { silent = true })
vim.keymap.set('n', '<leader>fG', ':lua require("telescope.builtin").live_grep({glob_pattern="!*{submodules,x64}*"})<CR>',
  { silent = true })
vim.keymap.set('n', '<leader>fg',
  ':lua require("telescope.builtin").live_grep({glob_pattern="!*{test,submodules,x64}*"})<CR>', { silent = true })
vim.keymap.set('x', '<leader>fw', function()
    require("telescope.builtin").live_grep({
      glob_pattern = "!*{test,submodules,x64}*",
      default_text = utils
          .get_selected_text()
    })
  end,
  { silent = true })
vim.keymap.set('x', '<leader>fW', function()
    require("telescope.builtin").live_grep({
      glob_pattern = "!*{submodules,x64}*",
      default_text = utils
          .get_selected_text()
    })
  end,
  { silent = true })
vim.keymap.set('n', '<leader>fi', ":Telescope dir live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>fe', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fc', builtin.commands, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
vim.keymap.set('n', '<leader><Tab>', builtin.buffers, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})

vim.cmd("autocmd User TelescopePreviewerLoaded setlocal wrap")

require('telescope').load_extension('fzf')

local function on_nvim_open(data)
  local is_directory = vim.fn.isdirectory(data.file) == 1
  if is_directory then
    vim.cmd.cd(data.file)
    require("telescope.builtin").find_files({ hidden = true })
    return
  end
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = on_nvim_open })

require("telescope").load_extension('harpoon')
vim.keymap.set("n", "<leader>fh", ":Telescope harpoon marks<CR>")
