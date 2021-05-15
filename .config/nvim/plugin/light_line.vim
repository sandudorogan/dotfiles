
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


