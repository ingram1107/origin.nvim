-- origin.lua
-- TODO:
--    neovim should have an option to call similar api func to getcwd()
--      - littleclover  Fri 12 Mar 2021 08:22:16 PM +08
if vim.version().minor < 5 then
  vim.api.nvim_err_writeln("fatal: origin: require Neovim version 0.5+")
  return
end

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

local function is_dir_exist(dir)
  if vim.fn.isdirectory(dir) == 1 then
    return dir
  end

  return nil
end

local function set_root(args)
  setmetatable(args, { __index = { manual = false } })
  local dir, manual = args[1] or args.dir, args[2] or args.manual

  if dir == nil or dir == '' then
    dir = vim.fn.expand("%:p:h")
  end

  if not manual then
    local ds = function (val_or_tab)
      if type(val_or_tab) ~= "table" then
        return val_or_tab
      end

      local tab = val_or_tab
      for _, val in pairs(tab) do
        if val == vim.fn.substitute(vim.fn.expand(dir), "\\zs.*\\ze"..val.."$", "", "") then
          return val
        end
      end

      return nil
    end

    ds = ds(ft_table[vim.bo.filetype])
    if ds ~= nil or ds == '' then
      root = is_dir_exist(vim.fn.substitute(vim.fn.expand(dir), ".*\\zs\\/"..ds.."\\ze$", "", ""))
      if root ~= nil then
        vim.api.nvim_set_current_dir(root)
      end
    else
      root = is_dir_exist(vim.fn.expand(dir))
      if root ~= nil then
        vim.api.nvim_set_current_dir(root)
      end
    end
  else
    root = is_dir_exist(vim.fn.expand(dir))
    if root ~= nil then
      vim.api.nvim_set_current_dir(root)
    end
  end

  if root ~= nil then
    vim.api.nvim_echo({{"Change root directory to `"..root.."`", "Normal"}}, true, {})
  else
    vim.api.nvim_echo({{"No change to root directory", "Normal"}}, true, {})
  end
end

return {
  origin = origin,
  default_source = default_source,
  set_root = set_root,
}
