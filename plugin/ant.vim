try
  call vimproc#version()
  let s:exists_vimproc = 1
catch
  let s:exists_vimproc = 0
endtry

function! s:ant(args)
  let l:build_xml = findfile("build.xml", ".;")
  if empty(l:build_xml)
    return
  endif
  let l:build_dir = fnamemodify(l:build_xml, ":p:h")

  let l:command = "ant -buildfile " . l:build_xml . " " . a:args

  if s:exists_vimproc
    let result = vimproc#system(l:command)
  else
    let result = system(l:command)
  endif

  execute ":below " . min([&lines / 2 - 1, 20]) . "new"
  setlocal buftype=nofile noswapfile wrap ft=
  nmap <buffer> q :<c-g><c-u>bw!<cr>
  put! =result
  normal gg
endfunction

command! -nargs=* Ant call s:ant(<q-args>)

