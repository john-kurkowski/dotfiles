" -------------------------
" Plugins
" -------------------------

" Much of my Vim setup relies on plugins, managed by vim-plug. Ensure vim-plug
" is installed on Vim startup.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" List plugins I use
call plug#begin()

Plug 'ap/vim-css-color', { 'for': ['css', 'sass', 'scss'] }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'bronson/vim-visual-star-search'
Plug 'Chiel92/vim-autoformat'
Plug 'christoomey/vim-tmux-navigator'
Plug 'danhart/flatlandia'
Plug 'editorconfig/editorconfig-vim'
Plug 'edkolev/tmuxline.vim'
Plug 'ervandew/supertab'
Plug 'int3/vim-extradite'
Plug 'gcorne/vim-sass-lint', { 'for': ['sass', 'scss'] }
Plug 'godlygeek/csapprox'
Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'sass', 'scss'] }
Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }
Plug 'junegunn/vim-peekaboo'
Plug 'justinmk/vim-sneak'
Plug 'kchmck/vim-coffee-script', { 'for': ['coffee'] }
Plug 'lukaszkorecki/workflowish'
Plug 'mustache/vim-mustache-handlebars', { 'for': ['hbs', 'handlebars', 'html.handlebars'] }
Plug 'ntpeters/vim-airline-colornum'
Plug 'osyo-manga/vim-over'
Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }
Plug 'scrooloose/syntastic'
Plug 'shime/vim-livedown'
Plug 'szw/vim-tags'
Plug 'terryma/vim-multiple-cursors'
Plug 'tommcdo/vim-fubitive'
Plug 'tommcdo/vim-fugitive-blame-ext'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown', { 'for': ['markdown'] }
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/gitignore'
Plug 'vim-utils/vim-husk'

call plug#end()

" Install missing plugins on Vim startup
autocmd VimEnter *
  \  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall | q
  \| endif

" -------------------------
" Color
" -------------------------

set background=dark
colorscheme flatlandia

highlight clear SignColumn
call gitgutter#highlight#define_highlights()

" -------------------------
" Search
" -------------------------

set hlsearch
" Clear search highlight on opposite of /
noremap \ :noh<return>
" Clear search highlight when escape is pressed.
" Is really horrible on terminals.
if has("gui_running")
  nnoremap <esc> :noh<return><esc>
endif

" -------------------------
" Various Vim options
" -------------------------

set backupcopy=yes
set breakindent
set ignorecase
set laststatus=2
set mouse=a
set nocompatible
set nojoinspaces
set number
set relativenumber
set ruler
set showtabline=2
set splitright
set switchbuf+=usetab,newtab

if has("gui_running")
  set guifont=Meslo\ LG\ M\ DZ\ for\ Powerline
  set guioptions-=e
  set guioptions-=T
  set macmeta
endif

let mapleader = ","

" -------------------------
" Vim plugin options
" -------------------------

let g:airline_powerline_fonts = 1
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_nr_type = 2

let g:ctrlp_user_command = ['.git/', 'git ls-files -oc --exclude-standard %s']
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = ''
set ofu=syntaxcomplete#Complete

let g:extradite_showhash = 1

let g:sneak#streak = 1

let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_html_checkers=['']
let g:syntastic_javascript_checkers = ['jscs', 'jshint']
let g:syntastic_sass_checkers = ['sass_lint']
let g:syntastic_scss_checkers = ['sass_lint']

" -------------------------
" Spelling
" -------------------------

highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline
au FileType gitcommit,markdown setl spell

" -------------------------
" Autocommands
" -------------------------

" Strip trailing whitespace
" TODO: can EditorConfig do this for me? In case a project doesn't use
"       EditorConfig, can I use a global dotfile?
au BufWritePre * :%s/\s\+$//e

" Source session in current directory, if `vim` launched without args
augroup sourcesession
  autocmd!
  autocmd VimEnter * nested
    \ if !argc() && empty(v:this_session) && filereadable('Session.vim') |
    \   source Session.vim |
    \ endif
augroup END

" -------------------------
" Custom Bindings
" -------------------------

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
