" plugin/nuake.vim

" Plugin Guards: {{{1

if exists("g:loaded_nuake") || ( !has('nvim') && !has('patch-8.0.1593') )
  finish
endif
let g:loaded_nuake = 1

" }}}

" User Options: {{{1

let s:options = [
            \ ['position'              , 'bottom'],
            \ ['size'                  , 0.25],
            \ ['per_tab'               , 0],
            \ ['close_if_last_standing', 1],
            \ ['start_insert'          , 1],
            \ ]

for [opt, val] in s:options
    if !exists('g:nuake_' . opt)
        execute 'let g:nuake_' . opt . ' = ' . string(val)
    endif
endfor

" }}}

" Commands And Mappings: {{{1

command! -nargs=0 Nuake call nuake#ToggleWindow()

nnoremap <silent> <Plug>Nuake :Nuake<CR>
inoremap <silent> <Plug>Nuake <C-\><C-n>:Nuake<CR>
tnoremap <silent> <Plug>Nuake <C-\><C-n>:Nuake<CR>
tnoremap          <Esc>       <C-\><C-n>
tnoremap <expr>   <C-R>       '<C-\><C-N>"'.nr2char(getchar()).'pi'

if !hasmapto('<Plug>Nuake', 'n')
  nmap <unique> <F4> <Plug>Nuake
endif
if !hasmapto('<Plug>Nuake', 'i')
  imap <unique> <F4> <Plug>Nuake
endif
if !hasmapto('<Plug>Nuake', 't')
  tmap <unique> <F4> <Plug>Nuake
endif

" }}}

" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker
