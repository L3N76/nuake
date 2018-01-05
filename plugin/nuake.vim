" ============================================================================
" File:        nuake.vim
" Description: A Quake-style terminal panel for Neovim.
" Author:      Lenovsky <lenovsky@protonmail.ch>
" Source:      https://github.com/Lenovsky/nuake
" Licence:     MIT
" Version:     0.0
" ============================================================================

"Initialization {{{1

if !has('nvim')
    echohl WarningMsg
    echomsg 'Nuake: Nuake requires Neovim'
    echohl None
    finish
endif

" Window management {{{1
" s:ToggleWindow() {{{2
function! s:ToggleWindow()
    let nuakewinnr = bufwinnr('Nuake')

    if nuakewinnr != -1
        call s:CloseWindow()
        return
    endif

    call s:OpenWindow()
endfunction

" s:OpenWindow() {{{2
function! s:OpenWindow()
    "FIXME: Add option to set Nuake initial size
    "       Add option to change Nuake position

    let nuakewinnr = bufwinnr('Nuake')
    let nuakebufnr = bufnr('Nuake')
    let height = float2nr(0.25 * floor(&lines - 2))

    exe  'silent keepalt ' . 'botright ' . height . 'split ' . 'Nuake'
    exe  'silent ' . 'resize ' . height

    "FIXME: Not quite elegent
    try
        exe  'buffer ' . nuakebufnr
    catch
        call termopen($SHELL)
        file Nuake
    endtry
    call s:InitWindow()
endfunction

" s:InitWindow() {{{2
function! s:InitWindow()

    " Buffer-local options
    setlocal filetype=nuake
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted

    " Window-local options
    setlocal nolist
    setlocal nowrap
    setlocal winfixwidth
    setlocal nospell
    setlocal nonumber
    setlocal norelativenumber
    setlocal nofoldenable
    setlocal foldcolumn=0

    startinsert!
endfunction

" s:CloseWindow() {{{2
function! s:CloseWindow()
    let nuakewinnr = bufwinnr('Nuake')

    if nuakewinnr == -1
        return
    endif

    if winnr() == nuakewinnr
        if winbufnr(2) != -1
            hide
        endif
    else
        let curbufnr = bufnr('%')
        exe nuakewinnr . 'wincmd w'
        close

        let winnum = bufwinnr(curbufnr)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
    endif
endfunction

" s:ResizeWindow() {{{2
function! s:ResizeWindow()
    let nuakewinnr = bufwinnr('Nuake')
    let height = float2nr(0.25 * floor(&lines - 2))

    exe nuakewinnr . 'resize ' . height
endfunction

" s:LastStandingWindow() {{{2
function! s:LastStandingWindow()
    if winbufnr(2) == -1
        if tabpagenr('$') == 1
            bdelete
            quit
        else
            close
        endif
    endif
endfunction
" Extensions support{{{1
" vim-airline{{{2
function! Nuake(...)
    if &filetype == 'nuake'
        let w:airline_section_a = 'Nuake'
        let w:airline_section_b = '%{b:term_title}'
        let w:airline_section_c = ''
    endif
endfunction

if exists('g:loaded_airline')
    autocmd VimEnter * call airline#add_statusline_func('Nuake')
endif

" Commands {{{1
" Automatic{{{2
augroup nuake
    autocmd!
    autocmd BufEnter Nuake nested call s:LastStandingWindow()
    autocmd VimResized *
                \ if bufwinnr('Nuake') |
                \ call s:ResizeWindow() |
                \ redraw |
                \ endif
augroup END

" Manual{{{2
command! -nargs=0 Nuake         call s:ToggleWindow()
command! -nargs=0 NuakeToggle   call s:ToggleWindow()
command! -nargs=0 NuakeOpen     call s:OpenWindow()
command! -nargs=0 NuakeClose    call s:CloseWindow()

" Modeline {{{1
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker foldcolumn=1
