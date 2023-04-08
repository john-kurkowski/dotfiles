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
Plug 'Asheq/close-buffers.vim'
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'andymass/vim-matchup'
Plug 'ap/vim-css-color'
Plug 'cocopon/iceberg.vim'
Plug 'dense-analysis/ale'
Plug 'direnv/direnv.vim'
Plug 'dominickng/fzf-session.vim'
Plug 'EdenEast/nightfox.nvim'
Plug 'editorconfig/editorconfig-vim'
Plug 'github/copilot.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'IndianBoy42/tree-sitter-just'
Plug 'inkarkat/vim-ingo-library'
  Plug 'wincent/loupe'
  Plug 'inkarkat/vim-SearchHighlighting'
Plug 'itchyny/lightline.vim'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }
Plug 'junegunn/vim-peekaboo'
Plug 'justinmk/vim-sneak'
Plug 'machakann/vim-highlightedyank'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'maximbaz/lightline-ale'
Plug 'michaeljsmith/vim-indent-object'
if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif
Plug 'osyo-manga/vim-over'
Plug 'rickhowe/diffchar.vim'
if !has('nvim')
  Plug 'sheerun/vim-polyglot'
endif
Plug 'sjl/gundo.vim'
Plug 'sodapopcan/vim-ifionly'
Plug 'tommcdo/vim-fugitive-blame-ext'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
if !has('nvim')
  Plug 'tpope/vim-sleuth'
endif
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-utils/vim-husk'
Plug 'wellle/targets.vim'
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
set cursorline
set cursorlineopt=number
if has('nvim')
  colorscheme nightfox
else
  colorscheme iceberg
endif

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
  set guifont=Meslo\ LG\ M\ DZ\ Regular\ Nerd\ Font\ Complete
  set guioptions-=e
  set guioptions-=T
  set macmeta
endif

" Speed up startup with a Vim-dedicated virtualenv. Follow setup instructions
" in :help python-virtualenv.
let g:python3_host_prog="~/.pyenv/versions/py3nvim/bin/python"

let mapleader = ","
let maplocalleader = ","

" -------------------------
" Vim plugin options
" -------------------------
"

" ale
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_floating_preview = 1
let g:ale_floating_window_border = [' ', ' ', ' ', ' ', ' ', ' ']
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"
map <leader>u :ALEFindReferences<CR>
nnoremap <M-LeftMouse> <LeftMouse>:ALEGoToDefinition<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> gds :ALEGoToDefinition -split<CR>
nnoremap <silent> gdt :ALEGoToDefinition -tab<CR>
nnoremap <silent> gdv :ALEGoToDefinition -vsplit<CR>
nnoremap <silent> gk :ALEDetail<CR>
let g:ale_fixers = {
\   'css': ['stylelint'],
\   'javascript': ['eslint', 'prettier', 'prettier_standard'],
\   'json': ['fixjson', 'prettier'],
\   'html': ['prettier'],
\   'python': ['black'],
\   'rust': ['rustfmt'],
\   'sh': ['shfmt'],
\   'svelte': ['eslint', 'prettier', 'standard'],
\   'typescript': ['eslint', 'prettier'],
\   'vue': ['eslint', 'prettier'],
\}
let g:ale_linters = {
\   'css': ['stylelint'],
\   'handlebars': ['ember-template-lint'],
\   'html': [],
\   'javascript': ['eslint', 'standard', 'tsserver'],
\   'markdown': ['remark-lint'],
\   'python': ['mypy', 'pylsp', 'ruff'],
\   'typescript': ['eslint', 'tsserver'],
\   'vue': ['eslint', 'vls'],
\}
let g:ale_python_black_options = '--preview'
set omnifunc=ale#completion#OmniFunc

" gundo.vim
if has('python3')
  let g:gundo_prefer_python3 = 1
endif

" lightline.vim
"
" Normally this colorscheme should match Vim's colorscheme. However, Nightfox
" doesn't support my custom (linter) components' colors. Use my previous
" colorscheme. (I suspect Nightfox may be missing a few lightline color values
" here
" https://github.com/EdenEast/nightfox.nvim/blob/59c3dbcec362eff7794f1cb576d56fd8a3f2c8bb/lua/nightfox/util/lightline.lua#L35)
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
  let branch = FugitiveHead()
  return branch !=# '' ? ' '.branch : ''
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

" vim-highlightedyank

let g:highlightedyank_highlight_duration = 300

" vim-ifionly

nnoremap L :IfIOnly<CR>

" Markdown
let g:markdown_fenced_languages = [
\  'bash=sh',
\  'css',
\  'handlebars=html',
\  'hbs=html',
\  'html',
\  'javascript',
\  'js=javascript',
\  'json',
\  'rust',
\  'sh',
\  'python',
\  'zsh',
\]

let g:mkdp_auto_close = 1

" vim-rooter
let g:rooter_patterns = [
\  '.git',
\  'Cargo.toml',
\  'Gemfile',
\  'Makefile',
\  'package.json',
\]
let g:rooter_silent_chdir = 1

" vim-sneak
let g:sneak#label = 1

" Treesitter

if has('nvim')
lua <<EOF
  require("tree-sitter-just").setup({})

  require'nvim-treesitter.configs'.setup {
    ensure_installed = {
      "bash",
      "css",
      "glimmer",
      "html",
      "javascript",
      "json",
      "json5",
      "just",
      "make",
      "markdown",
      "python",
      "ruby",
      "rust",
      "scss",
      "svelte",
      "swift",
      "toml",
      "tsx",
      "typescript",
      "vue",
    },
    highlight = {
      enable = true,
    },
    incremental_selection = { enable = true },
    indent = { enable = true },
    matchup = { enable = true },
    textobjects = { enable = true },
  }
EOF
endif

" vim-yankstack
let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y']
nmap p <Plug>yankstack_substitute_older_paste
nmap P <Plug>yankstack_substitute_newer_paste

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
