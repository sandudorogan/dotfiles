" ----------------------------- General Settings -----------------------------


syntax enable
syntax on

filetype plugin indent on

" set cursorline show a visual line under the cursor's current line
" set exrc Use .vimrc file from current dir
" set nowrap Don't wrap lines
set autoindent " indent when moving to the next line while writing code
set autoread " Reload unedited, externally changed files. 
set cc=80
set encoding=utf-8
set expandtab " expand tabs into spaces
set hidden " Navigate without saving buffer
set history=10000
set incsearch " Highlight search results
set jumpoptions+=stack
set mouse=a " Enable mouse support on all modes
set number " show line numbers
set number relativenumber
set scrolloff=8
set shell=zsh
set shiftwidth=4 " when using the >> or << commands, shift lines by 4 spaces
set shortmess+=c " Don't pass messages to |ins-completion-menu|.
set showmatch " show the matching part of the pair for [] {} and ()
set signcolumn=yes
set smartcase
set smartindent
set smarttab
set softtabstop=-1 " equal to shiftwidth
set splitbelow splitright " Splits open at the bottom and right
set termguicolors
set title
set tabstop=4 " set tabs to have 4 spaces
set updatetime=100

set wildmode=longest,list,full " Enable autocompletion:
set wildmenu
set completeopt=longest,menuone

if !has('nvim')
    set ttymouse=sgr " Alacritty pseudo fix for mouse
endif

autocmd FileType python let g:black_linelength = 79

au FocusLost * silent! wa " save on blur

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " save file position

let python_highlight_all = 1

" Color scheme
" seoul256 (dark):
"   Range:   233 (darkest) ~ 239 (lightest)
"   Default: 237
" let g:seoul256_background = 234
colo doom-one

" colorscheme wal

" Set transparency
" hi Normal guibg=NONE ctermbg=NONE

" Ensure file extension:
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile ~/.config/i3/config set filetype=i3config
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex


let g:python3_host_prog = '/usr/bin/python3'

set clipboard+=unnamedplus " sync system clipboard w/ unnamed register
" WSL system clipboard integration. 
" Uses this helper: https://github.com/equalsraf/win32yank/releases
" Comment when on other systems.
let g:clipboard = {
            \   'name': 'win32yank',
            \   'copy': {
            \      '+': 'win32yank -i --crlf',
            \      '*': 'win32yank -i --crlf',
            \   },
            \   'paste': {
            \      '+': 'win32yank -o --lf',
            \      '*': 'win32yank -o --lf',
            \   },
            \   'cache_enabled': 1,
            \ }

" Automatically reload config on save
if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif " has autocmd
