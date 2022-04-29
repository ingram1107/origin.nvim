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
local vim_set = require('origin.utils')

if vim.version().minor < 7 then
  vim.api.nvim_err_writeln('fatal: origin: require Neovim version 0.7+')
  return
end

local M = {}

local ft_table = {}
local root = vim.loop.cwd()
local prompt = true

function M.origin()
  vim.api.nvim_echo({ { root, 'Normal' } }, false, {})
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

local function retrieve_match_token(ds, full_path)
  local path_tail, match_relative_path, match_val
  local offset, endpoint = string.find(full_path, '/' .. ds .. '$')

  if offset ~= nil then
    path_tail = string.sub(full_path, offset + 1)
  else
    path_tail = full_path
  end

  offset = string.find(path_tail, ds .. '/')
  if offset ~= nil then
    match_relative_path = string.sub(path_tail, offset)
  else
    match_relative_path = path_tail
  end

  offset, endpoint = string.find(match_relative_path, ds .. '/')
  if offset ~= nil then
    match_val = string.sub(match_relative_path, offset, endpoint - 1)
  else
    match_val = match_relative_path
  end

  return path_tail, match_val
end

local function find_match_source(dir)
  local val_or_tab = ft_table[vim.bo.filetype]
  local nested = false
  local path_tail, match_val
  local full_path = vim.fn.expand(dir)
  if type(val_or_tab) ~= 'table' then
    local ds = val_or_tab

    if ds ~= nil then
      path_tail, match_val = retrieve_match_token(ds, full_path)

      if ds == path_tail then
        return ds, nested
      elseif ds == match_val then
        nested = true
        return ds, nested
      end
    end

    return ds, nested
  end

  local tab = val_or_tab
  for _, ds in pairs(tab) do
    path_tail, match_val = retrieve_match_token(ds, full_path)

    if ds == path_tail then
      return ds, nested
    elseif ds == match_val then
      nested = true
      return ds, nested
    end
  end

  return nil
end

function M.set_root(args)
  setmetatable(args, { __index = { manual = false } })
  local dir, manual = args[1] or args.dir, args[2] or args.manual

  if dir == nil or dir == '' then
    dir = vim.fn.expand('%:p:h')
  end

  local dir_full_path = vim.fn.expand(dir)

  if not manual then
    local ds, nested = find_match_source(dir)

    if ds ~= nil or ds == '' then
      local offset
      local target

      if not nested then
        offset = string.find(dir_full_path, ds .. '$')

        if offset ~= nil then
          target = string.sub(dir_full_path, 1, offset - 1)
        else
          target = dir_full_path
        end

        root = is_dir_exist(target)
      else
        offset = string.find(dir_full_path, ds .. '.*')

        if offset ~= nil then
          target = string.sub(dir_full_path, 1, offset - 1)
        else
          target = dir_full_path
        end

        root = is_dir_exist(target)
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

  root = vim.loop.cwd()

  if prompt == true then
    if root ~= nil then
      vim.api.nvim_echo({ { 'Change root directory to `' .. root .. '`', 'Normal' } }, true, {})
    else
      vim.api.nvim_echo({ { 'No change to root directory', 'Normal' } }, true, {})
    end
  end
end

function M.setup(cfg_tbl)
  if cfg_tbl['default_source'] ~= nil and type(cfg_tbl['default_source']) == 'table' then
    default_source(cfg_tbl['default_source'])
  end

  if cfg_tbl['prompt'] ~= nil and type(cfg_tbl['prompt']) == 'boolean' then
    prompt = cfg_tbl['prompt']
  end

  if not vim_set.loaded_origin() then
    vim.g.autochdir = vim_set.set_autochdir()

    vim.api.nvim_create_user_command('Origin', M.origin, { nargs = 0 })
    vim.api.nvim_create_user_command('OriginSetDefaultRoot', function(args)
      M.set_root({ args.args })
    end, { nargs = '?', complete = 'dir' })
    vim.api.nvim_create_user_command('OriginSetManualRoot', function(args)
      M.set_root({ args.args, true })
    end, { nargs = '?', complete = 'dir' })

    vim.api.nvim_create_augroup('Origin', {})
    vim.api.nvim_create_autocmd('VimEnter', {
      pattern = '*',
      command = 'OriginSetDefaultRoot %:p:h',
    })
  end
end

return M
