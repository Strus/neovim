vim.g.compile_mode = {
  default_command = "",
  baleia_setup = true,
  buffer_name = "__compilation__",
  error_regexp_table = {
    vs = {
      -- 5>C:\Users\akepka\branches\bfd\streem\src\cfctl\cfdrivecommands.cpp(345,5): error C3861: 'eleteFileSystemTree': identifier not found [C:\Users\akepka\branches\bfd\streem\src\cfctl\cfctl.vcxproj]
      regex = "^ *\\d*>*\\(.*\\)(\\(.*\\),\\(.*\\)): \\(.*\\) .*",
      filename = 1,
      row = 2,
      col = 3,
      type = { 4 },
    }
  }
}
