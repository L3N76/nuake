" plugin/nuake.vim

"Initialization {{{1
if !has('nvim') && !has('patch-8.0.1593')
    echohl WarningMsg
    echomsg 'Nuake: Nuake requires Neovim or Vim >= 8.0.1593'
    echohl None
    finish
endif

let s:options = [
            \ ['position', 'bottom'],
            \ ['size', 0.25],
            \ ['per_tab', 0],
            \ ['close_if_last_standing', 1],
            \ ['start_insert', 1],
            \ ]

for [opt, val] in s:options
    if !exists('g:nuake_' . opt)
        execute 'let g:nuake_' . opt . ' = ' . string(val)
    endif
endfor

" Commands {{{1
command! -nargs=0 Nuake call nuake#ToggleWindow()

" Modeline {{{1
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker
