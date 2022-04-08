" autoload/nuake.vim

" Window management {{{1
function! nuake#ToggleWindow() abort "{{{2
    let l:nuake_win_nr = bufwinnr(s:NuakeBufNr())

    if l:nuake_win_nr == winnr()
        call s:CloseWindow()
    elseif l:nuake_win_nr != -1
        execute l:nuake_win_nr . "wincmd w"
    else
        call s:OpenWindow()
    endif
endfunction

function! s:OpenWindow() abort "{{{2
    let l:nuake_buf_nr = bufnr(s:NuakeBufNr())

    execute  'silent keepalt ' . s:NuakeLook() . 'split'

    if l:nuake_buf_nr != -1
        execute  'buffer ' . l:nuake_buf_nr
    else
        let l:vim_options = has('terminal') ? '++curwin ++kill=kill' : ''

        execute  'terminal' . l:vim_options
        call s:InitWindow()
        call s:NuakeBufNr()
    endif

endfunction

function! s:InitWindow() abort "{{{2
    " Buffer-local options
    setlocal filetype=nuake
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodified

    " Window-local options
    setlocal nolist
    setlocal nowrap
    setlocal winfixwidth
    setlocal winfixheight
    setlocal nospell
    setlocal nonumber
    setlocal norelativenumber
    setlocal nofoldenable
    setlocal foldcolumn=0
endfunction

function! s:CloseWindow() abort "{{{2
    let l:nuake_win_nr = bufwinnr(s:NuakeBufNr())

    if winnr() == l:nuake_win_nr
        if winbufnr(2) != -1
            close
        endif
    else
        let l:current_buf_nr = bufnr('%')
        execute l:nuake_win_nr . 'wincmd w'
        close

        let l:win_num = bufwinnr(l:current_buf_nr)
        if winnr() != l:win_num
            execute l:win_num . 'wincmd w'
        endif
    endif
endfunction

function! s:ResizeWindow() abort "{{{2
    let l:nuake_win_nr = bufwinnr(s:NuakeBufNr())

    execute l:nuake_win_nr . 'resize ' . s:NuakeLook()
endfunction

function! s:LastStandingWindow() abort "{{{2
    if g:nuake_close_if_last_standing == 1
        let l:nuake_win_nr = bufwinnr(s:NuakeBufNr())

        if winnr('$') < 2 && l:nuake_win_nr != -1
            if tabpagenr('$') < 2
                bdelete!
                quit
            else
                close
            endif
        endif
    endif
endfunction

" Helpers {{{1
function! s:NuakeBufNr() abort "{{{2
    if g:nuake_per_tab == 0
        if !exists('s:nuake_buf_nr')
            let s:nuake_buf_nr = -1
        elseif &filetype == 'nuake' && s:nuake_buf_nr == -1
            let s:nuake_buf_nr = bufnr('%')
        endif
        return s:nuake_buf_nr
    else
        if !exists('t:nuake_buf_nr')
            let t:nuake_buf_nr = -1
        elseif &filetype == 'nuake' && t:nuake_buf_nr == -1
            let t:nuake_buf_nr = bufnr('%')
        endif
        return t:nuake_buf_nr
    endif
endfunction

function! s:NuakeLook() abort "{{{2
    let l:nuake_win_nr = bufwinnr(s:NuakeBufNr())

    if g:nuake_position == 'bottom'
        let l:mode = 'botright '
        let l:size = float2nr(g:nuake_size * floor(&lines - 2))
    elseif g:nuake_position == 'right'
        let l:mode = l:nuake_win_nr != -1 ? '' : 'botright vertical '
        let l:size = float2nr(g:nuake_size * floor(&columns))
    elseif g:nuake_position == 'top'
        let l:mode = 'topleft '
        let l:size = float2nr(g:nuake_size * floor(&lines - 2))
    elseif g:nuake_position == 'left'
        let l:mode = l:nuake_win_nr != -1 ? '' : 'topleft vertical '
        let l:size = float2nr(g:nuake_size * floor(&columns))
    endif

    let l:nuake_look = l:mode . l:size

    return l:nuake_look
endfunction

function! s:NuakeCloseTab() abort "{{{2
    if s:temp_nuake_buf_nr > -1
        execute 'bdelete! ' . s:temp_nuake_buf_nr
        unlet s:temp_nuake_buf_nr
    endif
endfunction
"
" Autocomands {{{1
augroup nuake_start_insert
    autocmd!
    autocmd FileType,BufEnter *
                \ if &filetype == 'nuake' && (g:nuake_start_insert == 1) |
                \ execute 'silent! normal i' |
                \ endif
augroup END

augroup nuake_last_standing_window
    autocmd!
    autocmd BufEnter * nested call s:LastStandingWindow()
augroup END

augroup nuake_tab_close
    if g:nuake_per_tab == 1
        autocmd!
        autocmd TabLeave * let s:temp_nuake_buf_nr = bufnr(s:NuakeBufNr())
        autocmd TabClosed * call s:NuakeCloseTab()
    endif
augroup END

augroup nuake_term_killed
    autocmd!
    autocmd BufDelete *
                \ if bufnr(s:NuakeBufNr()) == -1 |
                \ let s:nuake_buf_nr = -1 |
                \ let t:nuake_buf_nr = -1 |
                \ endif
augroup END

augroup nuake_resize_window
    autocmd!
    autocmd VimResized *
                \ if bufwinnr(s:NuakeBufNr()) != -1 |
                \ call s:ResizeWindow() |
                \ redraw |
                \ endif
augroup END

" Modeline {{{1
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker
