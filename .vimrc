syntax enable
set background=dark
colorscheme desert

set hlsearch
set ts=4
set autoindent
set expandtab
set ignorecase
set number
set ruler
set wildignore+=*.class,*.pyc,.svn,.git,*/classes/*,*/target/*,*/project/boot/*
let mapleader = ","
filetype plugin on

augroup filetypedetect 
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig 
augroup END 

au BufWritePost *.java,*.js,*.php,*.py,*.rb,*.scala silent! !ctags -R &
