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

function M.cmd(cmds)
  for cmd_name, cmd in pairs(cmds) do
    local cmd_construct = 'command! '

    if cmd.nargs ~= nil then
      cmd_construct = cmd_construct..'-nargs='..cmd.nargs..' '
    end

    if cmd.complete ~= nil then
      cmd_construct = cmd_construct..'-complete='..cmd.complete..' '
    end

    if cmd.range ~= nil then
      cmd_construct = cmd_construct..'-range='..cmd.range..' '
    end

    if cmd.addr ~= nil then
      cmd_construct = cmd_construct..'-addr='..cmd.addr..' '
    end

    if cmd.bang ~= nil and cmd.bang == true then
      cmd_construct = cmd_construct..'-bang '
    end

    if cmd.bar ~= nil and cmd.bar == true then
      cmd_construct = cmd_construct..'-bar '
    end

    if cmd.register ~= nil and cmd.register == true then
      cmd_construct = cmd_construct..'-register '
    end

    if cmd.buffer ~= nil and cmd.buffer == true then
      cmd_construct = cmd_construct..'-buffer '
    end

    if cmd_name == nil then
      vim.api.nvim_err_writeln('fatal: command name needed')
    else
      cmd_construct = cmd_construct..cmd_name..' '
    end

    if cmd.cmd == nil then
      vim.api.nvim_err_writeln('fatal: actual command sequence needed')
    else
      cmd_construct = cmd_construct..cmd.cmd
    end

    vim.api.nvim_exec(cmd_construct, false)
  end
end

function M.augroup(aug_name, autocmds)
  local aug_construct = 'augroup '..aug_name
  local aug_end = 'augroup END'

  aug_construct = aug_construct..'\n'
  aug_construct = aug_construct..'\t'..'autocmd!'
  aug_construct = aug_construct..'\n'
  for _, autocmd in ipairs(autocmds) do
    aug_construct = aug_construct..'\t'..autocmd
    aug_construct = aug_construct..'\n'
  end
  aug_construct = aug_construct..aug_end

  vim.api.nvim_exec(aug_construct, false)
end

function M.autocmd(event, pat, cmd)
  if event ~= nil and pat ~= nil and cmd ~= nil then
    return 'autocmd '..event..' '..pat..' '..cmd
  end
end

return M
