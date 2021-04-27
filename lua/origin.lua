-- origin.lua
-- TODO:
--    neovim should have an option to call similar api func to getcwd()
--      - littleclover  Fri 12 Mar 2021 08:22:16 PM +08
local ft_table = {}
local root = vim.fn.getcwd()

local function origin()
  vim.api.nvim_echo({{root, "Normal"}}, false, {})
end

local function default_source(table)
  for key, value in pairs(table) do
    ft_table[key] = value
  end
end

local function set_root(dir)
  if dir == nil or dir == '' then
    dir = vim.fn.expand("%:p:h")
  end

  local ds = ft_table[vim.bo.filetype]
  if ds ~= nil and ds == vim.fn.substitute(vim.fn.expand(dir), "\\zs.*\\ze"..ds.."$", "", "") then
    root = vim.fn.substitute(vim.fn.expand(dir), ".*\\zs\\/"..ds.."\\ze$", "", "")
    vim.api.nvim_set_current_dir(root)
  else
    root = vim.fn.expand(dir)
    vim.api.nvim_set_current_dir(root)
  end

  vim.api.nvim_echo({{"Change root directory to `"..root.."`", "Normal"}}, true, {})
end

return {
  origin = origin,
  default_source = default_source,
  set_root = set_root,
}
