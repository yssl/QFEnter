" File:         autoload/QFEnter.vim
" Description:  A vim plugin for intuitive file opening from Quickfix window.
" Author:       yssl <http://github.com/yssl>
" License:      MIT License

" functions
function! QFEnter#OpenQFItemAtPrevWin()
	let lnumqf = line('.')
	execute 'wincmd p'
	let cc_cmd = substitute(g:qfenter_cc_cmd, '#', lnumqf, "")
	execute cc_cmd
endfunction

function! QFEnter#VOpenQFItemAtPrevWin()
	let lnumqf = line('.')
	execute 'wincmd p'
	execute 'vnew'
	let cc_cmd = substitute(g:qfenter_cc_cmd, '#', lnumqf, "")
	execute cc_cmd
endfunction

function! QFEnter#HOpenQFItemAtPrevWin()
	let lnumqf = line('.')
	execute 'wincmd p'
	execute 'new'
	let cc_cmd = substitute(g:qfenter_cc_cmd, '#', lnumqf, "")
	execute cc_cmd
endfunction

