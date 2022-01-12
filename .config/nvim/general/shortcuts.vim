" --------------------------- Keyboard shortcuts -----------------------------


nnoremap <leader>h :call ToggleHiddenAll()<CR>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>vs :vsplit<CR>
nnoremap <leader>hs :split<CR>
nnoremap <leader>bn :bnext<CR>:redraw<CR>
nnoremap <leader>bp :bprevious<CR>:redraw<CR>

" Perform dot commands over visual blocks:
vnoremap . :normal .<CR>
 
" FZF:
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>
nnoremap <C-b> :Buffers<CR>

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Convert slashes to backslashes for Windows.
if has('win32')
  nmap <leader>yfs :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap <leader>yfl :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>

  " This will copy the path in 8.3 short format, for DOS and Windows 9x
  nmap <leader>yf8 :let @*=substitute(expand("%:p:8"), "/", "\\", "g")<CR>
else
  nmap <leader>yfs :let @*=expand("%")<CR>
  nmap <leader>yfl :let @*=expand("%:p")<CR>
endif
