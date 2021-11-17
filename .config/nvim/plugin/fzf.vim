
" Make rg not search file names
" command! -bang -nargs=* Rg
"   \ call fzf#vim#grep(
"   \ "rg --column --line-number --no-heading --color=always --smart-case --vimgrep".shellescape(<q-args>),
"   \ 1,
"   \ fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}),
"   \ <bang>0
"   \ )

" command! -bang -nargs=* Rg
" \ call fzf#vim#grep(
" \   "rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>),
" \   1,
" \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'})
" \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
" \   <bang>0
" \ ),

" command!      -bang -nargs=* Rg                        call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0),

" " FZF + RG
" command! -bang -nargs=* Rg
" \ call fzf#vim#grep(
" \   'rg --column --line-number --hidden --smart-case --no-heading --color=always --follow -g \'!.git/\''.shellescape(<q-args>),
" \   1,
" \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
" \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
" \   <bang>0)

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
