let b:ale_fix_on_save = 0

augroup textobj_quote
  autocmd!
  autocmd FileType markdown call textobj#quote#init()
augroup END
