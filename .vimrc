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
Plug 'dominickng/fzf-session.vim'
Plug 'ejrichards/mise.nvim'
Plug 'embear/vim-localvimrc'
Plug 'Exafunction/codeium.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'inkarkat/vim-ingo-library'
  Plug 'wincent/loupe'
  Plug 'inkarkat/vim-SearchHighlighting'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }
Plug 'junegunn/vim-peekaboo'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-textobj-user'
Plug 'machakann/vim-highlightedyank'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'maximbaz/lightline-ale'
Plug 'michaeljsmith/vim-indent-object'
if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif
Plug 'osyo-manga/vim-over'
Plug 'preservim/vim-textobj-quote'
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
let g:ale_linter_aliases = {'astro': ['css', 'javascript', 'typescript']}
let g:ale_fixers = {
\   'astro': ['biome', 'eslint', 'stylelint', 'prettier'],
\   'css': ['stylelint', 'biome', 'prettier'],
\   'javascript': ['biome', 'eslint', 'prettier'],
\   'javascriptreact': ['biome', 'eslint', 'prettier'],
\   'json': ['fixjson', 'biome', 'prettier'],
\   'html': ['prettier'],
\   'markdown': ['remark-lint', 'prettier'],
\   'python': ['ruff', 'ruff_format'],
\   'rust': ['rustfmt'],
\   'sh': ['shfmt'],
\   'svelte': ['biome', 'eslint', 'prettier'],
\   'typescript': ['biome', 'eslint', 'prettier'],
\   'typescriptreact': ['biome', 'eslint', 'prettier'],
\   'vue': ['biome', 'eslint', 'prettier'],
\}
" TODO: add tsserver to astro. tsserver seems to parse a whole Astro file as TypeScript.
let g:ale_linters = {
\   'astro': ['biome', 'eslint', 'stylelint'],
\   'css': ['stylelint', 'biome'],
\   'handlebars': ['ember-template-lint', 'glint'],
\   'html': [],
\   'javascript': ['biome', 'eslint', 'tsserver'],
\   'javascriptreact': ['biome', 'eslint', 'tsserver'],
\   'markdown': ['remark-lint'],
\   'python': ['mypy', 'pylsp', 'pyright', 'ruff'],
\   'typescript': ['biome', 'eslint', 'tsserver'],
\   'typescriptreact': ['biome', 'eslint', 'tsserver'],
\   'vue': ['biome', 'eslint', 'vls'],
\}
set omnifunc=ale#completion#OmniFunc

" codeium
let g:codeium_no_map_tab = 1
imap <script><silent><nowait><expr> <M-Tab> codeium#Accept()

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

" mise.nvim
if has('nvim')
  lua require('mise').setup()
endif

" vim-rooter
let g:rooter_patterns = [
\  '.git',
\  'Cargo.toml',
\  'Gemfile',
\  'Makefile',
\  'package.json',
\  'pyvenv.cfg',
\]
let g:rooter_silent_chdir = 1

" vim-sneak
let g:sneak#label = 1

" Treesitter

if has('nvim')
lua <<EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = {
      "astro",
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

  require("nvim-treesitter.parsers").get_parser_configs().just = {
    install_info = {
      url = "https://github.com/IndianBoy42/tree-sitter-just",
      files = { "src/parser.c", "src/scanner.cc" },
      branch = "main",
      use_makefile = true,
    },
    maintainers = { "@IndianBoy42" },
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
