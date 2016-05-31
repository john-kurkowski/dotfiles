if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin()

Plug 'ap/vim-css-color', { 'for': ['css', 'sass', 'scss'] }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'bronson/vim-visual-star-search'
Plug 'Chiel92/vim-autoformat'
Plug 'danhart/flatlandia'
Plug 'derekwyatt/vim-scala', { 'for': ['scala'] }
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'gcorne/vim-sass-lint', { 'for': ['sass', 'scss'] }
Plug 'groenewege/vim-less', { 'for': ['less'] }
Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'sass', 'scss'] }
Plug 'jnwhiteh/vim-golang', { 'for': ['go'] }
Plug 'justinmk/vim-sneak'
Plug 'kchmck/vim-coffee-script', { 'for': ['coffee'] }
Plug 'leshill/vim-json', { 'for': ['json'] }
Plug 'lukaszkorecki/workflowish'
Plug 'mustache/vim-mustache-handlebars', { 'for': ['hbs', 'handlebars'] }
Plug 'osyo-manga/vim-over'
Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }
Plug 'scrooloose/syntastic'
Plug 'shime/vim-livedown', { 'commit': '9afa391', 'for': ['markdown'] }
Plug 'szw/vim-tags'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-flagship'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown', { 'for': ['markdown'] }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/gitignore'

call plug#end()

autocmd VimEnter *
  \  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall | q
  \| endif

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
set relativenumber
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
runtime macros/matchit.vim
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
