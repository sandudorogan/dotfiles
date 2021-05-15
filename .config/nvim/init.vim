let g:mapleader = "\<Space>"


call plug#begin('~/.local/share/nvim/site/plugged')
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


source ~/.config/nvim/general/settings.vim
source ~/.config/nvim/general/functions.vim
source ~/.config/nvim/general/shortcuts.vim
