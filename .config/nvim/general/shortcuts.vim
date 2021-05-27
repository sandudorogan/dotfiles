" --------------------------- Keyboard shortcuts -----------------------------


nnoremap <leader>h :call ToggleHiddenAll()<CR>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>vs :vsplit<CR>
nnoremap <leader>hs :split<CR>
nnoremap <leader>bn :bnext<CR>:redraw<CR>
nnoremap <leader>bp :bprevious<CR>:redraw<CR>

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

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
