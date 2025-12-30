" -------------------------
" Plugins
" -------------------------

" Plugins are managed by lazy.nvim.
" See ~/.config/nvim/init.lua and ~/.config/nvim/lua/plugins/

" -------------------------
" Color
" -------------------------

set background=dark
set cursorline
set cursorlineopt=number
colorscheme iceberg

" -------------------------
" Various Vim options
" -------------------------

set backupcopy=yes
set backupdir=~/.vim/backup//
set breakindent
set completeopt=menu,menuone,preview,noselect,noinsert
set directory=~/.vim/swp//
set hidden
set lazyredraw
set linebreak
set nocompatible
set nojoinspaces
set number
set relativenumber
set sessionoptions-=curdir " Increase session compatbility with vim-rooter
set showbreak=…
set showtabline=2
set splitright
set switchbuf=uselast
set undodir=~/.vim/undodir//
set undofile
set updatetime=100

if has("gui_running")
  set guifont=MesloLGMDZ\ Nerd\ Font
  set guioptions-=e
  set guioptions-=T
  set macmeta
endif

" Speed up startup with a Vim-dedicated virtualenv.
"
" Create it with the following. For more info, see :help python-virtualenv.
"
" ```sh
" python -m venv ~/.cache/py3nvim
" ~/.cache/py3nvim/bin/python -m pip install pynvim
" ```
let g:python3_host_prog="~/.cache/py3nvim/bin/python"

" -------------------------
" Spelling
" -------------------------

autocmd FileType gitcommit,markdown setl spell

" -------------------------
" Custom Bindings
" -------------------------

" Ease window switching in all directions. Inspired by vim-tmux-navigator,
" although I don't use tmux.
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Find/replace with visual feedback. Courtesy vim-over &
" https://github.com/toranb/dotfiles/blob/46ae158e51dbdbba72e284081dc9a12b5e54ef8c/vimrc#L130
nnoremap <Leader>fr :call VisualFindAndReplace()<CR>
xnoremap <Leader>fr :call VisualFindAndReplaceWithSelection()<CR>
function! VisualFindAndReplace()
    :OverCommandLine%s/
endfunction
function! VisualFindAndReplaceWithSelection() range
    :'<,'>OverCommandLine s/
endfunction
