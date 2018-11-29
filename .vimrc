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
Plug 'ap/vim-css-color', { 'for': ['css', 'sass', 'scss'] }
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'altercation/vim-colors-solarized'
Plug 'Chiel92/vim-autoformat'
Plug 'christoomey/vim-tmux-navigator'
Plug 'cocopon/iceberg.vim'
Plug 'dominickng/fzf-session.vim'
Plug 'duggiefresh/vim-easydir'
Plug 'editorconfig/editorconfig-vim'
Plug 'ElmCast/elm-vim', { 'for': ['elm'] }
Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'sass', 'scss'] }
Plug 'john-kurkowski/ingo-library'
  Plug 'wincent/loupe'
  Plug 'john-kurkowski/SearchHighlighting'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }
Plug 'junegunn/vim-peekaboo'
Plug 'justinmk/vim-sneak'
Plug 'leafgarland/typescript-vim', { 'for': ['typescript'] }
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'majutsushi/tagbar'
Plug 'mustache/vim-mustache-handlebars'
Plug 'mxw/vim-jsx'
Plug 'osyo-manga/vim-over'
Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }
Plug 'Quramy/tsuquyomi', { 'for': ['typescript'] }
Plug 'rickhowe/diffchar.vim'
Plug 'shime/vim-livedown'
Plug 'sjl/gundo.vim'
Plug 'sodapopcan/vim-ifionly'
Plug 'sodapopcan/vim-twiggy'
Plug 'IngoHeimbach/vim-tags'
Plug 'itchyny/lightline.vim'
Plug 'tommcdo/vim-fubitive'
Plug 'tommcdo/vim-fugitive-blame-ext'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown', { 'for': ['markdown'] }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-utils/vim-husk'
Plug 'w0rp/ale'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --js-completer --rust-completer' }
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
set directory=~/.vim/swp//
set hidden
set lazyredraw
set nocompatible
set nojoinspaces
set number
set ofu=syntaxcomplete#Complete
set relativenumber
set sessionoptions-=curdir " Increase session compatbility with vim-rooter
set showtabline=2
set splitright
set switchbuf=useopen,usetab
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
let g:ale_fixers = {
\   'javascript': ['eslint'],
\}
let g:ale_linters = {
\   'html': [],
\   'python': ['pycodestyle', 'pylint'],
\   'typescript': ['tslint', 'tsserver'],
\}

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
\       [ 'gitbranch', 'readonly', 'relativepath', 'modified' ]
\     ],
\     'right': [
\       [ 'lineinfo' ],
\       [ 'linter_warnings', 'linter_errors', 'linter_ok' ],
\     ],
\   },
\   'component': {
\     'lineinfo': '%-2v',
\   },
\   'component_expand': {
\     'linter_warnings': 'LightlineLinterWarnings',
\     'linter_errors': 'LightlineLinterErrors',
\     'linter_ok': 'LightlineLinterOK'
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
\       [ 'relativepath' ],
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
function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction
function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction
function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction
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
autocmd User ALELint call lightline#update()

" QFEnter
let g:qfenter_vopen_map = ['<C-v>']
let g:qfenter_hopen_map = ['<C-x>']
let g:qfenter_topen_map = ['<C-t>']

" fzf.vim
let g:fzf_buffers_jump = 1
let g:fzf_session_path = '~/.vim/session//'

command! -bang -nargs=* Grep
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

" Tsuquyomi

let g:tsuquyomi_disable_quickfix = 1
map <silent> <S-F12> <Plug>(TsuquyomiReferences)

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

" vim-rooter
let g:rooter_silent_chdir = 1

" vim-sneak
let g:sneak#label = 1

" vim-yankstack
let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y']
nmap p <Plug>yankstack_substitute_older_paste
nmap P <Plug>yankstack_substitute_newer_paste

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
