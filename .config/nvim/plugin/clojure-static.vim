let g:clojure_align_multiline_strings = 1
let g:clojure_align_subforms = 1
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_blacklist = [
            \   '-fn$', 
            \   '\v^with-%(meta|out-str|loading-context)$'
            \ ]
let g:clojure_fuzzy_indent_patterns = [
            \   '^GET', 
            \   '^POST', 
            \   '^PUT', 
            \   '^DELETE', 
            \   '^ANY', 
            \   '^HEAD', 
            \   '^PATCH', 
            \   '^OPTIONS', 
            \   '^with', 
            \   '^def', 
            \   '^let', 
            \   '-tpl$'
            \ ]
let g:clojure_maxlines = 0
let g:clojure_special_indent_words = 'deftype,defrecord,reify,proxy,extend-type,extend-protocol,letfn'

autocmd FileType clojure setlocal lispwords+=describe,it,testing,facts,fact,provided
