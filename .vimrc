" --------------------------------- Vim Plug ---------------------------------

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')
    Plug 'junegunn/seoul256.vim'
    Plug 'junegunn/goyo.vim'

    Plug 'itchyny/lightline.vim'

    Plug 'jiangmiao/auto-pairs'
    Plug 'andymass/vim-matchup'
    Plug 'preservim/nerdcommenter'
    " Shows change status on the left. [c; ]c; <leader>hs; <leader>hu;
    Plug 'airblade/vim-gitgutter'                                      
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    " Color colornames and codes (green -> :ColorHighlight)
    Plug 'chrisbra/Colorizer'                                          
    Plug 'tpope/vim-surround'
    " Advanced .
    Plug 'tpope/vim-repeat'                                            
    " :Git commands
    Plug 'tpope/vim-fugitive'                                          
    " :GBrowse
    Plug 'tpope/vim-rhubarb'                                           
    " Language servers
    Plug 'neoclide/coc.nvim', {'branch': 'release'}                    
    Plug 'mbbill/undotree'

    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'ryanoasis/vim-devicons'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'scrooloose/nerdtree-project-plugin'
    Plug 'PhilRunninger/nerdtree-visual-selection'

    " Code coloring
    Plug 'sheerun/vim-polyglot'                                        

    Plug 'tpope/vim-fireplace'
    Plug 'guns/vim-clojure-static'
    Plug 'guns/vim-sexp',    {'for': 'clojure'}
call plug#end()
" Vim Plug --


" --------------------------------- Coc Vim ----------------------------------

let g:coc_global_extensions = [
            \  'coc-json', 
            \  'coc-git', 
            \  'coc-css', 
            \  'coc-tsserver', 
            \  'coc-html', 
            \  'coc-marketplace', 
            \  'coc-pyright', 
            \  'coc-sh'
            \ ]
autocmd FileType json syntax match Comment +\/\/.\+$+


" ----------------------------- General Settings -----------------------------

" Splits open at the bottom and right
set splitbelow splitright
" Enable autocompletion:
set wildmode=longest,list,full
" sync system clipboard w/ unnamed register
set clipboard^=unnamed
set clipboard^=unnamedplus
set encoding=UTF-8
set title
" show line numbers
set number
" Alacritty pseudo fix for mouse
set ttymouse=sgr
" set tabs to have 4 spaces
set ts=4 softtabstop=4
" indent when moving to the next line while writing code
set autoindent
" expand tabs into spaces
set expandtab
" Reload unedited, externally changed files. 
set autoread
set smartindent
" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4
" show a visual line under the cursor's current line
" set cursorline
" show the matching part of the pair for [] {} and ()
set showmatch
" Fixing fish issues
set shell=sh
set number relativenumber
" Polignot requirement
set nocompatible
set laststatus=2
set noshowmode
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
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

let mapleader =" "

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

" Ensure files are read as what I want:
let g:vimwiki_ext2syntax = {
            \  '.Rmd': 'markdown', 
            \  '.rmd': 'markdown',
            \  '.md': 'markdown', 
            \  '.markdown': 'markdown', 
            \  '.mdown': 'markdown'
            \ }
let g:vimwiki_list = [
            \  {
            \   'path': '~/vimwiki', 
            \   'syntax': 'markdown', 
            \   'ext': '.md'
            \  }
            \ ]
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile ~/.config/i3/config set filetype=i3config
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex


" --------------------------- Keyboard shortcuts -----------------------------

" Function for toggling the bottom statusbar:
let s:hidden_all = 1
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction

nnoremap <leader>h :call ToggleHiddenAll()<CR>
nnoremap <leader>u :UndotreeToggle<CR>
" Perform dot commands over visual blocks:
vnoremap . :normal .<CR>
 
" FZF:
map <C-p> :Files<CR>

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>

" Nerd tree
map <leader>n :NERDTreeToggle<CR>

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocActionAsync('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" ------------------------------ Nerd Commenter ------------------------------

" Create default mappings
let g:NERDCreateDefaultMappings = 1
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 0
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1
" Nerd Commenter --


" -------------------------------- Nerd Tree --------------------------------

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
if has('nvim')
    let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
else
    let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
endif
let NERDTreeIgnore=['__pycache__[[dir]]']


" -------------------------------- Light Line --------------------------------

let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'currentfunction' ],
      \             [ 'readonly', 'filename', 'modified', 'gitstatus' ] ]
      \ },
      \ 'component': {
      \   'currentfunction': "%{get(b:,'coc_current_function','')}"
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'gitstatus': 'fugitive#statusline'
      \ },
      \ }


