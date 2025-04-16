require('mini.trailspace').setup()

require("mini.diff").setup({
  view = {
    style = "sign",
    signs = {
      add = "+",
      change = "~",
      delete = "-"
    }
  },
  options = {
    algorithm = "patience",
  },
  mappings = {
    apply = '',
    textobject = '',
  }
})
