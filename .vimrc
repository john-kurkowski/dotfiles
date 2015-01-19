runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" == c-l escapes and saves, avoid the pinky stretch
vmap <C-l> <Esc><Cr>
imap <C-l> <Esc>l
map <c-l> <Esc>
"while selecting (for use in snippets c-l cancels out)
smap <C-l> <Esc>
" While commanding
cmap <C-l> <C-c>

syntax enable
set background=dark
colorscheme flatlandia

highlight clear SignColumn
call gitgutter#highlight#define_highlights()

set hlsearch
" Clear search highlight when escape is pressed.
" Is really horrible on terminals.
if has("gui_running")
  nnoremap <esc> :noh<return><esc>
endif

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
set switchbuf+=usetab,newtab
let mapleader = ","
let g:ctrlp_user_command = ['git ls-files -oc --exclude-standard .', 'find %s -type f']
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = ''
filetype plugin indent on
set ofu=syntaxcomplete#Complete

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
