" multi_os: Detect the OS and run different initialization scripts
" Maintainer:  somini <https://github.com/somini>
" Version:     1.0

" Script guard and default variables {{{
if exists('g:loaded_multi_os')
	finish
endif
let g:loaded_multi_os = 1
"}}}

" Internal Functions and Variables {{{
let s:plugin_dir_name = 'bundle'

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
else
	if g:os == 'Windows'
		let g:vim_dir=expand('~/vimfiles')
	elseif g:os == 'Linux' || g:os == 'Darwin'
		let g:vim_dir=$HOME.'/.vim'
	else
		finish " Unsupported, I can't make any guarantees
	endif
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

" OS-Specific folders and plugins {{{
let s:local_dir = g:vim_dir.'/multi_os/'.g:os

if !filereadable(s:local_dir) "Don't do anything if there's a file there
	if !isdirectory(s:local_dir)
		call mkdir(s:local_dir, 'p') "Create the directory if it doesn't exist
	endif
	let g:os_dir = s:local_dir

	" Set up the "bundle" folder as a OS-specific plugin folder
	" Only works for pathogen
	let s:local_dir_plugin = s:local_dir.'/'.s:plugin_dir_name
	if exists('*pathogen#surround') && isdirectory(s:local_dir_plugin)
		call pathogen#surround(s:local_dir_plugin.'/{}')
	endif
endif
"}}}

" Modeline and other administrativia {{{
" vim: ft=vim:fdm=marker:ts=2:sw=2
