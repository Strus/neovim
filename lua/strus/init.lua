require('strus.remap')
require('strus.set')
require('strus.packer')
require('strus.websearch')

local timer = vim.loop.new_timer()
timer:start(5 * 60 * 1000, 5 * 60 * 1000, vim.schedule_wrap(function()
  vim.cmd('silent! noautocmd wa')
end))
