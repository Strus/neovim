-- Enable treesitter highlighting and indentation via FileType autocmd
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    -- Enable treesitter highlighting (disables regex syntax)
    pcall(vim.treesitter.start)
    -- Enable treesitter-based indentation (except for python)
    if vim.bo.filetype ~= 'python' then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Ensure parsers are installed (only installs missing ones)
local ensure_installed = {
  "bash",
  "c",
  "c_sharp",
  "cmake",
  "cpp",
  "css",
  "comment",
  "dart",
  "gitcommit",
  "gitignore",
  "vimdoc",
  "html",
  "json",
  "lua",
  "make",
  "markdown",
  "python",
  "rust",
  "scss",
  "swift",
  "vim",
}

local already_installed = require('nvim-treesitter.config').get_installed()
local parsers_to_install = vim.iter(ensure_installed)
  :filter(function(parser)
    return not vim.tbl_contains(already_installed, parser)
  end)
  :totable()

if #parsers_to_install > 0 then
  require('nvim-treesitter').install(parsers_to_install)
end
