vim.cmd [[
  function! ProjpluginName(path, ...) abort
     if a:path =~? 'bfd'
         return 'bfd'
     endif
  endfunction
]]
