-- origin.lua
-- TODO:
--    neovim should have an option to call similar api func to getcwd()
--      - littleclover  Fri 12 Mar 2021 08:22:16 PM +08
local root = vim.fn.getcwd()

local function origin()
  vim.api.nvim_echo({{root, "Normal"}}, false, {})
end

local function set_root(dir)
  if dir == nil or dir == '' then
    dir = vim.fn.expand("%:p:h")
  end

  vim.api.nvim_set_current_dir(dir)
  root = vim.fn.expand(dir)
  vim.api.nvim_echo({{"Change root directory to `"..root.."`", "Normal"}}, true, {})
end

return {
  origin = origin,
  set_root = set_root,
}
