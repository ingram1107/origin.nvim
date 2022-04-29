local M = {}

function M.loaded_origin()
  if vim.g.loaded_origin == 1 then
    return true
  else
    vim.g.loaded_origin = 1
    return false
  end
end

function M.set_autochdir()
  if vim.g.autochdir == true then
    return false
  end
end

return M
