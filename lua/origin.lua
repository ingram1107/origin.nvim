--[[
  origin.nvim   Nvim plugin that provide functionalities to set your cwd
  Copyright (C) 2021  Little Clover 
  This program is free software: you can redistribute it and/or modify 
  it under the terms of the GNU General Public License as published by 
  the Free Software Foundation, either version 3 of the License, or 
  (at your option) any later version. 
  This program is distributed in the hope that it will be useful, 
  but WITHOUT ANY WARRANTY; without even the implied warranty of 
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
  GNU General Public License for more details. 
  You should have received a copy of the GNU General Public License 
  along with this program.  If not, see <https://www.gnu.org/licenses/>
--]]

-- TODO:
--    neovim should have an option to call similar api func to getcwd()
--      - littleclover  Fri 12 Mar 2021 08:22:16 PM +08
if vim.version().minor < 5 then
  vim.api.nvim_err_writeln("fatal: origin: require Neovim version 0.5+")
  return
end

local ft_table = {}
local root = vim.fn.getcwd()
local prompt = true

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

  local dir_full_path = vim.fn.expand(dir)

  if not manual then
    local ds, nested = (function ()
      local val_or_tab = ft_table[vim.bo.filetype]
      if type(val_or_tab) ~= "table" then
        return val_or_tab
      end

      local tab = val_or_tab
      local full_path = vim.fn.expand(dir)
      local nested = false
      for _, val in pairs(tab) do
        local path_tail = vim.fn.substitute(full_path, "\\zs.*/\\ze"..val.."$", "", "")
        local match_relative_path = vim.fn.substitute(path_tail, "\\zs.*\\ze"..val.."/", "", "")
        local match_val = vim.fn.substitute(match_relative_path, val.."\\zs/.*", "", "")

        if val == path_tail then
          return val, nested
        elseif val == match_val then
          nested = true
          return val, nested
        end
      end

      return nil
    end)()

    if ds ~= nil or ds == '' then
      if not nested then
        root = is_dir_exist(vim.fn.substitute(dir_full_path, ".*\\zs/"..ds.."\\ze$", "", ""))
      else
        root = is_dir_exist(vim.fn.substitute(dir_full_path, ".*\\zs/"..ds..".*", "", ""))
      end

      if root ~= nil then
        vim.api.nvim_set_current_dir(root)
      end
    else
      root = is_dir_exist(dir_full_path)
      if root ~= nil then
        vim.api.nvim_set_current_dir(root)
      end
    end
  else
    root = is_dir_exist(dir_full_path)
    if root ~= nil then
      vim.api.nvim_set_current_dir(root)
    end
  end

  if prompt == true then
    if root ~= nil then
      vim.api.nvim_echo({{"Change root directory to `"..vim.fn.expand(root).."`", "Normal"}}, true, {})
    else
      vim.api.nvim_echo({{"No change to root directory", "Normal"}}, true, {})
    end
  end
end

local function setup(cfg_tbl)
  if cfg_tbl['default_source'] ~= nil and type(cfg_tbl['default_source']) == 'table' then
    default_source(cfg_tbl['default_source'])
  end
  if cfg_tbl['prompt'] ~= nil and type(cfg_tbl['prompt']) == 'boolean' then
    prompt = cfg_tbl['prompt']
  end
end

return {
  origin = origin,
  set_root = set_root,
  setup = setup,
}
