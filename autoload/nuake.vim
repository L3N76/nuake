" ============================================================================
" File:			autoload/nuake.vim
" Description:	A Quake-style terminal panel for Neovim.
" Author:		Lenovsky <lenovsky@pm.me>
" Source:		https://github.com/Lenovsky/nuake
" Licence:		MIT
" Version:		0.0
" ============================================================================

" Window management {{{1
function! nuake#ToggleWindow() abort "{{{2
	let l:nuake_win_nr = bufwinnr('Nuake')

	if l:nuake_win_nr != -1
		call s:CloseWindow()
	else
		call s:OpenWindow()
	endif
endfunction

function! s:OpenWindow() abort "{{{2
	let l:nuake_buf_nr = bufnr('Nuake')

	if g:nuake_position == 0
		let mode = ''
		let size = float2nr(g:nuake_size * floor(&lines - 2))
	else
		let mode = 'vertical '
		let size = float2nr(g:nuake_size * floor(&columns))
	endif

	exe  'silent keepalt ' . 'botright ' . mode . size . 'split ' . 'Nuake'

	if l:nuake_buf_nr != -1
		exe  'buffer ' . l:nuake_buf_nr
	else
		call termopen($SHELL)
		file Nuake
	endif

	call s:InitWindow()
endfunction

function! s:InitWindow() abort "{{{2
	" Statusline-local options
	if exists('g:loaded_airline') &&
				\ index(g:airline_statusline_funcrefs, function('nuake#Airline')) < 0
		call airline#add_statusline_func('nuake#Airline')
	else
		setlocal statusline=\ NUAKE
		setlocal statusline+=\ %{b:term_title}
		setlocal statusline+=%=
		setlocal statusline+=\[%{&fileformat}\]
		setlocal statusline+=\ %p%%
		setlocal statusline+=\ %l:%c
	endif

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

function! s:CloseWindow() abort "{{{2
	let l:nuake_win_nr = bufwinnr('Nuake')

	if winnr() == l:nuake_win_nr
		if winbufnr(2) != -1
			hide
		endif
	else
		let l:current_buf_nr = bufnr('%')
		exe l:nuake_win_nr . 'wincmd w'
		close

		let l:win_num = bufwinnr(l:current_buf_nr)
		if winnr() != l:win_num
			exe l:win_num . 'wincmd w'
		endif
	endif
endfunction

function! s:ResizeWindow() abort "{{{2
	let l:nuake_win_nr = bufwinnr('Nuake')
	let l:height = float2nr(0.25 * floor(&lines - 2))

	exe l:nuake_win_nr . 'resize ' . l:height
endfunction

function! s:LastStandingWindow() abort "{{{2
	if winbufnr(2) == -1
		if tabpagenr('$') == 1
			bdelete
			quit
		else
			close
		endif
	endif
endfunction

" Extensions suppport{{{1
function! nuake#Airline(...) abort "{{{
	if &filetype == 'nuake'

		" Left side setup
		let w:airline_section_a = 'NUAKE'
		let w:airline_section_b = ''
		let w:airline_section_c = '%{b:term_title}'
		let w:airline_render_left = 1

		" Right side setup
		let w:airline_section_x = ''
		let w:airline_render_right = 1
		return 0
	endif
endfunction

" Autocomands{{{1
augroup NuakeLastStandingWindow
	autocmd!
	autocmd BufEnter Nuake nested call s:LastStandingWindow()
augroup END

augroup NuakeResizeWindow
	autocmd!
	autocmd VimResized *
				\ if bufwinnr('Nuake') |
				\ call s:ResizeWindow() |
				\ redraw |
				\ endif
augroup END

" Modeline {{{1
" vim: ts=4 sw=4 sts=4 noet foldenable foldmethod=marker
