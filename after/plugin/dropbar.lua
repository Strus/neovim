require("dropbar").setup({
  icons = {
    enable = true,
    kinds = {
      file_icon = "",
      dir_icon = "",
    },
    ui = {
      bar = {
        separator = '/',
        extends = '…',
      },
    },
  },
  bar = {
    sources = function(buf, _)
      local sources = require('dropbar.sources')
      if vim.bo[buf].buftype == 'terminal' then
        return {
          sources.terminal,
        }
      end
      return {
        sources.path,
      }
    end,
  }
})
