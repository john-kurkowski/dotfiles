syntax enable
set background=dark
colorscheme desert

set hlsearch
set tabstop=2
set shiftwidth=2
set nocompatible
set laststatus=2
set autoindent
set expandtab
set ignorecase
set number
set ruler
set wildignore+=*.class,*.pyc,.svn,.git,*/classes/*,*/target/*,*/project/boot/*,*.jar
set backupcopy=yes
let mapleader = ","
filetype plugin indent on
set ofu=syntaxcomplete#Complete

augroup filetypedetect
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
augroup END

au FileType gitcommit,markdown setl spell
au FileType python setl ts=4 sw=4

au BufWritePre * :%s/\s\+$//e
au BufWritePost *.coffee,*.java,*.js,*.php,*.py,*.rb,*.scala silent! !ctags -R &

map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" For local replace
nnoremap gr gd[{V%:s/<C-R>///gc<left><left><left>
nnoremap gR :s/<C-R>///gc<left><left><left>

execute pathogen#infect()
