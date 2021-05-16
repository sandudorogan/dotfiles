" ----------------------------- General Settings -----------------------------


" Splits open at the bottom and right
set splitbelow splitright
" Enable autocompletion:
set wildmode=longest,list,full
" sync system clipboard w/ unnamed register
set clipboard+=unnamedplus
set encoding=UTF-8
set title
" show line numbers
set number
" Alacritty pseudo fix for mouse
if !has('nvim')
    set ttymouse=sgr
endif
" Enable mouse support on all modes
set mouse=a
" indent when moving to the next line while writing code
set autoindent
" expand tabs into spaces
set expandtab
" Reload unedited, externally changed files. 
set autoread
set smartindent
" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4
" set tabs to have 4 spaces
set ts=4 
" equal to shiftwidth
set softtabstop=-1
set smarttab
" show a visual line under the cursor's current line
" set cursorline
" show the matching part of the pair for [] {} and ()
set showmatch
" fish issues
set shell=sh
set number relativenumber
" Polignot requirement
set nocompatible
set laststatus=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
set signcolumn=yes
" Use .vimrc file from current dir
set exrc
" Navigate without saving buffer
set hidden
" Don't wrap lines
" set nowrap
" Highlight searches incrementally
set incsearch
" Scroll with cursor
set scrolloff=8
set cc=80
set nobackup                            
set nowritebackup                      
set termguicolors
set smartcase

" enable syntax highlighting
syntax enable
syntax on

" indent based on plugin/filetype
filetype plugin indent on

autocmd FileType python let g:black_linelength = 79         " max file length

" save file position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" enable all python syntax highlighting features
let python_highlight_all = 1

" Color scheme
" seoul256 (dark):
"   Range:   233 (darkest) ~ 239 (lightest)
"   Default: 237
let g:seoul256_background = 234
colo seoul256

" colorscheme wal

" Set transparency
" hi Normal guibg=NONE ctermbg=NONE

" Ensure file extension:
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile ~/.config/i3/config set filetype=i3config
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex

