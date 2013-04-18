syntax enable
set background=dark
colorscheme desert

set hlsearch
set ts=2
set nocompatible
set laststatus=2
set autoindent
set expandtab
set ignorecase
set number
set ruler
set wildignore+=*.class,*.pyc,.svn,.git,*/classes/*,*/target/*,*/project/boot/*,*.jar
let mapleader = ","
filetype plugin on
set ofu=syntaxcomplete#Complete

augroup filetypedetect
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
augroup END

au BufWritePre * :%s/\s\+$//e
au BufWritePost *.coffee,*.java,*.js,*.php,*.py,*.rb,*.scala silent! !ctags -R &

map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

execute pathogen#infect()
