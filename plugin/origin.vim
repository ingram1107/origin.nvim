if !has('nvim-0.5.0') || exists("g:loaded_origin")
  finish
endif

let g:loaded_origin=1

if exists("+autochdir") && &autochdir
  set noautochdir
endif

command! -nargs=0 Origin lua require('origin').origin()
command! -nargs=? -complete=dir OriginSetRoot lua require('origin').set_root("<args>")

call execute("OriginSetRoot " . "%:p:h")
