command! LivedownPreview :call s:LivedownPreview()
command! LivedownKill :call s:LivedownKill()
command! LivedownToggle :call s:LivedownToggle()

if !exists('g:livedown_autorun')
  let g:livedown_autorun = 0
endif

if !exists('g:livedown_open')
  let g:livedown_open = 1
endif

if !exists('g:livedown_port')
  let g:livedown_port = 1337
endif

function! s:LivedownPreview()
  call system("livedown start '" . expand('%:p') . "'" .
        \ (g:livedown_open ? " --open" : "") .
        \ " --port " . g:livedown_port .
        \ " &")
endfunction

function! s:LivedownKill()
  call system("livedown stop --port " . g:livedown_port . " &")
endfunction

function! s:LivedownToggle()
	if !exists('s:livedownPreviewFlag')
		call s:LivedownPreview() | let s:livedownPreviewFlag = 1
	else
		call s:LivedownKill() | unlet! s:livedownPreviewFlag
	endif
endfunction
