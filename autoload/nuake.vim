" ============================================================================
" File:        autoload/nuake.vim
" Description: A Quake-style terminal panel for Neovim.
" Author:      Lenovsky <lenovsky@protonmail.ch>
" Source:      https://github.com/Lenovsky/nuake
" Licence:     MIT
" Version:     0.0
" ============================================================================

" Window management {{{1
" nuake#ToggleWindow() {{{2
function! nuake#ToggleWindow()
    let nuakewinnr = bufwinnr('Nuake')

    if nuakewinnr != -1
        call nuake#CloseWindow()
        return
    endif

    call nuake#OpenWindow()
endfunction

" nuake#OpenWindow() {{{2
function! nuake#OpenWindow()
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
    call nuake#InitWindow()
endfunction

" nuake#InitWindow() {{{2
function! nuake#InitWindow()

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

" nuake#CloseWindow() {{{2
function! nuake#CloseWindow()
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

" nuake#ResizeWindow() {{{2
function! nuake#ResizeWindow()
    let nuakewinnr = bufwinnr('Nuake')
    let height = float2nr(0.25 * floor(&lines - 2))

    exe nuakewinnr . 'resize ' . height
endfunction

" nuake#LastStandingWindow() {{{2
function! nuake#LastStandingWindow()
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
function! nuake#Airline(...)
    if &filetype == 'nuake'
        let w:airline_section_a = 'NUAKE'
        let w:airline_section_b = '%{b:term_title}'
        let w:airline_section_c = ''
    endif
endfunction

" Autocomands{{{1
augroup NuakeLastStandingWindow
    autocmd!
    autocmd BufEnter Nuake nested call nuake#LastStandingWindow()
augroup END

augroup NuakeResizeWindow
    autocmd!
    autocmd VimResized *
                \ if bufwinnr('Nuake') |
                \ call nuake#ResizeWindow() |
                \ redraw |
                \ endif
augroup END

augroup NuakeAirline
    autocmd BufNew Nuake nested
                \ if exists('g:loaded_airline') |
                \ call airline#add_statusline_func('nuake#Airline') |
                \ endif
augroup END

" Modeline {{{1
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker foldcolumn=1
