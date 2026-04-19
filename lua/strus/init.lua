vim.cmd('packadd nvim.undotree')

require('strus.remap')
require('strus.set')
require('strus.pack')
require('strus.websearch')

local timer = vim.loop.new_timer()
timer:start(5 * 60 * 1000, 5 * 60 * 1000, vim.schedule_wrap(function()
  vim.cmd('silent! noautocmd wa')
end))
