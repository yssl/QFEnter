" File:         autoload/QFEnter.vim
" Description:  A vim plugin for intuitive file opening from Quickfix window.
" Author:       yssl <http://github.com/yssl>
" License:      MIT License

" functions
function! QFEnter#OpenQFItem()
	let lnumqf = line('.')
	execute 'wincmd p'
	let cc_cmd = substitute(g:qfenter_cc_cmd, '##', lnumqf, "")
	execute cc_cmd
endfunction

function! QFEnter#VOpenQFItem()
	let lnumqf = line('.')
	execute 'wincmd p'
	execute 'vnew'
	let cc_cmd = substitute(g:qfenter_cc_cmd, '##', lnumqf, "")
	execute cc_cmd
endfunction

function! QFEnter#HOpenQFItem()
	let lnumqf = line('.')
	execute 'wincmd p'
	execute 'new'
	let cc_cmd = substitute(g:qfenter_cc_cmd, '##', lnumqf, "")
	execute cc_cmd
endfunction

function! QFEnter#TTOpenQFItem()
	let lnumqf = line('.')
	execute 'tabnew'
	let cc_cmd = substitute(g:qfenter_cc_cmd, '##', lnumqf, "")
	execute cc_cmd
endfunction

