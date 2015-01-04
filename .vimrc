runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

syntax enable
set background=dark
colorscheme flatlandia

set hlsearch
set tabstop=2
set shiftwidth=2
set nocompatible
set laststatus=2
set autoindent
set expandtab
set nojoinspaces
set ignorecase
set number
set ruler
set wildignore+=*.class,*.pyc,.svn,*/classes/*,*/target/*,*/project/boot/*,*.jar
set backupcopy=yes
let mapleader = ","
let g:ctrlp_custom_ignore = '\.git$'
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = ''
filetype plugin indent on
set ofu=syntaxcomplete#Complete

augroup filetypedetect
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
augroup END

au FileType gitcommit,markdown setl spell
au FileType python setl ts=4 sw=4

au BufWritePre * :%s/\s\+$//e

autocmd FileType go autocmd BufWritePre <buffer> Fmt
autocmd FileType go compiler go

let g:easytags_dynamic_files = 1
let g:easytags_file = '~/.vim/easytags'
let g:easytags_updatetime_min = 30000

map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" For local replace
nnoremap gr gd[{V%:s/<C-R>///gc<left><left><left>
nnoremap gR :s/<C-R>///gc<left><left><left>
