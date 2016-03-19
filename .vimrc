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

set nocompatible
set laststatus=2
set autoindent
set nojoinspaces
set ignorecase
set number
set ruler
set wildignore+=*.class,*.pyc,.svn,*/classes/*,*/target/*,*/project/boot/*,*.jar
set backupcopy=yes
set switchbuf+=usetab,newtab

if has("gui_running")
  set guifont=Input\ Mono
  set guioptions-=T
  set guioptions-=e
  set macmeta
endif

let mapleader = ","
let g:ctrlp_user_command = ['.git/', 'git ls-files -oc --exclude-standard %s']
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = ''
filetype plugin indent on
set ofu=syntaxcomplete#Complete

let g:syntastic_aggregate_errors = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['jscs', 'jshint']
let g:syntastic_sass_checkers = ['sass_lint']
let g:syntastic_scss_checkers = ['sass_lint']

au FileType gitcommit,markdown setl spell

au BufWritePre * :%s/\s\+$//e

autocmd FileType go autocmd BufWritePre <buffer> Fmt
autocmd FileType go compiler go

nnoremap <Leader>fr :call VisualFindAndReplace()<CR>
xnoremap <Leader>fr :call VisualFindAndReplaceWithSelection()<CR>

function! VisualFindAndReplace()
    :OverCommandLine%s/
endfunction
function! VisualFindAndReplaceWithSelection() range
    :'<,'>OverCommandLine s/
endfunction
