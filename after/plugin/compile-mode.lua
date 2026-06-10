vim.g.compile_mode = {
  default_command = "",
  baleia_setup = true,
  buffer_name = "__compilation__",
  bang_expansion = true,
  focus_compilation_buffer = true,
  error_regexp_table = {
    vs = {
      -- 5>C:\Users\user\project\src\main.cpp(345,5): error C3861: 'missingSymbol': identifier not found [C:\Users\user\project\project.vcxproj]
      regex = "^ *\\d*>*\\(.*\\)(\\(.*\\),\\(.*\\)): \\(.*\\) .*",
      filename = 1,
      row = 2,
      col = 3,
      type = { 4 },
    },
    odin = {
      -- /path/to/project/file.odin(114:37) Error: Mismatched types in binary expression
      regex = "^\\(.*\\.odin\\)(\\(\\d\\+\\):\\(\\d\\+\\)) \\([^:]*\\): .*",
      filename = 1,
      row = 2,
      col = 3,
      type = { 4 },
    }
  }
}

vim.api.nvim_create_user_command("C", function(opts)
  if opts.args == "" then
    vim.cmd("Recompile")
  else
    vim.cmd("Compile " .. opts.args)
  end
end, {
  nargs = "*",
  complete = "shellcmd",
})
