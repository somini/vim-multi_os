" multi_os: Detect the OS and run different initialization scripts
" Maintainer:  somini <https://github.com/somini>
" Version:     1.0

" Script guard and default variables {{{
if exists('g:loaded_multi_os')
	finish
endif
let g:loaded_multi_os = 1
"}}}

" Internal Functions {{{
function s:src_vimrc()
	execute 'source' g:os_vimrc
endfunction
function s:src_gvimrc()
	" Don't source it when the GUI is not running
	if has('gui_running')
		execute 'source' g:os_gvimrc
	endif
endfunction
"}}}

" OS detection {{{
" Shameless ripoff: https://vi.stackexchange.com/a/2577
if has('win32') || has('win64') || has('win16')
	let g:os = 'Windows'
elseif has('unix') "All the unices, MacOS X included
	" Just use `uname`, deleting the last newline
	let g:os = substitute(system('uname'), '\n$','', '')
else
	finish " Unsupported, I can't make any guarantees
endif
"}}}

" VIM Directory detection{{{
" Source: :help vimrc
if exists(g:user_dir) "Define this if you have a non-standard location
	let g:vim_dir = g:user_dir
endif
if g:os == 'Windows'
	let g:vim_dir=expand('~/vimfiles')
elseif g:os == 'Linux' || g:os == 'Darwin'
	let g:vim_dir=$HOME.'/.vim'
else
	finish " Unsupported, I can't make any guarantees
endif
"}}}

" OS-Specific sourcing {{{
let s:local_vimrc = g:vim_dir.'/vimrc.'.g:os
let s:local_gvimrc = g:vim_dir.'/gvimrc.'.g:os
if filereadable(s:local_vimrc) "vimrc
	let g:os_vimrc = s:local_vimrc
	" After the vimrc
	call <SID>src_vimrc()
endif
if filereadable(s:local_gvimrc) "gvimrc
	let g:os_gvimrc = s:local_gvimrc
	augroup multi_os
		" After the gvimrc
		autocmd GUIEnter * call s:src_gvimrc()
	augroup END
endif
"}}}

" Modeline and other administrativia {{{
" vim: ft=vim:fdm=marker:ts=2:sw=2
