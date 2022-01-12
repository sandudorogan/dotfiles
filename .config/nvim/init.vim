let g:mapleader = " "
let g:maplocalleader = "\<Space>"


call plug#begin('~/.local/share/nvim/site/plugged')
    " Plug 'junegunn/seoul256.vim'
    " Plug 'dylanaraps/wal.vim'
    Plug 'romgrk/doom-one.vim'
    Plug 'junegunn/goyo.vim'

    " Plug 'itchyny/lightline.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'edkolev/tmuxline.vim'

    Plug 'jmcantrell/vim-virtualenv'

    Plug 'andymass/vim-matchup'
    Plug 'preservim/nerdcommenter'
    " Plug 'airblade/vim-gitgutter'                                      Shows change status on the left. [c; ]c; <leader>hs; <leader>hu;
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'                                            " Advanced .
    Plug 'tpope/vim-fugitive'                                          " :Git commands
    Plug 'tpope/vim-rhubarb'                                           " :GBrowse
    Plug 'jiangmiao/auto-pairs'                                        " Intuitive brackets management
    Plug 'luochen1990/rainbow'                                         " Rainbow parens 
    Plug 'yuttie/comfortable-motion.vim'

    Plug 'ncm2/float-preview.nvim'
    " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    Plug 'lambdalisue/glyph-palette.vim'
    Plug 'mbbill/undotree'
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    " Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'scrooloose/nerdtree-project-plugin'
    Plug 'PhilRunninger/nerdtree-visual-selection'
    Plug 'haya14busa/incsearch.vim'
    Plug 'machakann/vim-highlightedyank'

    Plug 'sheerun/vim-polyglot'                                        " Code coloring

    " Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release', 'for': 'clojure'}
    Plug 'clojure-vim/clojure.vim', {'for': 'clojure'}
    Plug 'tpope/vim-fireplace', {'for': 'clojure'}
    Plug 'guns/vim-clojure-highlight', {'for': 'clojure'}
    Plug 'guns/vim-sexp', {'for': 'clojure'}
    Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}

    Plug 'tpope/vim-dispatch'
    Plug 'radenling/vim-dispatch-neovim'
    Plug 'clojure-vim/vim-jack-in', {'for': 'clojure'}
    " Plug 'Olical/conjure', {'for': 'clojure'}

    Plug 'neoclide/coc.nvim', {'branch': 'release'}                    " Language servers

    Plug 'ryanoasis/vim-devicons'                                      " Load devicons the last
    " Plug 'adelarsq/vim-devicons-emoji'

call plug#end()


source ~/.config/nvim/general/settings.vim
source ~/.config/nvim/general/functions.vim
source ~/.config/nvim/general/shortcuts.vim

" vim: set syntax=vim:
