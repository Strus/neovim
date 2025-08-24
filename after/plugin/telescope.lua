local utils = require('strus.utils')
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
        width = 0.6,
      },
      center = {
        preview_cutoff = 0,
        width = 0.4,
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
vim.cmd("autocmd User TelescopePreviewerLoaded setlocal wrap")

telescope.load_extension('dir')
require('dir-telescope').setup({
  hidden = true,
  no_ignore = false,
  show_preview = true,
})

vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>gc', builtin.git_branches, {})
vim.keymap.set('n', '<leader>fF',
  function()
    builtin.find_files({ hidden = true })
  end,
  { silent = true },
)
vim.keymap.set('n', '<leader>ff',
  function()
    builtin.find_files()
  end,
  { silent = true },
)
vim.keymap.set('n', '<leader>fG',
  ':lua require("telescope.builtin").live_grep({glob_pattern="!{submodules,x64,.git}*"})<CR>',
  { silent = true },
)
vim.keymap.set('n', '<leader>fg', builtin.live_grep({ glob_pattern = "!{test,submodules,x64,.git}*" }), { silent = true })
vim.keymap.set('x', '<leader>fg',
  builtin.live_grep({
    glob_pattern = "!*{test,submodules,x64,.git}*",
    default_text = utils.get_selected_text()
  }),
  { silent = true },
)
vim.keymap.set('x', '<leader>fG',
  builtin.live_grep({
    glob_pattern = "!*{submodules,x64,.git}*",
    default_text = utils.get_selected_text()
  }),
  { silent = true },
)
vim.keymap.set('n', '<leader>f8',
  builtin.grep_string({ glob_pattern = "!*{test,submodules,x64,.git}*" }),
  { silent = true },
)
vim.keymap.set('n', '<leader>f*',
  builtin.grep_string({ glob_pattern = "!*{submodules,x64,.git}*" }),
  { silent = true },
)
vim.keymap.set('n', '<leader>fi', ":Telescope dir live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>fe', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fc', builtin.commands, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
vim.keymap.set('n', '<leader><Tab>', builtin.buffers, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})

local function on_nvim_open(data)
  local is_directory = vim.fn.isdirectory(data.file) == 1
  if is_directory then
    vim.cmd.cd(data.file)
    require("telescope.builtin").find_files({ hidden = false })
    return
  end
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = on_nvim_open })

telescope.load_extension('harpoon')
vim.keymap.set("n", "<leader>fh", ":Telescope harpoon marks<CR>")
