" ============================================================================
" File:			autoload/nuake.vim
" Description:	A Quake-style terminal panel for Neovim.
" Author:		Lenovsky <lenovsky@protonmail.ch>
" Source:		https://github.com/Lenovsky/nuake
" Licence:		MIT
" Version:		0.0
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
	let nuakebufnr = bufnr('Nuake')

	if g:nuake_position == 0
		let mode = ''
		let size = float2nr(g:nuake_size * floor(&lines - 2))
	else
		let mode = 'vertical '
		let size = float2nr(g:nuake_size * floor(&columns))
	endif

	exe  'silent keepalt ' . 'botright ' . mode . size . 'split ' . 'Nuake'

	if nuakebufnr != -1
		exe  'buffer ' . nuakebufnr
	else
		call termopen($SHELL)
		file Nuake
	endif

	call nuake#InitWindow()
endfunction

" nuake#InitWindow() {{{2
function! nuake#InitWindow()

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

" nuake#CloseWindow() {{{2
function! nuake#CloseWindow()
	let nuakewinnr = bufwinnr('Nuake')

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
" Extensions suppport{{{1
" nuake#Airline(){{{2
function! nuake#Airline(...)
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

" Modeline {{{1
" vim: ts=4 sw=4 sts=4 noet foldenable foldmethod=marker
