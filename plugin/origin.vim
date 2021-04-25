if exists("g:loaded_origin")
  finish
endif

let g:loaded_origin=1

command! -nargs=0 Origin lua require('origin').origin()
command! -nargs=? -complete=dir OriginSetRoot lua require('origin').set_root("<args>")

call execute("OriginSetRoot " . "%:p:h")
