
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
