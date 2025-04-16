local M = {}

function M.get_selected_text()
  local mode = vim.fn.mode()
  local text = ""
  if mode == 'v' or mode == 'V' then
    text = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'))[1]
  else
    text = vim.fn.expand("<cWORD>")
  end
  return text
end

return M
