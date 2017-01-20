" -------------------------
" Plugins
" -------------------------

" Much of my Vim setup relies on plugins, managed by vim-plug. Ensure vim-plug
" is installed on Vim startup.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" List plugins I use
call plug#begin()

Plug 'ap/vim-css-color', { 'for': ['css', 'sass', 'scss'] }
Plug 'ctrlpvim/ctrlp.vim', has('gui_running') ? {} : { 'on': [] }
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'bronson/vim-visual-star-search'
Plug 'Chiel92/vim-autoformat'
Plug 'christoomey/vim-tmux-navigator'
Plug 'danhart/flatlandia'
Plug 'editorconfig/editorconfig-vim'
Plug 'edkolev/tmuxline.vim'
Plug 'ElmCast/elm-vim', { 'for': ['elm'] }
Plug 'ervandew/supertab'
Plug 'int3/vim-extradite'
Plug 'gcorne/vim-sass-lint', { 'for': ['sass', 'scss'] }
Plug 'godlygeek/csapprox'
Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'sass', 'scss'] }
Plug '/usr/local/opt/fzf', has('gui_running') ? { 'on': [] } : {} | Plug 'junegunn/fzf.vim', has('gui_running') ? { 'on': [] } : {}
Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }
Plug 'junegunn/vim-peekaboo'
Plug 'justinmk/vim-sneak'
Plug 'kchmck/vim-coffee-script', { 'for': ['coffee'] }
Plug 'lukaszkorecki/workflowish'
Plug 'mustache/vim-mustache-handlebars', { 'for': ['hbs', 'handlebars', 'html.handlebars'] }
Plug 'ntpeters/vim-airline-colornum'
Plug 'osyo-manga/vim-over'
Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }
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
Plug 'w0rp/ale'
Plug 'wincent/ferret'
Plug 'wincent/loupe'
Plug 'wincent/terminus'

call plug#end()

" Install missing plugins on Vim startup
autocmd VimEnter *
  \  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" -------------------------
" Color
" -------------------------

set background=dark
colorscheme flatlandia

highlight clear SignColumn
call gitgutter#highlight#define_highlights()

" -------------------------
" Various Vim options
" -------------------------

set backupcopy=yes
set backupdir=~/.vim/backup//
set breakindent
set directory=~/.vim/swp//
set laststatus=2
set nocompatible
set nojoinspaces
set number
set ofu=syntaxcomplete#Complete
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

if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading\ --with-filename
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

let mapleader = ","
let maplocalleader = ","

" -------------------------
" Vim plugin options
" -------------------------
"

" vim-airline
let g:airline_extensions = ['ale', 'branch', 'tabline', 'tmuxline']
let g:airline_powerline_fonts = 1
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_nr_type = 2

" Fuzzy find
if has("gui_running")
  " ctrlp.vim
  let g:ctrlp_user_command = ['.git/', 'git ls-files -oc --exclude-standard %s']
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_working_path_mode = ''
else
  " fzf.vim
  command! -bang -nargs=* Grep
    \ call fzf#vim#grep('rg --column --hidden --line-number --no-heading --color=always ' . <q-args> . ' | tr -d "\017"', 1, <bang>0)

  " Simulate ctrlp.vim with fzf.vim.
  map <C-P> :GFiles -oc --exclude-standard<CR>
endif

" vim-extradite
let g:extradite_showhash = 1

" vim-sneak
let g:sneak#streak = 1

" -------------------------
" Language specific
" -------------------------

let g:elm_format_autosave = 1

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
