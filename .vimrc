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

Plug 'AndrewRadev/splitjoin.vim'
Plug 'andymass/vim-matchup'
Plug 'ap/vim-css-color', { 'for': ['css', 'sass', 'scss'] }
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'cocopon/iceberg.vim'
Plug 'dominickng/fzf-session.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'inkarkat/vim-ingo-library'
  Plug 'wincent/loupe'
  Plug 'inkarkat/vim-SearchHighlighting'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }
Plug 'junegunn/vim-peekaboo'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-textobj-user'
  Plug 'kana/vim-textobj-function'
  Plug 'haya14busa/vim-textobj-function-syntax'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'maximbaz/lightline-ale'
Plug 'michaeljsmith/vim-indent-object'
Plug 'osyo-manga/vim-over'
Plug 'rickhowe/diffchar.vim'
Plug 'sheerun/vim-polyglot'
Plug 'sjl/gundo.vim'
Plug 'sodapopcan/vim-ifionly'
Plug 'itchyny/lightline.vim'
Plug 'tommcdo/vim-fugitive-blame-ext'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-utils/vim-husk'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'wincent/terminus'
Plug 'yssl/QFEnter'

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
set switchbuf=useopen,usetab
set tags^=./.git/tags;
set termguicolors
set undodir=~/.vim/undodir//
set undofile
set updatetime=100

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

" ale
let g:ale_completion_autoimport = 1
let g:ale_completion_enabled = 1
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"
map <leader>u :ALEFindReferences<CR>
nnoremap <M-LeftMouse> <LeftMouse>:ALEGoToDefinition<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> gds :ALEGoToDefinition -split<CR>
nnoremap <silent> gdt :ALEGoToDefinition -tab<CR>
nnoremap <silent> gdv :ALEGoToDefinition -vsplit<CR>
nnoremap <silent> gk :ALEDetail<CR>

" gundo.vim
if has('python3')
  let g:gundo_prefer_python3 = 1
endif

" lightline.vim
let g:lightline = {
\   'colorscheme': 'iceberg',
\   'active': {
\     'left': [
\       [ 'mode', 'paste' ],
\       [ 'gitbranch', 'readonly', 'absolutepath', 'modified' ]
\     ],
\     'right': [
\       [ 'lineinfo' ],
\       [ 'linter_warnings', 'linter_errors', 'linter_ok' ],
\     ],
\   },
\   'component': {
\     'lineinfo': '%c%V',
\   },
\   'component_expand': {
\     'linter_warnings': 'lightline#ale#warnings',
\     'linter_errors': 'lightline#ale#errors',
\     'linter_ok': 'lightline#ale#ok',
\   },
\   'component_function': {
\     'gitbranch': 'LightlineFugitive',
\     'readonly': 'LightlineReadonly',
\   },
\   'component_type': {
\     'linter_warnings': 'warning',
\     'linter_errors': 'error'
\   },
\   'inactive': {
\     'left': [
\       [ 'absolutepath', 'modified' ],
\     ],
\     'right': [
\       [ 'lineinfo' ],
\     ],
\   },
\   'separator': {
\     'left': '',
\     'right': '',
\   },
\   'subseparator': {
\     'left': '',
\     'right': '',
\   },
\}
let g:lightline#ale#indicator_warnings = '◆ '
let g:lightline#ale#indicator_errors = '✗ '
let g:lightline#ale#indicator_ok = '✓'
function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction
function! LightlineFugitive()
  if exists('*fugitive#head')
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

" QFEnter
let g:qfenter_vopen_map = ['<C-v>']
let g:qfenter_hopen_map = ['<C-x>']
let g:qfenter_topen_map = ['<C-t>']

" fzf.vim
let g:fzf_session_path = '~/.vim/session//'

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always ' . <q-args>, 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

map <silent> <Leader>i :Sessions<CR>
" Simulate ctrlp.vim with fzf.vim.
map <silent> <C-P> :Files<CR>
nnoremap <silent> <Leader>p :Buffers<CR>

" vim-ifionly

nnoremap L :IfIOnly<CR>

" Markdown
let g:markdown_fenced_languages = [
\  'bash=sh',
\  'css',
\  'handlebars=mustache',
\  'hbs=mustache',
\  'html',
\  'javascript',
\  'js=javascript',
\  'json',
\  'sh',
\  'python',
\  'zsh',
\]

let g:mkdp_auto_close = 1

" vim-rooter
let g:rooter_patterns = ['.git', 'Makefile', 'package.json']
let g:rooter_silent_chdir = 1

" vim-sneak
let g:sneak#label = 1

" vim-yankstack
let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y']
nmap p <Plug>yankstack_substitute_older_paste
nmap P <Plug>yankstack_substitute_newer_paste

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
